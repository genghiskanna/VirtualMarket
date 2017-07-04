//
//  StockDetails.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 03/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import SwiftyJSON

class StockDetails: NSObject {
    
    public var jsonData: JSON!
    func getAllData(forStockName: String) {
        
        do {
            try jsonData = JSON(data: Data(contentsOf:URL(string:"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22"+forStockName+"%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=")!))
        } catch is Error {
            print("Error retrieving"+forStockName)
        }
    }
}
