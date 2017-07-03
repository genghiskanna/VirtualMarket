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
    
    func setupBar(){
        self.barTintColor = CurrentSettings.getTheme()["light"]
        self.titleTextAttributes = [NSForegroundColorAttributeName:CurrentSettings.getTheme()["dark"]!]
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: 60)
    }

}
