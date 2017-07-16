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
    
    func setupView(){
        self.layer.backgroundColor = Colors.blueDark.cgColor
        self.layer.borderWidth = 2
        self.layer.borderColor = Colors.light.cgColor
        self.layer.cornerRadius = 30.0
    }
}
