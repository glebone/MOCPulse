//
//  VotesListViewController.swift
//  MOCPulse
//
//  Created by Paul Kovalenko on 04.07.15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import UIKit
import OAuthSwift

class VotesListViewController: UIViewController , UITableViewDataSource , UITableViewDelegate, UIGestureRecognizerDelegate
{
    @IBOutlet var pendingButton : UIButton!
    @IBOutlet var votedButton : UIButton!
    
    @IBOutlet var tableView : UITableView!

    var colorChart : ColorChart!
    var votes : [VoteModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("fetchVotesList"), name: "GET_ALL_VOTES", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleLoadNotification:"), name: "NOTIFICATION_SHOW_VIEW", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTable:", name:"reloadVotes", object: nil)
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "handleSwipes:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "handleSwipes:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var manager : LocalObjectsManager = LocalObjectsManager.sharedInstance
        if (manager.user != nil) {
            self.fetchVotesList()
        }
    }
    
    func fetchVotesList() {
        VoteModel.votes { (votesList) -> Void in
            self.votes = votesList
            LocalObjectsManager.sharedInstance.votes = votesList;
            
            self.tableView.reloadData()
            
            UIApplication.sharedApplication().applicationIconBadgeNumber = self.tableArray().count
        }
    }
    
    func setupView() {
        addRightNavItemOnView()
        
        setupButton(pendingButton)
        setupButton(votedButton)
        
        pendingButton.selected = true
        votedButton.selected = false
    }
    
    func tableArray() -> NSArray {
        if self.votes != nil {
            var votesArray = self.votes?.filter{(vote:VoteModel) in vote.voted != self.pendingButton.selected}
            var arrayToSort = NSArray(array: votesArray!)
            
            var descriptor: NSSortDescriptor = NSSortDescriptor(key: "create", ascending: false)
            
            var arraySorted: NSArray = arrayToSort.sortedArrayUsingDescriptors([descriptor])

            return arraySorted
        }
        return NSArray()
    }
    
    func setupButton(button : UIButton) {
        button.setColorState(UIColor(red: 194.0/255, green: 194.0/255, blue: 194.0/255, alpha: 1.0), state: UIControlState.Selected)
        button.setColorState(UIColor(red: 76.0/255, green: 76.0/255, blue: 76.0/255, alpha: 1.0), state: UIControlState.Normal)
        
        button.setTitleColor(UIColor(red: 37.0/255, green: 37.0/255, blue: 37.0/255, alpha: 1.0), forState: UIControlState.Selected)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
    func addRightNavItemOnView()
    {
        let createViewButton = UIView(frame: CGRectMake(0, 0, 85, 40))
        let imageView = UIImageView(image: UIImage(named:"plusImage"))
        imageView.frame = CGRectMake(60, 7, 25, 25)
        
        let label = UILabel(frame: CGRectMake(0, 0, 60, 40))
        label.text = "New";
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Right
        
        createViewButton.addSubview(label)
        createViewButton.addSubview(imageView)
        
        let tapOnCreate = UITapGestureRecognizer(target: self, action: Selector("rightNavItemCreateClick:"))
        tapOnCreate.delegate = self
        createViewButton.addGestureRecognizer(tapOnCreate)

        var rightBarButtonItemDelete: UIBarButtonItem = UIBarButtonItem(customView: createViewButton)
        
        self.navigationItem.setRightBarButtonItem(rightBarButtonItemDelete, animated: false)
    }
    
    func rightNavItemCreateClick(sender: UITapGestureRecognizer)
    {
        performSegueWithIdentifier("showCreateView", sender: nil)
    }
    
    func handleLoadNotification(notification: NSNotification) {
        var vote = (notification.userInfo as! [NSString:VoteModel])["vote"]
        if vote != nil {
            presentDetailViewForVote(vote!)
        } else {
            var voteId = (notification.userInfo as! [NSString:NSString])["voteId"]
            if voteId != nil {
                VoteModel.voteByID(voteId! as String, completion: { (newVote) -> Void in
                    if newVote != nil {
                        self.presentDetailViewForVote(newVote!)
                    }
                })
            }
        }
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.Right:
            self.votedAction()
        case UISwipeGestureRecognizerDirection.Left:
            self.pendingAction()
        default:
            break
        }
    }
    
    func updateTable(notification: NSNotification) {
        self.votes = LocalObjectsManager.sharedInstance.votes
        self.tableView.reloadData()
    }
    
//MARK: tableview
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var votesList = self.tableArray()
        
        return votesList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var footer = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 0.5))
        footer.backgroundColor = UIColor(red: 138.0/255, green: 138.0/255, blue: 138.0/255, alpha: 1)
        return footer
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("VoteCell") as? VoteCell
        
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("VoteCell", owner: nil, options: nil)[0] as? VoteCell
        }
        
        var votesList = self.tableArray()

        cell?.setupWithVote(votesList[indexPath.row] as! VoteModel)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var votesList = self.tableArray()
        presentDetailViewForVote(votesList[indexPath.row] as! VoteModel)
    }
    
//MARK: actions
    
    func presentDetailViewForVote(vote: VoteModel) {
        let detailsVC = self.storyboard!.instantiateViewControllerWithIdentifier("VoteDetailsVC") as! VoteDetailsViewController
        detailsVC.voteModel = vote
        
        self.navigationController?.popToRootViewControllerAnimated(false)
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    @IBAction func pendingAction()
    {
        votedButton.selected = false
        pendingButton.selected = true
        
        tableView.reloadData()
    }
    
    @IBAction func votedAction()
    {
        votedButton.selected = true
        pendingButton.selected = false
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
