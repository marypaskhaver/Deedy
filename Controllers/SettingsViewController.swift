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
    
    let navBarColorUserDefaultsKey = "navBarColor"
    let navBarTextColorUserDefaultsKey = "navBarTextColor"

    @IBOutlet weak var scrollView: TutorialScrollView!
    @IBOutlet weak var tutorialXButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadColorTheme()
        hideTutorialItems(bool: true)
    }
    
    func hideTutorialItems(bool: Bool) {
       scrollView.isHidden = bool
       tutorialXButton.isHidden = bool
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if defaults.object(forKey: "SettingsViewControllerTutorialShown") == nil {
            showTutorial()
        }
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
        
        let pages = scrollView.createPages(forViewController: self)
        scrollView.setupSlideScrollView(withPages: pages)
        view.bringSubviewToFront(scrollView)

        tutorialXButton.frame = CGRect(x: scrollView.frame.width - 20, y: scrollView.frame.origin.y + 10, width: 30, height: 30)
        view.bringSubviewToFront(tutorialXButton)
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
    
    @IBAction func reviewTutorialButtonPressed(_ sender: UIButton) {
        defaults.removeObject(forKey: "DisplayDeedsViewControllerTutorialShown")
        defaults.removeObject(forKey: "ChallengesViewControllerTutorialShown")
        defaults.removeObject(forKey: "SettingsViewControllerTutorialShown")
        showTutorial()
    }
    
    @IBAction func tutorialXButtonPressed(_ sender: UIButton) {
        enableSlidersAndButtons(bool: true)
        hideTutorialItems(bool: true)
        defaults.set(true, forKey: "SettingsViewControllerTutorialShown")
    }
    
    func getUIColorFromSliders() -> UIColor {
        let color = UIColor(red: CGFloat(redSlider.value / 255.0), green: CGFloat(greenSlider.value / 255.0), blue: CGFloat(blueSlider.value / 255.0), alpha: CGFloat(1.0))
    
        changeAppColorTheme(toColor: color)
        
        return color
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        CustomColors.defaultBlue.getRed(&r, green: &g, blue: &b, alpha: &a)

        redSlider.value = Float(r * 255)
        greenSlider.value = Float(g * 255)
        blueSlider.value = Float(b * 255)
        
        changeAppColorTheme(toColor: getUIColorFromSliders())
    }
    
    func changeAppColorTheme(toColor color: UIColor) {
        changeNavBarColorToColor(color: color)
        changeTextColorIfNeeded()
        resetButton.setBorderColor()
        reviewTutorialButton.setBorderColor()
        saveColorTheme()
    }
    
    // MARK: - Change app color theme
    func changeNavBarColorToColor(color: UIColor) {
        navigationController?.navigationBar.barTintColor = color
        UINavigationBar.appearance().barTintColor = color
        SettingsViewController.navBarColor = color
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
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)]
        
        // Change all nav bars' text color
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)]
        
        // Change all nav bars' items' colors
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)], for: .normal)

        SettingsViewController.navBarTextColor = color
    }
    
    // MARK: - Model Manipulation Methods
    func saveColorTheme() {
        defaults.set(redSlider.value, forKey: "redSliderValue")
        defaults.set(greenSlider.value, forKey: "greenSliderValue")
        defaults.set(blueSlider.value, forKey: "blueSliderValue")
        
        defaults.set(SettingsViewController.navBarColor, forKey: "navBarColor")
        defaults.set(SettingsViewController.navBarTextColor, forKey: "navBarTextColor")
    }
    
    func loadColorTheme() {
        if let rsv = defaults.object(forKey: "redSliderValue") {
            redSlider.value = rsv as! Float
        }
        
        if let gsv = defaults.object(forKey: "greenSliderValue") {
            greenSlider.value = gsv as! Float
        }
        
        if let bsv = defaults.object(forKey: "blueSliderValue") {
            blueSlider.value = bsv as! Float
        }
                
        navigationController?.navigationBar.barTintColor = getUIColorFromSliders()
    }
}

// MARK: - UserDefaults methods
extension UserDefaults {
    func color(forKey key: String) -> UIColor? {
        guard let colorData = data(forKey: key) else { return nil }

        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        } catch let error {
            print("Color error \(error)")
            return nil
        }

    }

    func set(_ value: UIColor?, forKey key: String) {
        guard let color = value else { return }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            set(data, forKey: key)
        } catch let error {
            print("Error color key data not saved \(error)")
        }
    }

}
