//
//  CustomNavigationBar.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 02/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit


@IBDesignable class CustomNavigationBar: UINavigationBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupBar()
    }
    
    @objc func setupBar(){
        self.isTranslucent = false
        self.barTintColor = CurrentSettings.getTheme()["light"]
        self.tintColor = CurrentSettings.getTheme()["dark"]
        
        self.setValue(true, forKey: "hidesShadow")
        // Warning
        self.titleTextAttributes = [NSAttributedString.Key.foregroundColor:CurrentSettings.getTheme()["dark"]!]
    }

}
