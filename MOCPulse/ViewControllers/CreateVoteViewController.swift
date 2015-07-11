//
//  CreateVoteViewController.swift
//  MOCPulse
//
//  Created by proger on 7/11/15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import Foundation
import UIKit

class CreateVoteViewController : UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var voteTextView: UITextView!
    @IBOutlet weak var charsLeftLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        UIKeyboardDidShowNotification
        
        self.voteTextView.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)

        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.voteTextView.becomeFirstResponder()
    }
    
    @IBAction func createButtonClicked(sender: AnyObject) {
        var voteText = self.voteTextView.text
        // send to server
    }
    
    func setupView() {
        textViewDidChange(self.voteTextView)
        
        var vWidth = self.view.frame.width
        
        self.createButton.frame = CGRectMake(0, self.createButton.frame.origin.y, vWidth, self.createButton.frame.height)
        self.charsLeftLabel.frame = CGRectMake(0, self.charsLeftLabel.frame.origin.y, vWidth, self.charsLeftLabel.frame.height)
        self.voteTextView.frame = CGRectMake(0, self.voteTextView.frame.origin.y, vWidth, self.voteTextView.frame.height)
    }
    
    func textViewDidChange(textView: UITextView) {
        if (self.voteTextView == textView) {
            calculateCharsLeft()
        }
    }
    
    func keyboardWasShown(aNotification: NSNotification)
    {
        var info : NSDictionary = aNotification.userInfo!
        var val : NSValue = info[UIKeyboardFrameEndUserInfoKey] as! NSValue
        var kbWindowRect : CGRect = CGRect(x: 0,y: 0,width: 0,height: 0)
        val.getValue(&kbWindowRect)
        self.view.window!.convertRect(kbWindowRect, fromWindow:nil)
        var kbRect = self.view.convertRect(kbWindowRect, fromView: nil)
        
        // moving button and label to the top of keyboard
        self.createButton.frame = CGRectMake(0, kbRect.origin.y - self.createButton.frame.height, self.view.frame.width, self.createButton.frame.height)
        self.charsLeftLabel.frame = CGRectMake(0, kbRect.origin.y - self.charsLeftLabel.frame.height - self.createButton.frame.height - 10, self.view.frame.width, self.charsLeftLabel.frame.height)
    }
    
    func calculateCharsLeft() {
        var charsLeft = 140 - count(self.voteTextView.text)
        
        var notEnoughChars : Bool = charsLeft < 0
        
        self.charsLeftLabel.text = NSString(format: "Chars left - %d.", notEnoughChars ? 0 : charsLeft) as String
        
        if (notEnoughChars) {
            var voteNameText : String = self.voteTextView.text!
            let stringLength = count(voteNameText)
            voteNameText = voteNameText.substringToIndex(advance(voteNameText.startIndex, 140))
            self.voteTextView.text = voteNameText
        }
    }
}
