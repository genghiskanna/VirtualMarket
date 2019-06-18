//
//  StockDetails.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 03/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import SwiftyJSON

class StockDetails: NSObject {
    
    public static var jsonData: JSON?
    
    fileprivate static var priceUnderWatch: JSON?
    fileprivate static var topGainersJson: JSON?
    
    enum StockRange {
        case oneDay
        case oneMonth
        case threeMonth
        case sixMonth
        case oneYear
        case fiveYear
    }
    
    class func getTopGainers()->Array<StockDataSource>{
        // Getting Top Gainers
        var topGainersSymbol = Array<StockDataSource>()
        let symbols = ["HSI","DJI","DAX"]
        
        for s in symbols{
            var tempStock = StockDataSource()
            tempStock.name = s
            topGainersSymbol.append(tempStock)
        }
        return topGainersSymbol
        
    }
    
    @objc class func getStockPriceUnderWatch(){
        var searchStock = ""
        
        // Getting Stock Quote Data
        do {
            if let stocks = allStocksUnderWatch(){
                for stock in stocks{
                    if searchStock.count == 0{
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
        
        // Creating an Object so that future multiple requests can be served from the object instead of API
        
        if let stocks = allStocksUnderWatch(){
            
            for stock in stocks{
                
                if let stockTemp = priceUnderWatch?[stock.name!]["quote"]{
                    AppDelegate.stockData[stock.name!]?.companyName = stockTemp["companyName"].stringValue
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
                    AppDelegate.stockData[stock.name!]?.quote.lastTime = stockTemp["latestTime"].stringValue
                    AppDelegate.stockData[stock.name!]?.quote.lastClose = stockTemp["previousClose"].stringValue
                }
            }
        }
        
    }
    
    
    class func getStockPrice(stockName: String) -> StockDataSource?{
        
        // Checking if data for a particular stock exists:
        //if not, then gets the data from api, if  yes, then gets from AppDelegate
        
        if AppDelegate.stockData[stockName] == nil{
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
                tempStock.companyName = stockTemp["companyName"].stringValue
                tempStock.quote.price = stockTemp["latestPrice"].stringValue
                tempStock.quote.change = String(format: "%.2f", stockTemp["change"].doubleValue)
                tempStock.quote.changePercent = String(format: "%.2f", stockTemp["changePercent"].doubleValue)
                tempStock.quote.avgVolume = stockTemp["avgTotalVolume"].stringValue
                tempStock.quote.wkHigh = stockTemp["week52High"].stringValue
                tempStock.quote.wkLow = stockTemp["week52Low"].stringValue
                tempStock.quote.peRatio = stockTemp["peRatio"].stringValue
                tempStock.quote.name = stockTemp["companyName"].stringValue
                tempStock.quote.marketCap = stockTemp["marketCap"].stringValue
                tempStock.quote.volume = stockTemp["latestVolume"].stringValue
                tempStock.quote.lastClose = stockTemp["previousClose"].stringValue
                tempStock.quote.lastTime = stockTemp["latestTime"].stringValue
            
            }
            return tempStock
        } else {
            return AppDelegate.stockData[stockName]
        }
        
    }
    
    

    // MARK Error
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
        // type indicates whether we are using IEX or Alphavantage, 0 = IEX, 1 = AlphaVantage
        var type = 0
        var url: URL?
        var urlAlternative: URL?
        var dateString = ""
        switch range {
            case .oneDay:
                
                // Calculate last date when stock market was active
                if let tempStock = self.getStockPrice(stockName: stockName){
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMMM d, yyyy"
                    if let date = dateFormatter.date(from: tempStock.quote.lastTime){
                        dateFormatter.dateFormat = "yyyyMMdd"
                        dateString = dateFormatter.string(from: date)
                    }

                }
                url = URL(string: "https://api.iextrading.com/1.0/stock/"+stockName+"/chart/1d?chartInterval=5")
                urlAlternative = URL(string: "https://api.iextrading.com/1.0/stock/"+stockName+"/chart/date/"+dateString)

            case .oneMonth:
                url = URL(string: "https://api.iextrading.com/1.0/stock/"+stockName+"/chart/1m")
                
            case .threeMonth:
                url = URL(string: "https://api.iextrading.com/1.0/stock/"+stockName+"/chart/3m")
                
            case .sixMonth:
                url = URL(string: "https://api.iextrading.com/1.0/stock/"+stockName+"/chart/6m")
                
            case .oneYear:
                url = URL(string: "https://api.iextrading.com/1.0/stock/"+stockName+"/chart/1y?chartInterval=2")
            
            case .fiveYear:
                url = URL(string: "https://api.iextrading.com/1.0/stock/"+stockName+"/chart/5y?chartInterval=6")
            
        }
        
        if let url = url {
            do {
                
                if let json = try String.init(data: Data.init(contentsOf: url), encoding: .utf8) {
                    jsonData = JSON(parseJSON: json)
                    if jsonData!.count == 0{
                        if let json = try String.init(data: Data.init(contentsOf: urlAlternative!), encoding: .utf8) {
                            jsonData = JSON(parseJSON: json)
                        }
                    }
                }
                
            } catch{
                print("Error occured \(stockName)")
            }
        }
        
        return jsonData
        
    }
}
