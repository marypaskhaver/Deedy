//
//  BarChartDrawer.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/15/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class BarChartDrawer {
    // Declare vars.
    var view: UIView!
    var barHeight: CGFloat!
    static var currentEntry: Int = 0
    
    // Init with view to add bars to and custom bar height.
    init(withView view: UIView, withBarHeight barHeight: CGFloat) {
        self.view = view
        self.barHeight = barHeight
    }
    
    // MARK: - Drawing items in the bar entry
    // Draws title on the left of each bar. The title holds the date some deeds were done. These dates are all in the past month.
    func drawTitle(xPos: CGFloat, yPos: CGFloat, title: String) -> CATextLayer {
        // Create textLayer object to draw title (date some deeds were done) on.
        let textLayer = CATextLayer()
        
        // Set up textLayer foregroundColor, alignment, contentScale, font.
        configureTextLayer(layer: textLayer)
        
        // Set textLayer string to hold custom title (date some deeds were done).
        textLayer.string = title
        
        // Set textLayer frame.
        textLayer.frame = CGRect(x: xPos, y: yPos, width: textLayer.preferredFrameSize().width + 15, height: textLayer.preferredFrameSize().height)
        
        // Make layer fade in when it appears.
        addAnimationToLayer(layer: textLayer)
       
        return textLayer
    }
    
    // Draws bar next to each title / date whose length varies depends on how many deeds were done on that date.
    func drawBar(xPos: CGFloat, yPos: CGFloat, width: CGFloat, forEntry entry: BarEntry) -> CALayer {
        // Create CALayer to draw bars on.
        let barLayer = CALayer()
        
        // Configure frame, borderWidth, borderColor
        barLayer.frame = CGRect(x: xPos, y: yPos, width: width, height: barHeight)
        barLayer.borderWidth = 1
        barLayer.borderColor = UIColor.white.cgColor

        // Set bar color to be roughly same color as nav bar, whether a custom color was selected or not.
        if let navBarColor = defaults.color(forKey: UserDefaultsKeys.navBarColor) {
            changeLayerToColorFromComponents(from: navBarColor, toLayer: barLayer)
        } else {
            changeLayerToColorFromComponents(from: CustomColors.defaultBlue, toLayer: barLayer)
        }
        
        // Make layer fade in when it appears.
        addAnimationToLayer(layer: barLayer)
            
        return barLayer
    }
    
    // Draws number of deeds that were done on a date to the right of the bar and title representing that date.
    func drawTextValue(xPos: CGFloat, yPos: CGFloat, textValue: String) -> CATextLayer {
        // Create textLayer object to draw the number of deeds that were done on some date on.
        let textLayer = CATextLayer()
        
        // Set up textLayer foregroundColor, alignment, contentScale, font.
        configureTextLayer(layer: textLayer)
        
        // Set textLayer string to hold custom value (number of deeds done on some date).
        textLayer.string = textValue
        
        // Set textLayer frame.
        textLayer.frame = CGRect(x: xPos, y: yPos, width: textLayer.preferredFrameSize().width + 15, height: textLayer.preferredFrameSize().height)
        
        // Make layer fade in when it appears.
        addAnimationToLayer(layer: textLayer)
                
        return textLayer
    }
    
    // MARK: - Configuring text and alignment methods
    func configureTextLayer(layer: CATextLayer) {
        layer.foregroundColor = UIColor.black.cgColor
        
        // Center text in layer, set scale to same as screen's scale.
        setTextLayerAlignmentAndContentScale(forLayer: layer)
        
        // Set font to Times New Roman, size 22.0.
        setTextLayerFont(forLayer: layer)
    }
    
    // Center text in param layer, set scale to same as screen's scale.
    func setTextLayerAlignmentAndContentScale(forLayer layer: CATextLayer) {
        layer.alignmentMode = CATextLayerAlignmentMode.center
        layer.contentsScale = UIScreen.main.scale
    }
    
    // Set font of param layer to Times New Roman, size 22.0.
    func setTextLayerFont(forLayer layer: CATextLayer) {
        layer.font = CTFontCreateWithName("TimesNewRomanPSMT" as CFString, 22.0, nil)
        layer.fontSize = 22
    }
    
    // MARK: - Changing bar background color
    // Sets layer's background color to param color passed in, with some other calculations.
    func changeLayerToColorFromComponents(from color: UIColor, toLayer layer: CALayer) {
        // Get hue-- HSBA values-- from param color
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        // Set layer's backgroundColor to hues made from color but with a slightly lower brightness.
        layer.backgroundColor = UIColor(hue: h, saturation: s, brightness: b * 0.8, alpha: a).cgColor
    }
    
    // MARK: - Animating CALayers
    // Fade in layer.
    func addAnimationToLayer(layer: CALayer) {
        // Start later at opacity of 0 (transparent).
        layer.opacity = 0.0
        
        // Calls func in Animations class that gradually increases layer's opacity, creating fadeIn effect.
        layer.add(Animations.getFadeInAnimationForCALayer(atIndex: BarChartDrawer.currentEntry), forKey: "fadeIn")
    }

}
