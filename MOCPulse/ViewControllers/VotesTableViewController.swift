//
//  VotesTableViewController.swift
//  MOCPulse
//
//  Created by proger on 7/4/15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import UIKit

class VotesTableViewController : UITableViewController, UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocalObjectsManager.sharedInstance.votes.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VoteCell", forIndexPath: indexPath) as! UITableViewCell
        var obj: VoteModel = LocalObjectsManager.sharedInstance.votes[indexPath.row] as! VoteModel;
        
        
        cell.textLabel?.text = obj.name;
        return cell
    }
}
