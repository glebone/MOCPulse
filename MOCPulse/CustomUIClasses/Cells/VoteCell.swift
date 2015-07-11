//
//  VoteCell.swift
//  MOCPulse
//
//  Created by Paul Kovalenko on 10.07.15.
//  Copyright (c) 2015 MOC. All rights reserved.
//

import UIKit

class VoteCell: UITableViewCell {
    
    @IBOutlet var userNaleLabel : UILabel!
    @IBOutlet var dateLabel : UILabel!
    @IBOutlet var voteBodyLabel : UILabel!

    override func prepareForReuse() {
        userNaleLabel.text = ""
        dateLabel.text = ""
        voteBodyLabel.text = ""
    }
    
    func setupWithVote(vote : VoteModel) {
        voteBodyLabel.text = vote.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
