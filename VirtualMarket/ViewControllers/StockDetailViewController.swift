//
//  StockDetailViewController.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 16/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit
import SwiftyJSON
import AlamofireRSSParser
import Kanna

class StockDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ChartViewDelegate, SegmentedControl6Delegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Data 
    
    open var stock: String!
    var indexDetails = [StockDetails.StockRange.oneDay, StockDetails.StockRange.oneWeek, StockDetails.StockRange.oneMonth,StockDetails.StockRange.threeMonth,StockDetails.StockRange.sixMonth,StockDetails.StockRange.oneYear,StockDetails.StockRange.max]
    var graphLayers = [CAShapeLayer(),CAShapeLayer(),CAShapeLayer(),CAShapeLayer(),CAShapeLayer(),CAShapeLayer(),CAShapeLayer()]

    // label
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var priceFloat: UILabel!
    @IBOutlet weak var change: UILabel!
    
    @IBOutlet weak var priceChart: UILabel!
    @IBOutlet weak var dateChart: UILabel!
    
    
    //stats
    @IBOutlet weak var openPrice: UILabel!
    @IBOutlet weak var highPrice: UILabel!
    @IBOutlet weak var lowPrice: UILabel!
    @IBOutlet weak var wkHigh: UILabel!
    @IBOutlet weak var wkLow: UILabel!
    @IBOutlet weak var volume: UILabel!
    @IBOutlet weak var avgVolume: UILabel!
    @IBOutlet weak var mktCap: UILabel!
    @IBOutlet weak var prRatio: UILabel!
    @IBOutlet weak var div: UILabel!
    
    @IBOutlet weak var followButton: Button!
    
    // News
    @IBOutlet weak var newsTable: UITableView!

    // News DataSource
    var newsFeed: RSSFeed?
    
    @IBOutlet weak var segmentControl: SegmentedControl6!
    @IBOutlet weak var chart: ChartView!
    
    // current graph
   
    var currentGraph = CAShapeLayer()
    
    // flags 
    var firstFlag = true
    
    
    // IBActions
    @IBAction func buyPressed(_ sender: Any) {
    }
    
    
    @IBAction func followPressed(_ sender: Any) {
        if self.stock != nil{
            if self.followButton.title(for: .normal) == "Follow"{
                insertStock(self.stock!, orderType: nil, quantity: nil, priceBought: nil, worthBefore: nil, status: "following")
                self.change.text = "Following \(self.stock!)"
                self.followButton.setTitle("UnFollow", for: .normal)
            } else {
                self.change.text = "Not Inserted"
                deleteStock(forStockName: self.stock)
                self.followButton.setTitle("Follow", for: .normal)
            }
        }
        
    }
    
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Constantly update

        
        self.newsTable.dataSource = self
        self.newsTable.delegate = self
        self.chart.delegate = self
        self.segmentControl.delegate = self
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stock = stockNameG
        if let status = getStockStatus(forStockName: self.stock) {
            
            if status.contains("following"){
                self.followButton.setTitle("UnFollow", for: .normal)
            } else {
                self.followButton.setTitle("Sell", for: .normal)
            }
        }
        
        
        
        // update Values
        updateStockPrice(delay: 1)
        updateDayStats(delay: 5)
        updateLongStats(delay: 30)
        updateChart(inRange: .oneDay)
    }
    
    
    func updateStockPrice(delay time: UInt32){
        // updating fast
        DispatchQueue.global(qos: .userInitiated).async {
            
            while true{
                if let jsonPrice = StockDetails.getStockPrice(forStockName: self.stock) {
                    
                    let sPrice = jsonPrice["l"].stringValue
                    let splitPrice = sPrice.components(separatedBy: ".")

                    
                    DispatchQueue.main.async {
                        
                        self.stockName.text = jsonPrice["t"].stringValue
                        self.price.text = splitPrice.first
                        // fatal error: Index out of range occure
                        self.priceFloat.text = "." + splitPrice[1]
                    }
                }
                sleep(time)
            }
        }


    }
    
    
    func updateChart(inRange range:StockDetails.StockRange){
        DispatchQueue.global(qos: .userInitiated).async {
            var prices = [Float]()
            var dates = [Date]()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
            var first = true
            var todayDate = "2017-00-22"
            if let json = StockDetails.getChartData(forStockName: self.stock, inRange: range){
                
                if range == .oneDay{
                
                    for (tempDate,value) in json{
                        if first{
                            todayDate = tempDate.substring(to: "2017-07-28".endIndex)
                            prices.append(value["4. close"].floatValue)
                            if let date = dateFormatter.date(from: tempDate){
                                dates.append(date)
                            }
                            first = false
                        } else {
                            if tempDate.contains(todayDate){
                                prices.append(value["4. close"].floatValue)
                                if let date = dateFormatter.date(from: tempDate){
                                    dates.append(date)
                                }
                            }
                        }
                    }
                    
                } else {
                    for (_, data) in json{
                        dateFormatter.dateFormat = "yyyy-mm-dd"
                        if let dateF = dateFormatter.date(from: data[0].stringValue){
                            dates.append(dateF)
                        }
                        prices.append(data[1].floatValue)
                        
                    }
                }
            }
            
            // main thread
            DispatchQueue.main.async {
                print("called")
                print(prices)
                print(dates)
                self.chart.x = dates
                self.chart.y = prices
                var divison = 26
                switch range {
                    case .oneDay:
                        divison = 26
                        if !self.firstFlag{
                            self.currentGraph.removeFromSuperlayer()
                        }
                        self.firstFlag = false
                    case .oneWeek:
                        divison = 7
                        self.currentGraph.removeFromSuperlayer()
                    case .oneMonth:
                        divison = 1
                        self.currentGraph.removeFromSuperlayer()
                    case .threeMonth:
                        divison = 1
                        self.currentGraph.removeFromSuperlayer()
                    case .sixMonth:
                        divison = 1
                        self.currentGraph.removeFromSuperlayer()
                    case .oneYear:
                        divison = 1
                        self.currentGraph.removeFromSuperlayer()
                    case .max:
                        divison = 1
                        self.currentGraph.removeFromSuperlayer()

                    
                }
                self.currentGraph = self.graphLayers[self.indexDetails.index(of: range)!]
                self.chart.drawGraph(divisons: divison, layerToDraw: self.graphLayers[self.indexDetails.index(of: range)!])

                print("Completed Loading Charts")
            }
        }
    }
    
    
    // MARK: Update Functions
    
    func updateDayStats(delay time: UInt32){
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            while true{
                
                if let jsonOpenClose = StockDetails.getOpenClose(forStockName: self.stock){
                
                
                    // Getting today's Date
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    dateFormatter.timeZone = TimeZone(abbreviation: "EST")
                    var currentDateString = dateFormatter.string(from: Date())
                    let endIndex = currentDateString.index(currentDateString.endIndex, offsetBy: -2)
                    currentDateString = currentDateString.substring(to: endIndex)
                    currentDateString = currentDateString.appending("00")
                    
                    // warning here
                    let open = jsonOpenClose[currentDateString]["1. open"].floatValue
                    let high = jsonOpenClose[currentDateString]["2. high"].floatValue
                    let low = jsonOpenClose[currentDateString]["3. low"].floatValue
                    let volume = jsonOpenClose[currentDateString]["5. volume"].stringValue
            
                    DispatchQueue.main.async {
            
                        self.openPrice.text = String(format: "%.2f", open)
                        self.highPrice.text = String(format: "%.2f", high)
                        self.lowPrice.text = String(format: "%.2f", low)
                        self.volume.text = volume
                    }
                }
                sleep(time)
            }
        }
        

    }
    
    
    func updateLongStats(delay time: UInt32){
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            while true{
                
                if let jsonDetails = StockDetails.getStockInfo(forStockName: self.stock){
                
                
                    let yearHigh = jsonDetails["YearHigh"].stringValue
                    let yearLow = jsonDetails["YearLow"].stringValue
                    let dividendYield = jsonDetails["DividendYield"].stringValue
                    let peRatio = jsonDetails["PERatio"].stringValue
                    let mrktCap = jsonDetails["MarketCapitalization"].stringValue
                    let avgVolume = jsonDetails["AverageDailyVolume"].stringValue
                    
                    DispatchQueue.main.async {

                        self.wkHigh.text = yearHigh
                        self.wkLow.text = yearLow
                        self.div.text = dividendYield
                        self.prRatio.text = peRatio
                        self.mktCap.text = mrktCap
                        self.avgVolume.text = avgVolume
                        self.newsTable.reloadData()
                    }
                }
                sleep(time)
            }
        }

    }
    
    
    // MARK: Update Tables
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let news = self.newsFeed{
            return news.items.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell
        if let news = self.newsFeed{
            print("\n\n\n\nnews table view\n\n\n\n")
            
            return cell.configureCell(newsFeed: news.items[indexPath.row])
        }
        
        return UITableViewCell()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    // Custom Delegates
    
    func chartMoved(currentPrice price: Float, currentDate date: Date) {
        self.priceChart.text = String(describing: price)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
        self.dateChart.text = dateFormatter.string(from: date)
        self.scrollView.isScrollEnabled = false
    }
    
    func chartStopped() {
        self.scrollView.isScrollEnabled = true
    }
    
    func changedIndex(selectedIndex index: Int) {
        self.updateChart(inRange: indexDetails[index])
    }
    
    

    


}

