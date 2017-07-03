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
    
    static let darkTheme = ["light":Colors.dark,"dark":Colors.light]
    static let lightTheme = ["dark":Colors.dark,"light":Colors.light]
    struct statusTheme {
        static let dark = "dark"
        static let light = "light"
    }
    
    

    class func getTheme() -> Dictionary<String,UIColor>{
        
        // to get value from CoreData
        
        return self.darkTheme
    }
    
    class func getStatusBar() -> String{
        
        // to get value from CoreData
        
        return statusTheme.light
    }
}
