//
//  BarChartView.swift
//  Good Deed Counter
//
//  Created by Mary Paskhaver on 7/7/20.
//  Copyright © 2020 Nostaw. All rights reserved.
//

import UIKit

class BarChartView: UIView {
  
    // Where the graph will be located
    private let mainLayer: CALayer = CALayer()
    
    // Embed in scroll view in case size of graph exceeds screen bounds
    private let scrollView: UIScrollView = UIScrollView()

    // Adjust spacing and hardcoded vals
    // Vertical space between entries
    let space: CGFloat = 40.0
    
    let barHeight: CGFloat = 40.0
    let contentSpace: CGFloat = 30.0
    
    // Generate graph when data is passed in
    var dataEntries: [BarEntry] = [] {
        
        didSet {
            mainLayer.sublayers?.forEach({ $0.removeFromSuperlayer() })
    
            mainLayer.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
           
            for i in 0..<dataEntries.count {
                showEntry(index: i, entry: dataEntries[i])
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        scrollView.layer.addSublayer(mainLayer)
        addSubview(scrollView)
    }
    
    override func layoutSubviews() {
        scrollView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)

        scrollView.contentSize = CGSize(width: frame.size.width, height: (barHeight + space) * CGFloat(dataEntries.count) + contentSpace)
    }
    
    private func showEntry(index: Int, entry: BarEntry) {
        let xPos: CGFloat = 30
        let yPos: CGFloat = space + CGFloat(index) * (barHeight + space)

        let titleBar: CATextLayer = drawTitle(xPos: xPos, yPos: yPos + (barHeight / 4), width: 120, height: 40.0, title: entry.title)
        
        let progressBar = drawBar(forEntry: entry, xPos: xPos + titleBar.frame.width + contentSpace, yPos: yPos)
        
        drawTextValue(xPos: xPos + progressBar.frame.origin.x + contentSpace, yPos: yPos + (barHeight / 4), textValue: "\(entry.count)")
    }
    
    private func drawTitle(xPos: CGFloat, yPos: CGFloat, width: CGFloat, height: CGFloat = 22, title: String) -> CATextLayer {
        let textLayer = CATextLayer()
                
        textLayer.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
        
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        
        textLayer.alignmentMode = CATextLayerAlignmentMode.left
        textLayer.contentsScale = UIScreen.main.scale

        textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 22.0).fontName as CFString, 0, nil)
        textLayer.fontSize = 22
       
        textLayer.string = title
        
        mainLayer.addSublayer(textLayer)
        
        return textLayer
    }
    
    private func drawBar(forEntry entry: BarEntry, xPos: CGFloat, yPos: CGFloat) -> CALayer {
        let barLayer = CALayer()
        
        let width = translateWidthValueToXPosition(value: Float(entry.count) / Float(30.0))
        
        barLayer.frame = CGRect(x: xPos, y: yPos, width: width, height: barHeight)
        barLayer.backgroundColor = CustomColors.defaultBlue.cgColor
        
        mainLayer.addSublayer(barLayer)
        
        return barLayer
    }
    
    private func drawTextValue(xPos: CGFloat, yPos: CGFloat, textValue: String) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: xPos, y: yPos, width: 33, height: 80.0)
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.contentsScale = UIScreen.main.scale
        
        textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 22.0).fontName as CFString, 0, nil)
        textLayer.fontSize = 22.0
        
        textLayer.string = textValue
        mainLayer.addSublayer(textLayer)
    }
    
    private func translateWidthValueToXPosition(value: Float) -> CGFloat {
       let width = CGFloat(value) * (mainLayer.frame.width - space)
       return abs(width)
    }
}
