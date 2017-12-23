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
    
    class func getStockPriceUnderWatch(){
        var searchStock = ""
        
        // Getting Stock Quote Data
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
            if let url = URL(string:"https://api.iextrading.com/1.0/stock/market/batch?symbols=" + searchStock + "&types=quote"){
                if let currentPriceString = try String(data: Data(contentsOf: url), encoding: .utf8){
                    priceUnderWatch = JSON.init(parseJSON: currentPriceString)
                    
                }
            }
        } catch {
            print("Error retreiving  getStockPriceUnderWatch")
        }
        // updating stocks
        
        if let stocks = allStocksUnderWatch(){
            
            for stock in stocks{
                
                if let stockTemp = priceUnderWatch?[stock.name!]["quote"]{
                    AppDelegate.stockData[stock.name!]?.quote.price = stockTemp["latestPrice"].stringValue
                    AppDelegate.stockData[stock.name!]?.quote.change = stockTemp["change"].stringValue
                    AppDelegate.stockData[stock.name!]?.quote.changePercent = stockTemp["changePercent"].stringValue
                    AppDelegate.stockData[stock.name!]?.quote.avgVolume = stockTemp["avgTotalVolume"].stringValue
                    AppDelegate.stockData[stock.name!]?.quote.wkHigh = stockTemp["week52High"].stringValue
                    AppDelegate.stockData[stock.name!]?.quote.wkLow = stockTemp["week52Low"].stringValue
                    AppDelegate.stockData[stock.name!]?.quote.peRatio = stockTemp["peRatio"].stringValue
                    AppDelegate.stockData[stock.name!]?.quote.name = stockTemp["companyName"].stringValue
                    AppDelegate.stockData[stock.name!]?.quote.marketCap = stockTemp["marketCap"].stringValue
                    AppDelegate.stockData[stock.name!]?.quote.volume = stockTemp["latestVolume"].stringValue
                }
            }
        }
        
    }
    
    
    class func getStockPrice(stockName: String) -> StockDataSource?{
        print("GO")
        if AppDelegate.stockData[stockName] == nil{
            print("GO22")
            var tempStock = StockDataSource()
            
            // Getting Stock Quote Data
            do {
                if let url = URL(string:"https://api.iextrading.com/1.0/stock/" + stockName + "/quote"){
                    if let currentPriceString = try String(data: Data(contentsOf: url), encoding: .utf8){
                        priceUnderWatch = JSON.init(parseJSON: currentPriceString)
                    }
                }
            } catch {
                print("Error retreiving  getStockPrice \(stockName)")
            }
            
            if let stockTemp = priceUnderWatch{
                tempStock.name = stockName
                print(stockTemp)
                print(stockTemp["latestPrice"].stringValue)
                tempStock.quote.price = stockTemp["latestPrice"].stringValue
                tempStock.quote.change = stockTemp["change"].stringValue
                tempStock.quote.changePercent = stockTemp["changePercent"].stringValue
                tempStock.quote.avgVolume = stockTemp["avgTotalVolume"].stringValue
                tempStock.quote.wkHigh = stockTemp["week52High"].stringValue
                tempStock.quote.wkLow = stockTemp["week52Low"].stringValue
                tempStock.quote.peRatio = stockTemp["peRatio"].stringValue
                tempStock.quote.name = stockTemp["companyName"].stringValue
                tempStock.quote.marketCap = stockTemp["marketCap"].stringValue
                tempStock.quote.volume = stockTemp["latestVolume"].stringValue
            
            }
            return tempStock
        } else {
            print("GO11")
            return AppDelegate.stockData[stockName]
        }
        
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
