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
    
    var entryTooBig: Bool = false
    
    // Generate graph when data is passed in
    var dataEntries: [BarEntry] = [] {
        didSet {
            mainLayer.sublayers?.forEach({ $0.removeFromSuperlayer() })
                  
            mainLayer.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)

            var factor: Float = 3.0
            var index: Int = 0
            
            while index < dataEntries.count {
                BarChartDrawer.currentEntry = index
                showEntry(index: index, entry: dataEntries[index], shrinkBarWidthByFactorOf: factor)
                
                while entryTooBig {
                    // Remove all entries from screen
                    mainLayer.sublayers?.forEach({ $0.removeFromSuperlayer() })

                    index = 0

                    factor += 0.2
                    showEntry(index: index, entry: dataEntries[index], shrinkBarWidthByFactorOf: factor)
                }
                
                index += 1
            }
            
            mainLayer.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
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
    
    private func showEntry(index: Int, entry: BarEntry, shrinkBarWidthByFactorOf factor: Float) {
        let xPos: CGFloat = 30
        let yPos: CGFloat = space + CGFloat(index) * (barHeight + space)

        let titleBar = drawTitle(xPos: xPos, yPos: yPos + (barHeight / 4), title: entry.title)
        
        let progressBar = drawBar(xPos: xPos + titleBar.frame.width + contentSpace, yPos: yPos, width: calculateBarWidth(value: Float(entry.count), shrinkByFactorOf: factor), forEntry: entry)
        
        let text = drawTextValue(xPos: xPos + titleBar.frame.width + progressBar.frame.width + contentSpace, yPos: yPos + (barHeight / 4), textValue: "\(entry.count)")
        
        let entryWidth = xPos + (titleBar.frame.width + contentSpace) + (progressBar.frame.width + contentSpace) + (xPos + text.frame.width)
        
        entryTooBig = entryWidth > UIScreen.main.bounds.width ? true : false
    }
    
    // MARK: - Drawing CALayers
    private func drawTitle(xPos: CGFloat, yPos: CGFloat, title: String) -> CATextLayer {
        let textLayer = BarChartDrawer(withView: self, withBarHeight: barHeight).drawTitle(xPos: xPos, yPos: yPos, title: title)

        mainLayer.addSublayer(textLayer)

        return textLayer
    }
    
    private func drawBar(xPos: CGFloat, yPos: CGFloat, width: CGFloat, forEntry entry: BarEntry) -> CALayer {
        let barLayer = BarChartDrawer(withView: self, withBarHeight: barHeight).drawBar(xPos: xPos, yPos: yPos, width: width, forEntry: entry)
                
        mainLayer.addSublayer(barLayer)
    
        return barLayer
    }

    private func drawTextValue(xPos: CGFloat, yPos: CGFloat, textValue: String) -> CATextLayer {
        let textLayer = BarChartDrawer(withView: self, withBarHeight: barHeight).drawTextValue(xPos: xPos, yPos: yPos, textValue: textValue)
        
        mainLayer.addSublayer(textLayer)
        
        return textLayer
    }
    
    private func calculateBarWidth(value: Float, shrinkByFactorOf factor: Float) -> CGFloat {
        let width = CGFloat(value / factor) * (mainLayer.frame.width - space)
        
        return abs(width)
    }
   
}
