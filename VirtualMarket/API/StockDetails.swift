//
//  StockDetails.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 03/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import SwiftyJSON

class StockDetails: NSObject {
    
    open static var jsonData: JSON!
    class func getStockPrice(_ forStockName: String) -> JSON{
        
        do {
            print("http://finance.google.com/finance/info?client=ig&q=" + forStockName)
            if let currentPriceString = try String(data: Data(contentsOf: URL(string: "https://finance.google.com/finance/info?client=ig&q=" + forStockName)!) , encoding: .utf8)?.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "") {
                jsonData = JSON.init(parseJSON: currentPriceString)
            }
        } catch {
            print("Error retrieving" + forStockName)
        }
        return jsonData
    }
    
    class func getOpenClose(_ forStockName: String) -> JSON{
        
            do {
                if let currentPriceString = try String(data: Data(contentsOf: URL(string:"https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol="+forStockName+"&interval=1min&outputsize=full&apikey=Z5X4OYKH21G2IIRN")!) , encoding: .utf8) {
                    jsonData = JSON.init(parseJSON: currentPriceString)
                }
        } catch {
            print("Error retrieving" + forStockName)
        }
        return jsonData["Time Series (1min)"]
        
    }
}
