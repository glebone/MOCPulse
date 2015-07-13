//
//  VoteTableViewCell.swift
//  MOCPulse
//
//  Created by Admin on 12.07.15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import UIKit

class VoteTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var coloredView: UIView!
    
    func setupView() {
        var bgView = UIView(frame: CGRectMake(0, 0, 320, 40))
        bgView.backgroundColor = UIColor(red: 252/255, green: 210/255, blue: 56/255, alpha: 0.1)
        self.selectedBackgroundView = bgView
        
        self.coloredView.layer.cornerRadius = 5.0
        self.coloredView.clipsToBounds = true
    }
    
    func setupWithVote(vote: VoteModel) {
        setupView()
        
        self.name.text = vote.name

        if (vote.greenVotes > vote.yellowVotes && vote.greenVotes > vote.redVotes) {
            self.coloredView.backgroundColor = UIColor(red: 130/255, green: 177/255, blue: 17/255, alpha: 1)
        } else if (vote.yellowVotes > vote.greenVotes && vote.yellowVotes > vote.redVotes) {
            self.coloredView.backgroundColor = UIColor(red: 252/255, green: 210/255, blue: 56/255, alpha: 1)
        } else if (vote.redVotes > vote.greenVotes && vote.redVotes > vote.yellowVotes) {
            self.coloredView.backgroundColor = UIColor(red: 219/255, green: 33/255, blue: 62/255, alpha: 1)
        } else {
            self.coloredView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        var savedColor = self.coloredView.backgroundColor
        super.setSelected(selected, animated: animated)
        self.coloredView.backgroundColor = savedColor
    }
}
