//
//  TableViewCell.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 3/26/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class DeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deedDescriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
