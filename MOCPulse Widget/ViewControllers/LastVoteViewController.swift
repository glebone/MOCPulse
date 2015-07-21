//
//  LastVoteViewController.swift
//  MOCPulse
//
//  Created by Admin on 12.07.15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import UIKit
import NotificationCenter

class LastVoteViewController: UIViewController, NCWidgetProviding {

    let viewHeight : CGFloat = 150.0
    
    var vote : VoteModel!
    
    @IBOutlet var question: UILabel!
    @IBOutlet var author: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var greenButton: UIButton!
    @IBOutlet var yellowButton: UIButton!
    @IBOutlet var redButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateSize()
        setupView()
    }
    
    func setupView() {
        self.question.text = vote.name
        self.author.text = vote.owner
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        var dateString = dateFormatter.stringFromDate(vote.create!)
        
        self.date.text = dateString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateSize()
    }
    
    func updateSize() {
        var preferredSize = self.preferredContentSize
        preferredSize.height = viewHeight
        self.preferredContentSize = preferredSize
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        completionHandler(NCUpdateResult.NewData)
    }
    
    @IBAction func greenButtonPressed(sender: AnyObject) {
        let url:NSURL = NSURL(string: NSString(format: "mocpulse://vote/green/%@", vote.id!) as String)!
        extensionContext!.openURL(url, completionHandler: nil)
    }
    
    @IBAction func yellowButtonPressed(sender: AnyObject) {
        let url:NSURL = NSURL(string: NSString(format: "mocpulse://vote/yellow/%@", vote.id!) as String)!
        extensionContext!.openURL(url, completionHandler: nil)
    }
    
    @IBAction func redButtonPressed(sender: AnyObject) {
        let url:NSURL = NSURL(string: NSString(format: "mocpulse://vote/red/%@", vote.id!) as String)!
        extensionContext!.openURL(url, completionHandler: nil)
    }
    
}
