//
//  Button.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 14/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit

@IBDesignable class ButtonOrder: UIButton{
    
    @IBInspectable var text: String?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        layer.cornerRadius = 5.0
        tintColor = Colors.light
        titleLabel?.textColor = Colors.light
        backgroundColor = Colors.light

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
        tintColor = Colors.light
        titleLabel?.textColor = Colors.light
        backgroundColor = Colors.light
    }
    
   
}
