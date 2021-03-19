//
//  TopView.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/25/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class TopView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        changeBackgroundColor()
    }
    
    func changeBackgroundColor() {
        self.backgroundColor = (self.traitCollection.userInterfaceStyle == .dark) ? UIColor.black : UIColor.white
    }
    
    func setFrameInViewController(vc: UIViewController) {
        let statusBarHeight = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height
        
        if (vc.navigationController?.navigationBar.frame.height) != nil {
            self.frame = CGRect(x: 0, y: (vc.navigationController?.navigationBar.frame.height)! + (statusBarHeight ?? 0), width: vc.view.frame.width, height: self.frame.height)
        }
    }
    
    func setHeightInViewController(vc: UIViewController, toHeight height: CGFloat) {
        let statusBarHeight = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height
        
        if (vc.navigationController?.navigationBar.frame.height) != nil {
            self.frame = CGRect(x: 0, y: (vc.navigationController?.navigationBar.frame.height)! + (statusBarHeight ?? 0), width: vc.view.frame.width, height: height)            
        }
    }
    
}
