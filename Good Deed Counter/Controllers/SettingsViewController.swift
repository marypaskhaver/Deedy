//
//  SettingsViewController.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 6/14/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

let defaults = UserDefaults.standard

class SettingsViewController: UIViewController {
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var resetButton: ColoredBorderButton!
    @IBOutlet weak var reviewTutorialButton: ColoredBorderButton!
    
    // Default -- a light blue
    static var navBarColor = CustomColors.defaultBlue
    static var navBarTextColor = UIColor.white
    
    @IBOutlet weak var scrollView: TutorialScrollView!
    @IBOutlet weak var tutorialXButton: TutorialXButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadColorTheme()
        hideTutorialItems(bool: true)
    }
    
    func hideTutorialItems(bool: Bool) {
       scrollView.isHidden = bool
       tutorialXButton.isHidden = bool
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if defaults.object(forKey: UserDefaultsKeys.settingsViewControllerTutorialShown) == nil {
            showTutorial()
        }
        
        BarStyleSetter.setBarStyle(forViewController: self)
    }
    
    func enableSlidersAndButtons(bool: Bool) {
        redSlider.isEnabled = bool
        greenSlider.isEnabled = bool
        blueSlider.isEnabled = bool
        resetButton.isEnabled = bool
        reviewTutorialButton.isEnabled = bool
    }
    
    func showTutorial() {
        enableSlidersAndButtons(bool: false)
        hideTutorialItems(bool: false)
        TutorialSetterUpper.setUp(withViewController: self)
    }

    @IBAction func redSliderChanged(_ sender: UISlider) {
        changeAppColorTheme(toColor: getUIColorFromSliders())
    }
    
    @IBAction func greenSliderChanged(_ sender: UISlider) {
        changeAppColorTheme(toColor: getUIColorFromSliders())
    }
    
    @IBAction func blueSliderChanged(_ sender: UISlider) {
        changeAppColorTheme(toColor: getUIColorFromSliders())
    }
    
    @IBAction func reviewTutorialButtonPressed(_ sender: UIButton) {
        defaults.removeObject(forKey: UserDefaultsKeys.displayDeedsViewControllerTutorialShown)
        defaults.removeObject(forKey: UserDefaultsKeys.challengesViewControllerTutorialShown)
        defaults.removeObject(forKey: UserDefaultsKeys.settingsViewControllerTutorialShown)
        showTutorial()
    }
    
    @IBAction func tutorialXButtonPressed(_ sender: UIButton) {
        enableSlidersAndButtons(bool: true)
        hideTutorialItems(bool: true)
        defaults.set(true, forKey: UserDefaultsKeys.settingsViewControllerTutorialShown)
    }
    
    func getUIColorFromSliders() -> UIColor {
        let color = UIColor(red: CGFloat(redSlider.value / 255.0), green: CGFloat(greenSlider.value / 255.0), blue: CGFloat(blueSlider.value / 255.0), alpha: CGFloat(1.0))
            
        return color
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        CustomColors.defaultBlue.getRed(&r, green: &g, blue: &b, alpha: &a)

        redSlider.setValue(Float(r * 255), animated: true)
        blueSlider.setValue(Float(b * 255), animated: true)
        greenSlider.setValue(Float(g * 255), animated: true)

        changeAppColorTheme(toColor: CustomColors.defaultBlue)
    }
    
    func changeAppColorTheme(toColor color: UIColor) {
        changeNavBarColorToColor(color: color)
        changeTextColorIfNeeded()
        
        self.navigationController?.navigationBar.backgroundColor = color

        resetButton.setBorderColor(to: color.cgColor)
        reviewTutorialButton.setBorderColor(to: color.cgColor)
        
        saveColorTheme()
    }
    
    // MARK: - Change app color theme
    func changeNavBarColorToColor(color: UIColor) {
        SettingsViewController.navBarColor = color
        UINavigationBar.appearance().barTintColor = color
    }
    
    func changeTextColorIfNeeded() {
        var sum: Int = redSlider.value >= 225 ? 1 : 0
        sum += greenSlider.value >= 225 ? 1 : 0
        sum += blueSlider.value >= 225 ? 1 : 0

        sum >= 2 ? changeNavBarTextAndItemsToColor(color: UIColor.black) : changeNavBarTextAndItemsToColor(color: UIColor.white)
        
        BarStyleSetter.setBarStyle(forViewController: self)
    }
        
    func changeNavBarTextAndItemsToColor(color: UIColor) {
        // Change this nav bar's text color
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)]
        
        // Change all nav bars' text color
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)]
        
        // Change all nav bars' items' colors
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)], for: .normal)

        SettingsViewController.navBarTextColor = color
    }
    
    // MARK: - Model Manipulation Methods
    func saveColorTheme() {
        defaults.set(SettingsViewController.navBarColor, forKey: UserDefaultsKeys.navBarColor)
        defaults.set(SettingsViewController.navBarTextColor, forKey: UserDefaultsKeys.navBarTextColor)
    }
    
    func loadColorTheme() {
        var color: UIColor = CustomColors.defaultBlue
        
        if let navBarColor = defaults.color(forKey: UserDefaultsKeys.navBarColor) {
            color = navBarColor
        }
        
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        redSlider.setValue(Float(r * 255), animated: true)
        blueSlider.setValue(Float(b * 255), animated: true)
        greenSlider.setValue(Float(g * 255), animated: true)
        
        changeAppColorTheme(toColor: getUIColorFromSliders())
    }
}
