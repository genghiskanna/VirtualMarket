//
//  StockNews.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 16/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit
import FeedKit


func stockNews(forStockName stockName: String) -> FeedParser?{
    
    let url = URL(string: "https://feeds.finance.yahoo.com/rss/2.0/headline?s=" + stockName + "&lang=en-US")
    
    return FeedParser(URL: url!)
}









