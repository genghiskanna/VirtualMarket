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
                if let currentPriceString = try String(data: Data(contentsOf: URL(string:"https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol="+forStockName+"&interval=1min&outputsize=compact&apikey=Z5X4OYKH21G2IIRN")!) , encoding: .utf8) {
                    jsonData = JSON.init(parseJSON: currentPriceString)
                }
        } catch {
            print("Error retrieving" + forStockName)
        }
        return jsonData["Time Series (1min)"]
    }
    
    class func getStockInfo(_ forStockName: String) -> JSON {
        do {
            if let currentPriceString = try String(data: Data(contentsOf: URL(string:"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22" + forStockName + "%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=")!) , encoding: .utf8) {
                jsonData = JSON.init(parseJSON: currentPriceString)
            }
        } catch {
            print("Error retrieving" + forStockName)
        }
        return jsonData["query"]["results"]["quote"]
    }
}
