//
//  StockNews.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 16/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit
import SwiftyJSON

public var newsUnderWatch: JSON?

func stockNews(){
    
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
        if let url = URL(string:"https://api.iextrading.com/1.0/stock/market/batch?symbols=" + searchStock + "&types=news"){
            if let currentPriceString = try String(data: Data(contentsOf: url), encoding: .utf8){
                newsUnderWatch = JSON.init(parseJSON: currentPriceString)
                
            }
        }
    } catch {
        print("Error retreiving news")
    }
    
    
    
    // updating stocks
    
    if let stocks = allStocksUnderWatch(){
        
        for stock in stocks{
            var loop = 0
            while loop < AppDelegate.stockData.count{
                
                if stock.name!.contains(AppDelegate.stockData[loop].name){
                    
                    if let stockTemp = newsUnderWatch?[stock.name!]["news"].arrayValue{
                    
                        for news in stockTemp{
                            var newNews = News()
                            newNews.title = news["headline"].stringValue
                            newNews.source = news["source"].stringValue
                            newNews.url = URL(string: news["url"].stringValue)
                            AppDelegate.stockData[loop].news.append(newNews)
                        }
                        
                        
                        
                    }
                    
                }
                loop += 1
            }
            
        }
    }
}


func getNewsForStock(stockName: String) -> StockDataSource?{
    var tempStock = StockDataSource()
    do {
        if let url = URL(string:"https://api.iextrading.com/1.0/stock/market/batch?symbols=" + stockName + "&types=news"){
            if let currentPriceString = try String(data: Data(contentsOf: url), encoding: .utf8){
                newsUnderWatch = JSON.init(parseJSON: currentPriceString)
                
            }
        }
    } catch {
        print("Error retreiving news")
    }
    
    if let stockTemp = newsUnderWatch?[stockName]["news"].arrayValue{
        for news in stockTemp{
            var newNews = News()
            newNews.title = news["headline"].stringValue
            newNews.source = news["source"].stringValue
            newNews.url = URL(string: news["url"].stringValue)
            tempStock.news.append(newNews)
        }
    }
    
    return tempStock
}









