//
//  Button.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 14/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit

@IBDesignable class Button: UIButton{
    
    @IBInspectable var text: String?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton(){
        backgroundColor = Colors.teal
        layer.borderColor = Colors.teal.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0
        
        titleLabel?.text = self.text
        tintColor = Colors.light
        titleLabel?.textColor = Colors.light
        
    }
}
