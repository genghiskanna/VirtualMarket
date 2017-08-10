//
//  ChartView.swift
//  ChartTest
//
//  Created by Nishaanth Kanna Ravichandran on 05/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit

protocol ChartViewDelegate{
    func chartMoved(currentPrice price:Float, currentDate date: Date)
    func chartStopped()
}

@IBDesignable class ChartView: UIView {
    
    // output 
    var price = Float()
    var date = Date()
    
    var delegate: ChartViewDelegate? = nil
    
    // Dataset
    var x = Array<Date>()
    var y = Array<Float>()
    
    // Scale
    var xSkip = Int()
    var xRaw = Array<Int>()
    var yRaw = Array<Int>()
    
    // Guideline
    let lineLayer = CAShapeLayer()
    let lineLayerS = CAShapeLayer()
    
    
    public var divisions = 26
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.addSublayer(self.lineLayer)
        self.layer.addSublayer(self.lineLayerS)
//        self.layer.addSublayer(self.graphLineLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addSublayer(self.lineLayer)
        self.layer.addSublayer(self.lineLayerS)
//        self.layer.addSublayer(self.graphLineLayer)
        
    }
    
    
    public func drawGraph(divisons totalDivisions: Int, layerToDraw graphLayer: CAShapeLayer){
        self.isMultipleTouchEnabled = true
        
        yRaw.removeAll()
        xRaw.removeAll()
        
        if self.x.count > Int(frame.width){
            var skipElement = Int((CGFloat(self.x.count) / frame.width).rounded(.awayFromZero))
            
            var skip = 0
            while self.x.count >  Int(frame.width) {
                self.x.remove(at: skip)
                self.y.remove(at: skip)
                skip += skipElement
            }
        }
        xSkip = Int(frame.width) / Int(self.x.count)
        
        var i = 0
        print(Int(self.x.count))
        for _ in x{
            xRaw.append(i * xSkip)
            i += 1
        }
        i = 0
        
        if let min = y.min(), let max = y.max() {
            for price in y{
                let value = ((price - min)/(max - min)) * Float(frame.height - 50.00)
                
                // Do not Delete this line (Shifts the Value at the Right Side)
                yRaw.append(Int(self.frame.height - CGFloat(value)))
            }
        }
        
        let line = UIBezierPath()
        line.removeAllPoints()
        line.move(to: CGPoint(x: 0, y: yRaw[0]))
        for i in 1..<yRaw.count {
            line.addLine(to: CGPoint(x: xRaw[i], y: yRaw[i]))
        }
        line.lineWidth = 1
        
        graphLayer.path = line.cgPath
        graphLayer.strokeColor = UIColor.red.cgColor
        graphLayer.fillColor = UIColor.clear.cgColor
        graphLayer.borderColor  = UIColor.clear.cgColor
        graphLayer.borderWidth = 0.0
        self.layer.addSublayer(graphLayer)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var touch = touches
        let touchF = touch.popFirst()
        
        if touches.count == 2{
            let touchS = touch.first
            if let loc = touchF?.location(in: self), let locS = touchS?.location(in: self) {
                
                if self.xRaw.index(of: Int(loc.x)) != nil && self.yRaw.index(of: Int(locS.x)) != nil {
                    
                    let line = UIBezierPath(rect: CGRect(x: loc.x, y:0, width: 1, height: self.frame.height))
                    self.lineLayer.path = line.cgPath
                    self.lineLayer.strokeColor = UIColor.black.cgColor
                    
                    if locS.x < loc.x{
                        let lineS = UIBezierPath(rect: CGRect(x: Int(locS.x), y: Int(0),
                                                          width: abs(Int(loc.x - locS.x)),
                                                          height: Int(self.frame.height)))
                        self.lineLayerS.path = lineS.cgPath
                        
                        if let inX = self.xRaw.index(of: Int(loc.x)), let inS = self.yRaw.index(of: Int(locS.x)){
                            print("In3")
                            self.date = self.x[inX]
                            var average :Float = 0

                            for i in inS..<inX{
                                average += self.y[i]
                            }
                            average = average / Float(inX - inS)
                            self.price = average
                        }
                        
                        
                    } else {
                        let lineS = UIBezierPath(rect: CGRect(x: Int(loc.x), y: Int(0),
                                                              width: abs(Int(locS.x - loc.x)),
                                                              height: Int(self.frame.height)))
                        self.lineLayerS.path = lineS.cgPath
                        
                        // Display the average reverse
                        if let inX = self.xRaw.index(of: Int(loc.x)), let inS = self.yRaw.index(of: Int(locS.x)){
                            self.date = self.x[inX]
                            var average :Float = 0
                            print(inS)
                            print(inX)
                            // Error
                            for i in inS..<inX{
                                average += self.y[i]
                            }
                            average = average / Float(inS - inX)
                            self.price = average
                        }
                    }
                    self.lineLayerS.strokeColor = UIColor.black.cgColor
                    self.lineLayerS.borderWidth = 0
                    self.lineLayerS.fillColor = UIColor.black.withAlphaComponent(0.25).cgColor
                }
            }
        } else {
                if let loc = touchF?.location(in: self) {
                    if self.xRaw.index(of: Int(loc.x)) != nil {
                        
                        //add first line
                        let line = UIBezierPath(rect: CGRect(x: loc.x, y:0, width: 1, height: self.frame.height))
                        self.lineLayer.path = line.cgPath
                        self.lineLayer.strokeColor = UIColor.black.cgColor
                        
                        // remove the second line if user didnt use 2 fingers
                        let lineS = UIBezierPath()
                        self.lineLayerS.path = lineS.cgPath

                        // Display the current value only
                        if let inX = self.xRaw.index(of: Int(loc.x)){
                            self.date = self.x[inX]
                            self.price = self.y[inX]
                            if delegate != nil{
                                delegate!.chartMoved(currentPrice: self.price, currentDate: self.date)
                            }
                        }
                    }
                }
        }
            
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if delegate != nil{
            delegate!.chartStopped()
        }
    }
    
            
}

    




