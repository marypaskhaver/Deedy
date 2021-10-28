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
        
        // Configure color when created.
        changeBackgroundColor()
    }
    
    // If in Dark Mode, set backgroundColor to black. Otherwise, set it to white.
    func changeBackgroundColor() {
        self.backgroundColor = (self.traitCollection.userInterfaceStyle == .dark) ? UIColor.black : UIColor.white
    }
    
    func setFrameInViewController(vc: UIViewController) {
        let statusBarHeight = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height
        
        // If the nav bar and status bar are there, set frame to be right under nav bar and status bar
        if (vc.navigationController?.navigationBar.frame.height) != nil {
            self.frame = CGRect(x: 0, y: (vc.navigationController?.navigationBar.frame.height)! + (statusBarHeight ?? 0), width: vc.view.frame.width, height: self.frame.height)
        }
    }
    
    func setHeightInViewController(vc: UIViewController, toHeight height: CGFloat) {
        let statusBarHeight = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height
        
        // If the nav bar and status bar are there, set height to be right under nav bar and status bar
        if (vc.navigationController?.navigationBar.frame.height) != nil {
            self.frame = CGRect(x: 0, y: (vc.navigationController?.navigationBar.frame.height)! + (statusBarHeight ?? 0), width: vc.view.frame.width, height: height)            
        }
    }
    
}
