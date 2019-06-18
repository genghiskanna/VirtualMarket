//
//  StockData.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 25/09/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import Foundation

struct StockDataSource{
    
    var name: String!
    var companyName: String!
    
    var quote = Quote()
    var chart: Chart!
    var about: String!
    var earnings: Earnings!
    
}


struct Quote{
    var price: String!
    var change: String!
    var changePercent: String!
    var avgVolume: String!
    var wkHigh: String!
    var wkLow: String!
    var peRatio: String!
    var name: String!
    var high: String!
    var low: String!
    var div: String!
    var volume: String!
    var marketCap: String!
    var lastClose: String!
    var lastTime: String!
}

struct Chart{
    var oneDay: ChartValue
    var oneWeek: ChartValue
    var oneMonth: ChartValue
    var threeMonths: ChartValue
    var oneYear: ChartValue
    var fiveYears: ChartValue
}

struct Earnings{
    var date:[Date]
    var earningPerShare: [Float]
    var epsEarningPerShare: [Float]
}

struct ChartValue{
    var prices: [Float]
    var date: [Date]
}
