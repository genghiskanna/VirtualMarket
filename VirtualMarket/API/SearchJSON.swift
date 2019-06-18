//
//  SearchJSON.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 03/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import Foundation
import SwiftyJSON

class SearchJSON: NSObject {
    
    fileprivate class func SearchMarket(_ json: JSON, text: String) -> Array<String>{
        
        var searchResults = Array<String>()

        for (_,stockD) in json{

            if stockD["isEnabled"].boolValue == true && stockD["type"].stringValue != "crypto"{
                let symbol = stockD["symbol"].stringValue.lowercased()
                let name = stockD["name"].stringValue.lowercased()
                if ((symbol.range(of: text.lowercased()) != nil) || (name.range(of: text.lowercased()) != nil)){
                    
                    // Format symbol;companyname
                    searchResults.append(stockD["symbol"].stringValue + ";" + stockD["name"].stringValue)
                }
            }
        }
        return searchResults
    }
    
    
    @objc class func SearchStock(_ text: String) -> Array<String>{
        var iexResults = Array<String>()
        do{
            let iexPath = Bundle.main.url(forResource: "stockSymbolData", withExtension: "json")!
            let iexData = try String.init(data: Data.init(contentsOf:iexPath),encoding: .utf8)
    
            let iex = JSON(parseJSON: iexData!)
            
            iexResults = SearchJSON.SearchMarket(iex, text: text)
            
        
        } catch {
            print("Error occured in searchStock")
        }
        print(iexResults)
        return iexResults
    }
    
    
}
