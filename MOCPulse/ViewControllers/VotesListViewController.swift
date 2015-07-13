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
        
        votes = LocalObjectsManager.sharedInstance.generationVotes(count: 50)
        LocalObjectsManager.sharedInstance.votes = votes;
        
        setupView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        var rateView = RateAlertView(ownerTitle: "Paul", voteBody: "Vote body")
        
        UIApplication.sharedApplication().keyWindow?.addSubview(rateView)
    }
    
    func setupView() {
        addRightNavItemOnView()
        
        setupButton(pendingButton)
        setupButton(votedButton)
        
        pendingButton.selected = true
        votedButton.selected = false
    }
    
    func tableArray() -> NSArray {
        var array = votes?.filter{(vote:VoteModel) in vote.voted != self.pendingButton.selected}
        
        return array!
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
        
        let detailsVC = self.storyboard!.instantiateViewControllerWithIdentifier("VoteDetailsVC") as! VoteDetailsViewController
        
        var votesList = self.tableArray()
        
        detailsVC.voteModel = votesList[indexPath.row] as! VoteModel
        
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
//MARK: actions
    
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
