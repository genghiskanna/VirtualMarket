//
//  SegmentedControl.swift
//  testSegmentedControl
//
//  Created by Nishaanth Kanna Ravichandran on 01/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit

@IBDesignable class SegmentedControl: UIControl{
    
    
    fileprivate var labels = [UILabel]()
    
    @objc let thumbView = UIView()
    @objc var labelStrings = ["Stocks","Others"]
    var selectedIndex :Int?
    @objc var xSkip = 0
    @objc var color = Colors.lightTeal
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewAndLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViewAndLabels()
    }


    
    @objc func setupViewAndLabels(){
        // Gradient Layer
        
        
        
        //setting up view
        self.backgroundColor = .clear
        self.layer.borderColor = self.color.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width:302, height: self.frame.height)
//        print(UIScreen.main.bounds.width - (self.frame.origin.x * 2))
        
        
        
        var i = 0
        xSkip = 302 / self.labelStrings.count
        //setting up labels
        for labelText in labelStrings{
            let label = UILabel(frame: CGRect(x: xSkip * i, y: 0, width: xSkip, height: Int(self.frame.height)))
            label.font = UIFont.systemFont(ofSize: 13.0)
            label.textAlignment = .center
            if i == 0{
                // Initializing the thumbView First
                self.thumbView.frame = CGRect(x: 0, y: 0, width: self.frame.width / CGFloat(self.labelStrings.count), height: self.frame.height)
                
                let gradLayer = CAGradientLayer()
                gradLayer.frame = self.thumbView.bounds
                gradLayer.colors = [Colors.lightBlueSpecial.cgColor, Colors.lightTeal.cgColor]
                gradLayer.cornerRadius = 5.0
                self.thumbView.layer.addSublayer(gradLayer)
                self.thumbView.layer.cornerRadius = 5.0
                self.addSubview(thumbView)
                label.textColor = .white
            } else {
                label.textColor = self.color
            }
            label.text = labelText
            
            self.addSubview(label)
            labels.append(label)
            i+=1
            
        }
        //setting up thumbView

        
        
    }
    
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        xSkip = Int(self.frame.size.width) / self.labelStrings.count
        let touchL = touch.location(in: self)
        for i in 0..<labels.count{
            labels[i].textColor = self.color
            if labels[i].frame.contains(touchL){
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .allowAnimatedContent, animations: {
                    self.labels[i].textColor = .white
                    self.thumbView.frame = CGRect(x: CGFloat(i * self.xSkip), y: 0, width: self.frame.width / CGFloat(self.labels.count), height: self.frame.height)
                
                }, completion: nil)
               
            }
            
        }
        return false
    }

}
