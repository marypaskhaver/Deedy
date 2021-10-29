//
//  ChallengeTableViewCell.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/17/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class ChallengeTableViewCell: UITableViewCell {
    // Declare vars. Has challengeDescriptionLabel at center left and subtitleLabel at center right.
    @IBOutlet weak var challengeDescriptionLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set background color.
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // If this cell represents an achievement that has been completed, set its subtitle text color to green.
    func setSubtitleTextIfAchievementCompleted(to text: String) {
        self.subtitleLabel.text = text
        self.subtitleLabel.textColor = CustomColors.successGreen
    }

}
