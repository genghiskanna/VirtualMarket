//
//  StockNews.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 16/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit
import SwiftyJSON
import FeedKit
import Kanna


func stockNews()->RSSFeed?{
    var newsUnderWatchFeed:RSSFeed?
    var searchStock = ""
    
    // Getting Stock Quote Data
    
    if let stocks = allStocksUnderWatch(){
        for stock in stocks{
            if searchStock.count == 0{
                searchStock.append(stock.name!)
            } else {
                searchStock.append("," + stock.name!)
            }
        }
    }
    if let feedURL = URL(string:"https://feeds.finance.yahoo.com/rss/2.0/headline?s=" + searchStock + "&region=US&lang=en-US"){
        let stockNewsParser = FeedParser(URL: feedURL)
        let result = stockNewsParser.parse()
        newsUnderWatchFeed = result.rssFeed
    }
    
    //getting the image and publisher
    var i = 0
    while i < (newsUnderWatchFeed?.items?.count)!{
        if let feedHtml = URL(string:(newsUnderWatchFeed?.items?[i].link)!){
            do{
                let htmlDoc = try HTML(url: feedHtml, encoding: .utf8)
                print(htmlDoc.innerHTML)
                for tag in htmlDoc.css("a") {
                    if tag["class"] == "link rapid-noclick-resp caas-attr-provider caas-attr-item"{
                        newsUnderWatchFeed?.items?[i].author = tag.innerHTML!
                        newsUnderWatchFeed?.items?[i].description = tag["href"]!
                    }
                }

                //image
                for tag in htmlDoc.css("meta") {
                    if tag["name"] == "twitter:image"{
                        newsUnderWatchFeed?.items?[i].comments = tag["content"]!
                    }
                }

            } catch {
                print("Error Parsing HTML \(error.localizedDescription)")
            }
        }

        i+=1
    }
    
    return newsUnderWatchFeed
}


//func getNewsForStock(stockName: String) -> StockDataSource?{
//    if AppDelegate.stockData[stockName] == nil{
//        var tempStock = StockDataSource()
//        do {
//            if let url = URL(string:"https://api.iextrading.com/1.0/stock/market/batch?symbols=" + stockName + "&types=news"){
//                if let currentPriceString = try String(data: Data(contentsOf: url), encoding: .utf8){
//                    newsUnderWatch = JSON.init(parseJSON: currentPriceString)
//
//                }
//            }
//        } catch {
//            print("Error retreiving news")
//        }
//
//        if let stockTemp = newsUnderWatch?[stockName]["news"].arrayValue{
//            for news in stockTemp{
//                var newNews = News()
//                newNews.title = news["headline"].stringValue
//                newNews.source = news["source"].stringValue
//                newNews.url = URL(string: news["url"].stringValue)
//                tempStock.news.append(newNews)
//            }
//        }
//        return tempStock
//    } else {
//        return AppDelegate.stockData[stockName]
//    }
//
//
//}



//extension RSSFeedItem{
//    public var image: String?
//    public var publisher: String?
//}





