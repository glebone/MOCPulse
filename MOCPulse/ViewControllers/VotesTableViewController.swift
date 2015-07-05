//
//  VotesTableViewController.swift
//  MOCPulse
//
//  Created by proger on 7/4/15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import UIKit

class VotesTableViewController : UITableViewController {
    var votes : [VoteModel]?
    @IBOutlet var votesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        VoteModel.votes(completion: {(data) -> Void in
            self.votes = data!;
            self.votesTableView.reloadData();
            
            LocalObjectsManager.sharedInstance.votes = self.votes;
        });
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.votes == nil) ? 0 : self.votes!.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VoteCell", forIndexPath: indexPath) as! UITableViewCell
        
        var obj: VoteModel = self.votes![indexPath.row];
        
        cell.textLabel?.text = obj.name;
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        LocalObjectsManager.sharedInstance.voteIndexSelected = indexPath.row
    }
}
