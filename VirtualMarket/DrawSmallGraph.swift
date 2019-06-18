//
//  DrawSmallGraph.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna on 16/02/19.
//  Copyright © 2019 Nishaanth Kanna Ravichandran. All rights reserved.
//

import Foundation
import UIKit

public func drawSmallGraph(stockOrCurrencyName:String,isCurrency:Bool)->CAGradientLayer{
    let baseLayer = CAShapeLayer()
    var xRaw = Array<Int>()
    var yRaw = Array<Int>()
    
    var y = [Double]()
    var x = [String]()
    
    
    
    if isCurrency{
        
        if let graphData = ForexDetails.getForexData(currency: stockOrCurrencyName) {
            y = [Double]()
            x = [String]()
            for(date,value) in graphData{
                y.append(value["4. close"].doubleValue)
                x.append(date)
            }
            print(stockOrCurrencyName)
            print(y)
        }
    } else {
        if let graphData = StockDetails.getChartData(forStockName: stockOrCurrencyName, inRange: .oneDay){
            // IEX Api
            for (_,value) in graphData{
                y.append(value["close"].doubleValue)
                x.append(value["label"].stringValue)
            }
        }
    }
    let gradTemp = CAGradientLayer()
    if x.count + y.count > 10{
        // Normalizing x
        for i in 1...x.count{
            let maxIn = 78.0
            xRaw.append(map(value: Double(i), minimumInput: 1.0, maximumInput: Double(maxIn), minimumOutput: 1.0, maximumOutput: 60.0))
        }
        // Normalizing y
        for i in y{
            // minus by 40 (thats the height of the view) to inverse the graph
            yRaw.append(40-map(value: i, minimumInput: y.min()!, maximumInput:y.max()!, minimumOutput: 10.0, maximumOutput: 30.0))
        }
        let tempA = smooth(X:xRaw,Y:yRaw)
        xRaw = tempA[0]
        yRaw = tempA[1]
        
        
        let line = UIBezierPath()
        line.move(to: CGPoint(x: 0, y: yRaw[0]))
        for i in 1..<yRaw.count {
            line.addLine(to: CGPoint(x: xRaw[i], y: yRaw[i]))
        }
        baseLayer.path = line.cgPath
        baseLayer.fillColor = UIColor.clear.cgColor
        baseLayer.borderColor  = UIColor.clear.cgColor
        baseLayer.borderWidth = 0.0
        baseLayer.lineWidth = 3
        baseLayer.backgroundColor = UIColor.clear.cgColor
        
        //Gradient
        let lineT = UIBezierPath()
        lineT.move(to: CGPoint(x: xRaw[0], y: 40))
        for i in 1..<yRaw.count {
            lineT.addLine(to: CGPoint(x: xRaw[i], y: yRaw[i]))
        }
        lineT.addLine(to: CGPoint(x: xRaw.last!, y: 40))
        lineT.close()
        
        let underBackgroundLayer = CAShapeLayer()
        underBackgroundLayer.path = lineT.cgPath
        
        
        
        
        gradTemp.startPoint = CGPoint(x: 0, y: 0)
        gradTemp.endPoint = CGPoint(x: 0.1, y: 1)
        
        gradTemp.mask = underBackgroundLayer
        gradTemp.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        gradTemp.addSublayer(baseLayer)
        
        if y[0] > y.last!{
            baseLayer.strokeColor = Colors.materialRed.cgColor
            gradTemp.colors = [Colors.materialRed.cgColor,Colors.light.cgColor]
        } else {
            baseLayer.strokeColor = Colors.materialGreen.cgColor
            gradTemp.colors = [Colors.materialGreen.cgColor,Colors.light.cgColor]
        }
    
    
    }
    return gradTemp
}

extension UIImage {
    class func imageWithLayer(layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.isOpaque, 0.0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}

private func map(value x:Double,minimumInput minIn:Double,maximumInput maxIn:Double,minimumOutput minOut:Double,maximumOutput maxOut:Double)->Int{
    //MARK: Error
    if x+maxIn+minIn != 0{
        return Int((x-minIn) * (maxOut-minOut) / (maxIn-minIn) + minOut)
    }
    return 0
}
public extension CALayer {
    
    public func applyGradient(of colors: UIColor...) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors
        gradient.mask = self
        return gradient
    }
    
}

private func smooth(X:Array<Int>,Y:Array<Int>)->Array<Array<Int>>{
    var newX = Array<Int>()
    var newY = Array<Int>()

    var i = 0
    while i+2<X.count{
        newX.append((X[i]+X[i+1]+X[i+2])/3)
        newY.append((Y[i]+Y[i+1]+Y[i+2])/3)
        i+=1
    }
    return [newX,newY]
}
