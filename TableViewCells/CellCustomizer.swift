//
//  CellCustomizer.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/28/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import Foundation
import UIKit

class CellCustomizer {
    
    static func customizeDeedCell(cell: DeedTableViewCell, withNewText text: String, view: UIView) {
        cell.contentView.viewWithTag(WhiteRoundedView.tag)?.removeFromSuperview()
        
        cell.deedDescriptionLabel.text = text
        cell.deedDescriptionLabel.sizeToFit()
        
        let whiteRoundedViewHeight = cell.deedDescriptionLabel.frame.height + 20
                
        let whiteRoundedView = WhiteRoundedView(frameToDisplay: CGRect(x: 10, y: 10, width: view.frame.width - 20, height: whiteRoundedViewHeight))
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
    }

}
