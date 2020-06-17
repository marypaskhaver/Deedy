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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
