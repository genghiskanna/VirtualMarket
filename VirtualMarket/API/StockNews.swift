//
//  StockNews.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 16/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireRSSParser

    func stockNews(_ forStockName: String, completionHandler: @escaping (RSSFeed, Error?) -> ()){
        
        let url = "https://news.google.com/news?q=" + forStockName + "&output=rss"
        
        Alamofire.request(url).responseRSS() { (response) -> Void in
            if let feed: RSSFeed = response.result.value {
                completionHandler(feed, nil)
            }
        }
    }
    
    
    func getNews(forStockName: String, completionHandler: @escaping (RSSFeed, Error?) -> ()) {
        stockNews(forStockName, completionHandler: completionHandler)
    }




