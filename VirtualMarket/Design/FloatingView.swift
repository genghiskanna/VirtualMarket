//
//  FloatingView.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 03/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit

@IBDesignable class FloatingView: UIView {
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @objc func setupView(){
        if AppDelegate.darkMode{
            self.layer.backgroundColor = Colors.dark.cgColor
        } else {
            self.layer.backgroundColor = Colors.light.cgColor
        }
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15.0
    }
}
