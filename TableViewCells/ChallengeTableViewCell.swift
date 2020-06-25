//
//  ChallengeTableViewCell.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/17/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class ChallengeTableViewCell: UITableViewCell {

    @IBOutlet weak var challengeDescriptionLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSubtitleTextIfAchievementCompleted(to text: String) {
        self.subtitleLabel.text = text
        self.subtitleLabel.textColor = UIColor(red: 26 / 255.0, green: 145 / 255.0, blue: 0 / 255.0, alpha: 1.0)
        
    }

}
