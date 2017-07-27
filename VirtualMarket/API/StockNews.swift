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

class StockNews: NSObject {
    
    class func getNews(_ forStockName: String) -> Dictionary<String,String>{
        
        let url = "https://news.google.com/news?q=" + forStockName + "&output=rss"
        
        Alamofire.request(url).responseRSS() { (response) -> Void in
            if let feed: RSSFeed = response.result.value {
                
                for item in feed.items{
                    print(item.itemDescription)
                    print("\n\n\n\n")
                }
            }
        }
        
        return Dictionary(dictionaryLiteral: ("hola","hola"))
    }
    
}

