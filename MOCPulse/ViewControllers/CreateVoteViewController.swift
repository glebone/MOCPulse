//
//  CreateVoteViewController.swift
//  MOCPulse
//
//  Created by proger on 7/11/15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class CreateVoteViewController : UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var voteTextView: UITextView!
    @IBOutlet weak var charsLeftLabel: UILabel!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let voteText : String! = self.voteTextView.text
        // send to server
        
        if (voteText.characters.count > 0) {
            
            let progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            
            VoteModel.createVote(voteText, completion: { (vote) -> Void in
                
                progressHUD.hide(true)
                
                self.navigationController!.popViewControllerAnimated(true)
                NSNotificationCenter.defaultCenter().postNotificationName("GET_ALL_VOTES", object: nil)
                print(vote)
            })
        }
        else {
            UIAlertView(title: "Error", message: "Vote body can't be blank", delegate: nil, cancelButtonTitle: "Ok").show()
        }
    }
    
    func setupView() {
        textViewDidChange(self.voteTextView)
    }
    
    func textViewDidChange(textView: UITextView) {
        if (self.voteTextView == textView) {
            calculateCharsLeft()
        }
    }
    
    func keyboardWasShown(aNotification: NSNotification)
    {
        var info = aNotification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height
        })
    }
    
    func calculateCharsLeft() {
        let maxChars = 140
        let charsLeft = maxChars - self.voteTextView.text.characters.count
        
        let notEnoughChars : Bool = charsLeft < 0
        
        self.charsLeftLabel.text = NSString(format: "Chars left - %d.", notEnoughChars ? 0 : charsLeft) as String
        
        if (notEnoughChars) {
            var voteNameText : String = self.voteTextView.text!
            voteNameText = voteNameText.substringToIndex(voteNameText.startIndex.advancedBy(maxChars))
            self.voteTextView.text = voteNameText
        }
    }
}
