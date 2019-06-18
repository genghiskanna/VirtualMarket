//
//  ForexDetails.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna on 20/02/19.
//  Copyright © 2019 Nishaanth Kanna Ravichandran. All rights reserved.
//

import Foundation
import SwiftyJSON

class ForexDetails{
    public class func getForexData(currency: String)->JSON?{
        
        // returns the forex chart 1d interval 1m
        var jsonData:JSON?
        
        if let url = URL(string: "https://www.alphavantage.co/query?function=FX_MONTHLY&from_symbol=" + currency + "&to_symbol=USD&apikey=Z5X4OYKH21G2IIRN"){
            do{
                jsonData = try JSON(data: Data(contentsOf: url))
            } catch{
                print("Error in getForexData")
            }
            
        }
        
        return jsonData?["Time Series FX (1min)"]
    }
    
    public class func getForexPrice(currency:String)->[Float]{
            var value = [Float]()
            if let url = URL(string: "https://www.freeforexapi.com/api/live?pairs="+currency){
            do{
                let jsonData = try JSON(data: Data(contentsOf: url))
                if jsonData["code"].stringValue == "200"{
                    for (_,jsonVal) in jsonData["rates"]{
                        value.append(jsonVal["rate"].floatValue)
                    }
                }
            } catch{
                print("Error in getForexData")
            }
            
        }
        return value
    }
    
    
}
