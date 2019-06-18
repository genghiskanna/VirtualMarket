//
//  ChartView.swift
//  ChartTest
//
//  Created by Nishaanth Kanna Ravichandran on 05/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit

protocol ChartViewDelegate{
    func chartMoved(currentPrice price:Float, currentDate date: String)
    func chartStopped()
}

@IBDesignable class ChartView: UIView {
    
    // output 
    @objc var price = Float()
    @objc var date = String()
    
    var delegate: ChartViewDelegate? = nil
    
    // Dataset
    @objc var x = Array<String>()
    @objc var y = Array<Float>()
    
    // Scale
    @objc var xSkip = Int()
    @objc var xRaw = Array<Int>()
    @objc var yRaw = Array<Int>()
    
    // Guideline
    @objc let lineLayer = CAShapeLayer()
    @objc let lineLayerS = CAShapeLayer()
    @objc let lastCloseLayer = CAShapeLayer()
    @objc let circleLayer = CAShapeLayer()
    @objc let circleLayerS = CAShapeLayer()
    @objc let underBackgroundLayer = CAShapeLayer()
    
    
    @objc public var divisions = 26
    @objc public var lastClosePrice = 165.0
    
    
    //Touch Pointers
    @objc private var firstTouch = UITouch()
    @objc private var secondTouch = UITouch()
    
    private var isFirstNotTouchSet = true
    private var isSecondNotTouchSet = true
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.addSublayer(self.lineLayer)
        self.layer.addSublayer(self.lineLayerS)
        self.layer.addSublayer(self.underBackgroundLayer)
//        self.layer.addSublayer(self.graphLineLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addSublayer(self.lineLayer)
        self.layer.addSublayer(self.lineLayerS)
        self.layer.addSublayer(self.underBackgroundLayer)
//        self.layer.addSublayer(self.graphLineLayer)
        
    }
    
    
    public func drawGraph(range Range: StockDetails.StockRange, layerToDraw graphLayer: CAShapeLayer){
        self.isMultipleTouchEnabled = true
        
        yRaw.removeAll()
        xRaw.removeAll()
    
        // Normalizing x
        for i in 1...self.x.count{
            var maxIn = Float(self.x.count)
            if Range == .oneDay{
                maxIn = 78.0
                self.y.append(Float(lastClosePrice))
                lastClosePrice = Double(frame.height)-Double(map(value: Float(lastClosePrice), minimumInput: self.y.min()!, maximumInput:self.y.max()!, minimumOutput: 10.0, maximumOutput: Float(frame.height)-10))
                self.y.removeLast()
            }
            xRaw.append(map(value: Float(i), minimumInput: 1.0, maximumInput: maxIn, minimumOutput: 1, maximumOutput: Float(frame.width)))
        }
        // Normalizing y
        for i in self.y{
            yRaw.append(Int(frame.height)-map(value: i, minimumInput: self.y.min()!, maximumInput:self.y.max()!, minimumOutput: 10.0, maximumOutput: Float(frame.height)-10))
        }
        let line = UIBezierPath()
        let lastCloseLine = UIBezierPath()
        line.removeAllPoints()
        lastCloseLine.removeAllPoints()
        
        //dotted line for lastclose price
        lastCloseLine.move(to: CGPoint(x:0,y:lastClosePrice))
        lastCloseLine.addLine(to: CGPoint(x: Double(frame.width), y: lastClosePrice))
       
        
        line.move(to: CGPoint(x: 0, y: yRaw[0]))
        for i in 1..<yRaw.count {
            line.addLine(to: CGPoint(x: xRaw[i], y: yRaw[i]))
        }
        line.lineWidth = 1
        
        graphLayer.path = line.cgPath
        graphLayer.strokeColor = Colors.teal.cgColor
        graphLayer.fillColor = UIColor.clear.cgColor
        graphLayer.borderColor  = UIColor.clear.cgColor
        graphLayer.borderWidth = 0.0
        self.layer.addSublayer(graphLayer)
        
        
        self.lastCloseLayer.path = lastCloseLine.cgPath
        self.lastCloseLayer.strokeColor = Colors.blueDark.cgColor
        self.lastCloseLayer.fillColor = Colors.clear.cgColor
        self.lastCloseLayer.opacity = 0.5
        self.lastCloseLayer.borderColor = UIColor.clear.cgColor
        self.lastCloseLayer.borderWidth = 0.0
        self.lastCloseLayer.lineWidth = 1.0
        self.lastCloseLayer.lineDashPattern = [5,4]
        if Range == .oneDay{
            self.layer.addSublayer(self.lastCloseLayer)
        } else{
            self.lastCloseLayer.removeFromSuperlayer()
        }
    
        
    }
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.lineLayer.path = UIBezierPath().cgPath
        self.lineLayerS.path = UIBezierPath().cgPath
        self.circleLayer.path = UIBezierPath().cgPath
        self.circleLayerS.path = UIBezierPath().cgPath
        self.underBackgroundLayer.path = UIBezierPath().cgPath
        var touch = touches
        if touches.count == 1{
            
            handleTouch(firstTouch: touch.popFirst()!, secondTouch: nil)
        } else if touches.count == 2{
            var tempF = touch.popFirst()
            var tempS = touch.popFirst()
            
            let tempFX = Int((tempF?.location(in: self).x)!)
            let tempSX = Int((tempS?.location(in: self).x)!)
            print(String(tempFX)+" "+String(tempSX))
            if tempFX > tempSX{
                swap(&tempF, &tempS)
            }
            
            if !((tempFX-Int((tempF?.majorRadius)!)...tempFX+Int((tempF?.majorRadius)!)~=tempSX)&&(tempSX-Int((tempS?.majorRadius)!)...tempSX+Int((tempS?.majorRadius)!)~=tempFX)){
                handleTouch(firstTouch: tempF!, secondTouch: tempS!)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch = touches
        if touches.count == 1{
            
            handleTouch(firstTouch: touch.popFirst()!, secondTouch: nil)
        } else if touches.count == 2{
            var tempF = touch.popFirst()
            var tempS = touch.popFirst()
            
            let tempFX = Int((tempF?.location(in: self).x)!)
            let tempSX = Int((tempS?.location(in: self).x)!)
            print(String(tempFX)+" "+String(tempSX))
            if tempFX > tempSX{
                swap(&tempF, &tempS)
            }
            // first x is always less than secondx
            if !((tempFX-Int((tempF?.majorRadius)!)...tempFX+Int((tempF?.majorRadius)!)~=tempSX)&&(tempSX-Int((tempS?.majorRadius)!)...tempSX+Int((tempS?.majorRadius)!)~=tempFX)){
                handleTouch(firstTouch: tempF!, secondTouch: tempS!)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if delegate != nil{
            delegate!.chartStopped()
        }
        self.lineLayer.path = UIBezierPath().cgPath
        self.lineLayerS.path = UIBezierPath().cgPath
        self.circleLayer.path = UIBezierPath().cgPath
        self.circleLayerS.path = UIBezierPath().cgPath
        self.underBackgroundLayer.path = UIBezierPath().cgPath
        self.price = 0.0
        self.date = ""
        
    }
    
    private func handleTouch(firstTouch fT:UITouch, secondTouch sT:UITouch?){
        
        let loc1 = fT.location(in: self)
        let xRawValue1 = getClosest(searchValue: Int(loc1.x), arrayValue: self.xRaw)
        let yRawValue1 = self.yRaw[self.xRaw.index(of: xRawValue1)!]
        self.date = self.x[self.xRaw.index(of: xRawValue1)!]
        self.price = self.y[self.xRaw.index(of: xRawValue1)!]
        drawLines(xRawValue: xRawValue1, yRawValue: yRawValue1,lineLayer: lineLayer,circleLayer: circleLayer)
        //self.lineLayerS.path = UIBezierPath().cgPath
        //self.circleLayerS.path = UIBezierPath().cgPath
        if delegate != nil{
            delegate!.chartMoved(currentPrice: self.price, currentDate: self.date)
        }
        
        if let locT = sT{
            let loc2 = locT.location(in: self)
            let xIndex1 = self.xRaw.index(of: xRawValue1)!
            let xRawValue2 = getClosest(searchValue: Int(loc2.x), arrayValue: self.xRaw)
            let xIndex2 = self.xRaw.index(of: xRawValue2)!
            let yRawValue2 = self.yRaw[xIndex2]
            
            self.date = self.x[xIndex1]+"-"+self.x[xIndex2]
            self.price = self.y[xIndex2]-self.y[xIndex1]
            if self.price > 0.0{
                underBackgroundLayer.strokeColor = Colors.blueDarkOpa.cgColor
                underBackgroundLayer.fillColor = Colors.blueDarkOpa.cgColor
            } else {
                underBackgroundLayer.strokeColor = Colors.materialRedOpa.cgColor
                underBackgroundLayer.fillColor = Colors.materialRedOpa.cgColor
            }
            if delegate != nil{
                delegate!.chartMoved(currentPrice: self.price, currentDate: self.date)
            }
            drawLines(xRawValue: xRawValue2, yRawValue: yRawValue2,lineLayer: lineLayerS,circleLayer: circleLayerS)
            
            // drawing background layer
            let lineT = UIBezierPath()
            lineT.move(to: CGPoint(x: xRaw[xIndex1], y: Int(self.frame.height)))
            for i in xIndex1...xIndex2{
                 lineT.addLine(to: CGPoint(x: xRaw[i], y: yRaw[i]))
            }
            lineT.addLine(to: CGPoint(x: xRaw[xIndex2], y: Int(self.frame.height)))
            lineT.close()
            
            underBackgroundLayer.path = lineT.cgPath
            
            
            
            
            
        }
    }
    
    
    private func drawLines(xRawValue xV:Int,yRawValue yV:Int,lineLayer:CAShapeLayer,circleLayer:CAShapeLayer){
        let line = UIBezierPath(rect: CGRect(x: xV, y:0, width: 1, height: Int(self.frame.height)))
        lineLayer.path = line.cgPath
        lineLayer.strokeColor = UIColor.black.cgColor
        circleLayer.path = UIBezierPath(ovalIn: CGRect(x: xV-4, y: yV-4, width: 8, height: 8)).cgPath
        circleLayer.strokeColor = Colors.blueDark.cgColor
        circleLayer.fillColor = Colors.blueDark.cgColor
        self.layer.addSublayer(circleLayer)
    }
  
    

    
    private func map(value x:Float,minimumInput minIn:Float,maximumInput maxIn:Float,minimumOutput minOut:Float,maximumOutput maxOut:Float)->Int{
        //MARK: Error
        if x+minOut+minIn != 0{
            return Int((x-minIn) * (maxOut-minOut) / (maxIn-minIn) + minOut)
        }
        return 0
    }
    
    private func getClosest(searchValue x:Int,arrayValue arr:Array<Int>)->Int {
        var closest = 0
            for item in arr {
                if closest == 0 || abs(x - closest) > abs(item - x) {
                    closest = item
                }
            }
        return closest
    }
    
            
}

    




