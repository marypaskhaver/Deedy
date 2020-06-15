//
//  SettingsViewController.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/14/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    // Default -- a light blue
    static var themeColor = UIColor(red: 114 / 255.0, green: 207 / 255.0, blue: 250 / 255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func redSliderChanged(_ sender: UISlider) {
        navigationController?.navigationBar.barTintColor = getUIColorFromSliders()
    }
    
    @IBAction func greenSliderChanged(_ sender: UISlider) {
        navigationController?.navigationBar.barTintColor = getUIColorFromSliders()
    }
    
    @IBAction func blueSliderChanged(_ sender: UISlider) {
        navigationController?.navigationBar.barTintColor = getUIColorFromSliders()
    }
    
    func getUIColorFromSliders() -> UIColor {
        let color = UIColor(red: CGFloat(redSlider.value / 255.0), green: CGFloat(greenSlider.value / 255.0), blue: CGFloat(blueSlider.value / 255.0), alpha: CGFloat(1.0))
        
        UINavigationBar.appearance().barTintColor = color
        
        changeTextColorIfNeeded()
        
        SettingsViewController.themeColor = color
        
        return color
    }
    
    func changeTextColorIfNeeded() {
        var sum: Int = redSlider.value >= 230 ? 1 : 0
        sum += greenSlider.value >= 230 ? 1 : 0
        sum += blueSlider.value >= 230 ? 1 : 0

        if (sum >= 2) {
            changeNavBarTextAndItemsToColor(color: UIColor.black)
        } else {
            changeNavBarTextAndItemsToColor(color: UIColor.white)
        }
    }
    
    func changeNavBarTextAndItemsToColor(color: UIColor) {
        // Change this nav bar's text color
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        
        // Change all nav bars' text color
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        
        // Change all nav bars' items' colors
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color], for: .normal)
    }
}
