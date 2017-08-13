//
//  StockDetails.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 03/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import SwiftyJSON

class StockDetails: NSObject {
    
    open static var jsonData: JSON?
    open static var priceUnderWatch: JSON?
    enum StockRange {
        case oneDay
        case oneWeek
        case oneMonth
        case threeMonth
        case sixMonth
        case oneYear
        case max
    }
    
    class func getStockPriceUnderWatch() -> JSON?{
        var searchStock = ""
        do {
            if let stocks = allStocksUnderWatch(){
                for stock in stocks{
                    if searchStock.characters.count == 0{
                        searchStock.append(stock.name!)
                    } else {
                        searchStock.append("," + stock.name!)
                    }
                }
            }
            
            if let currentPriceString = try String(data: Data(contentsOf: URL(string: "https://finance.google.com/finance/info?client=ig&q=" + searchStock)!) , encoding: .utf8)?.replacingOccurrences(of: "/", with: "") {
                priceUnderWatch = JSON.init(parseJSON: currentPriceString)
            }
        } catch {
            print("Error retreiving all ")
        }
        
        return priceUnderWatch
    }
    
    class func getStockPrice(forStockName stockName: String) -> JSON?{
        
        do {
            if let currentPriceString = try String(data: Data(contentsOf: URL(string: "https://finance.google.com/finance/info?client=ig&q=" + stockName)!) , encoding: .utf8)?.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "") {
                jsonData = JSON.init(parseJSON: currentPriceString)
            }
        } catch {
            print("Error retrieving" + stockName)
        }
        return jsonData
    }
    
    
    
    class func getOpenClose(forStockName stockName: String) -> JSON?{
        
            do {
                if let currentPriceString = try String(data: Data(contentsOf: URL(string:"https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol="+stockName+"&interval=1min&outputsize=compact&apikey=Z5X4OYKH21G2IIRN")!) , encoding: .utf8) {
                    jsonData = JSON.init(parseJSON: currentPriceString)
                }
        } catch {
            print("Error retrieving" + stockName)
        }
        return jsonData?["Time Series (1min)"]
    }
    
    
    
    
    class func getStockInfo(forStockName stockName: String) -> JSON? {
        do {
            if let currentPriceString = try String(data: Data(contentsOf: URL(string:"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(%22" + stockName + "%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=")!) , encoding: .utf8) {
                jsonData = JSON.init(parseJSON: currentPriceString)
            }
        } catch {
            print("Error retrieving" + stockName)
        }
        return jsonData?["query"]["results"]["quote"]
    }
    
    
    class func getChartData(forStockName stockName: String,inRange range: StockRange) -> JSON?{
        var url: URL?
        switch range {
            case .oneDay:
                url = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol="
                    + stockName + "&interval=15min&outputsize=compact&apikey=Z5X4OYKH21G2IIRN")
            
            case .oneWeek:
                url = URL(string: "https://www.quandl.com/api/v3/datasets/WIKI/"+stockName+".json?column_index=11&collapse=daily&rows=7&api_key=bDqCujUFrVTw3TrvYi7w")
                
            case .oneMonth:
                url = URL(string: "https://www.quandl.com/api/v3/datasets/WIKI/"+stockName+".json?column_index=11&collapse=daily&rows=30&api_key=bDqCujUFrVTw3TrvYi7w")
                
            case .threeMonth:
                url = URL(string: "https://www.quandl.com/api/v3/datasets/WIKI/"+stockName+".json?column_index=11&collapse=daily&rows=90&api_key=bDqCujUFrVTw3TrvYi7w")
                
            case .sixMonth:
                url = URL(string: "https://www.quandl.com/api/v3/datasets/WIKI/"+stockName+".json?column_index=11&collapse=daily&rows=180&api_key=bDqCujUFrVTw3TrvYi7w")
                
            case .oneYear:
                url = URL(string: "https://www.quandl.com/api/v3/datasets/WIKI/"+stockName+".json?column_index=11&collapse=weekly&rows=365&api_key=bDqCujUFrVTw3TrvYi7w")
            
            case .max:
                url = URL(string: "https://www.quandl.com/api/v3/datasets/WIKI/"+stockName+".json?column_index=11&collapse=monthly&api_key=bDqCujUFrVTw3TrvYi7w")
            
        }
        
        if let url = url {
            do {
                if let json = try String.init(data: Data.init(contentsOf: url), encoding: .utf8) {
                    jsonData = JSON(parseJSON: json)
                }
                
            } catch{
                print("Error occured \(stockName)")
            }
        }
        
        if range == .oneDay{
            return jsonData?["Time Series (15min)"]
        } else {
            return jsonData?["dataset"]["data"]
        }
        
    }
//    
//    class func getMarketOpen(forStockName stockName:String)-> Bool{
//        'h:mm a zzz'
//        if let currentPriceString = try String(data: Data(contentsOf: URL(string: "https://finance.google.com/finance/info?client=ig&q=" + stockName)!) , encoding: .utf8)?.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "") {
//            var tempJson = JSON.init(parseJSON: currentPriceString)
//        }
//        let date = tempJson[']
//    }
}
