//
//  SearchJSON.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 03/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import Foundation

class SearchJSON: NSObject {
    
    fileprivate class func SearchMarket(_ json: NSArray, text: String) -> NSArray{
        
        var searchResults = Array<Any>()
        
        for stock in json{
            if let stockD = stock as? NSDictionary{
                let symbol = (stockD["Symbol"] as! String).lowercased()
                let name = (stockD["Name"] as! String).lowercased()
                if ((symbol.range(of: text.lowercased()) != nil) || (name.range(of: text.lowercased()) != nil)){
                    searchResults.append(stockD)
                    
                }
            }
        }
        if text.characters.count != 1 {
            return searchResults as NSArray
        } else {
            return []
        }
        
    }
    
    
    @objc class func SearchStock(_ text: String) -> Dictionary<String,NSArray>{
        
        var searchResult: Dictionary<String,NSArray> = ["empty":[1,2,3]]
        
        //load all json's
        //NASDAQ
        let nasdaqPath = Bundle.main.url(forResource: "nasdaq", withExtension: "json")!
        let nasdaqData = try? Data(contentsOf: nasdaqPath)
        let nasdaq = try? JSONSerialization.jsonObject(with:nasdaqData!, options: .mutableContainers) as! NSArray
        if let nasdaqResults = SearchMarket(nasdaq!, text: text) as? NSArray{
            
            if nasdaqResults.count != 0 {
                searchResult.updateValue(nasdaqResults, forKey: "NASDAQ")
            }
        }
        
        
        //NYSE
        let nysePath = Bundle.main.url(forResource: "nyse", withExtension: "json")!
        let nyseData = try? Data(contentsOf: nysePath)
        let nyse = try? JSONSerialization.jsonObject(with:nyseData!, options: .mutableContainers) as! NSArray
        if let nyseResults = SearchMarket(nyse!, text: text) as? NSArray{
            if nyseResults.count != 0{
                searchResult.updateValue(nyseResults, forKey: "NYSE")
            }
        }
        
        
        //AMEX
        let amexPath = Bundle.main.url(forResource: "amex", withExtension: "json")!
        let amexData = try? Data(contentsOf: amexPath)
        let amex = try? JSONSerialization.jsonObject(with:amexData!, options: .mutableContainers) as! NSArray
        if let amexResults = SearchMarket(amex!, text: text) as? NSArray{
            
            if amexResults.count != 0{
                searchResult.updateValue(amexResults, forKey: "AMSE")
            }
        }

        return searchResult
    }
    
 
}
