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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        addRightNavItemOnView()
        
        setupButton(pendingButton)
        setupButton(votedButton)
        
        pendingButton.selected = true
        votedButton.selected = false
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
        return 50
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
        
        cell!.textLabel?.text = "\(indexPath.row)"
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
//MARK: actions
    
    @IBAction func pendingAction()
    {
        votedButton.selected = false
        pendingButton.selected = true
    }
    
    @IBAction func votedAction()
    {
        votedButton.selected = true
        pendingButton.selected = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
