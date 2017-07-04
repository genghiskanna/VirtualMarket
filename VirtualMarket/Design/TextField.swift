//
//  File.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 04/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit

@IBDesignable class TextField: UITextField {
    

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBar()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBar()
    }
    
    func setupBar(){
        self.backgroundColor = CurrentSettings.getTheme()["light"]
        self.textColor = CurrentSettings.getTheme()["dark"]
        self.layer.borderColor = Colors.teal.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
        self.tintColor = Colors.teal
        
    }
    
}
