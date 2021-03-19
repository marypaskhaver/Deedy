//
//  BarChartDrawer.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/15/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class BarChartDrawer {
    var view: UIView!
    var barHeight: CGFloat!
    static var currentEntry: Int = 0
    
    init(withView view: UIView, withBarHeight barHeight: CGFloat) {
        self.view = view
        self.barHeight = barHeight
    }
    
    // MARK: - Drawing items in the bar entry
    func drawTitle(xPos: CGFloat, yPos: CGFloat, title: String) -> CATextLayer {
        let textLayer = CATextLayer()
        
        configureTextLayer(layer: textLayer)
        
        textLayer.string = title
        textLayer.frame = CGRect(x: xPos, y: yPos, width: textLayer.preferredFrameSize().width + 15, height: textLayer.preferredFrameSize().height)
        
        addAnimationToLayer(layer: textLayer)
       
        return textLayer
    }
    
    func drawBar(xPos: CGFloat, yPos: CGFloat, width: CGFloat, forEntry entry: BarEntry) -> CALayer {
        let barLayer = CALayer()
                
        barLayer.frame = CGRect(x: xPos, y: yPos, width: width, height: barHeight)
        barLayer.borderWidth = 1
        barLayer.borderColor = UIColor.white.cgColor

        if let navBarColor = defaults.color(forKey: UserDefaultsKeys.navBarColor) {
            changeLayerToColorFromComponents(from: navBarColor, toLayer: barLayer)
        } else {
            changeLayerToColorFromComponents(from: CustomColors.defaultBlue, toLayer: barLayer)
        }
        
        addAnimationToLayer(layer: barLayer)
            
        return barLayer
    }
    
    func drawTextValue(xPos: CGFloat, yPos: CGFloat, textValue: String) -> CATextLayer {
        let textLayer = CATextLayer()
        
        configureTextLayer(layer: textLayer)
        
        textLayer.string = textValue
        textLayer.frame = CGRect(x: xPos, y: yPos, width: textLayer.preferredFrameSize().width + 15, height: textLayer.preferredFrameSize().height)
        
        addAnimationToLayer(layer: textLayer)
                
        return textLayer
    }
    
    // MARK: - Configuring text and alignment methods
    func configureTextLayer(layer: CATextLayer) {
        layer.foregroundColor = UIColor.black.cgColor
        setTextLayerAlignmentAndContentScale(forLayer: layer)
        setTextLayerFont(forLayer: layer)
    }
    
    func setTextLayerAlignmentAndContentScale(forLayer layer: CATextLayer) {
        layer.alignmentMode = CATextLayerAlignmentMode.center
        layer.contentsScale = UIScreen.main.scale
    }
    
    func setTextLayerFont(forLayer layer: CATextLayer) {
        layer.font = CTFontCreateWithName("TimesNewRomanPSMT" as CFString, 22.0, nil)
        layer.fontSize = 22
    }
    
    // MARK: - Changing bar background color
    func changeLayerToColorFromComponents(from color: UIColor, toLayer layer: CALayer) {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        layer.backgroundColor = UIColor(hue: h, saturation: s, brightness: b * 0.8, alpha: a).cgColor
    }
    
    // MARK: - Animating CALayers
    func addAnimationToLayer(layer: CALayer) {
        layer.opacity = 0.0
        layer.add(Animations.getFadeInAnimationForCALayer(atIndex: BarChartDrawer.currentEntry), forKey: "fadeIn")
    }

}
