//
//  CurrentSettings.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 02/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit
import CoreData

class CurrentSettings{
    
    static let darkTheme = ["light":Colors.dark,"lightBase":Colors.darkBase,"dark":Colors.light,"darkBase":Colors.lightBase]
    static let lightTheme = ["dark":Colors.dark,"darkBase":Colors.darkBase,"light":Colors.light,"lightBase":Colors.lightBase]
    struct statusTheme {
        static let dark = "dark"
        static let light = "light"
    }
    
    

    class func getTheme() -> Dictionary<String,UIColor>{
        
        // to get value from CoreData
        if AppDelegate.darkMode{
            return self.darkTheme
        } else {
            return self.lightTheme
        }
        
    }
    
   
}
