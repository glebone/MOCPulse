//
//  VotesTableViewController.swift
//  MOCPulse
//
//  Created by Admin on 12.07.15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import UIKit
import NotificationCenter

class VotesTableViewController: UITableViewController, NCWidgetProviding {

    let rowHeight : CGFloat = 40
    let maxRowCount : Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSize()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateSize()
        self.tableView.reloadData()
    }
    
    func updateSize() {
        var preferredSize = self.preferredContentSize
        preferredSize.height = rowHeight * CGFloat(getRowCount())
        self.preferredContentSize = preferredSize
    }
    
    func getRowCount() -> Int {
        return LocalObjectsManager.sharedInstance.votes!.count > maxRowCount ? maxRowCount : LocalObjectsManager.sharedInstance.votes!.count
    }
    
    // MARK: - Widget Delegate
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        updateSize()
        self.tableView.reloadData()
        completionHandler(NCUpdateResult.NewData)
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRowCount()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowHeight
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VoteCell", forIndexPath: indexPath) as! VoteTableViewCell
        println(indexPath.row)
        var vote : VoteModel = LocalObjectsManager.sharedInstance.votes![indexPath.row]
        cell.setupWithVote(vote)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let url:NSURL = NSURL(string:  NSString(format: "mocpulse://openvote/%@", LocalObjectsManager.sharedInstance.votes![indexPath.row].id!) as String)!
        extensionContext!.openURL(url, completionHandler: nil)
    }
}
