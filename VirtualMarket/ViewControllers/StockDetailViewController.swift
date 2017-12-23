//
//  StockDetailViewController.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 16/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kanna

class StockDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ChartViewDelegate, SegmentedControl6Delegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    // Data 
    
    var stockNews: StockDataSource!
    @objc var stock: String!
    
    var indexDetails = [StockDetails.StockRange.oneDay, StockDetails.StockRange.oneWeek, StockDetails.StockRange.oneMonth,StockDetails.StockRange.threeMonth,StockDetails.StockRange.sixMonth,StockDetails.StockRange.oneYear,StockDetails.StockRange.max]
    @objc var graphLayers = [CAShapeLayer(),CAShapeLayer(),CAShapeLayer(),CAShapeLayer(),CAShapeLayer(),CAShapeLayer(),CAShapeLayer()]

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
    
    @IBOutlet weak var segmentControl: SegmentedControl6!
    @IBOutlet weak var chart: ChartView!
    
    
    // Recent Orders
    @IBOutlet weak var RecentOrderTableView: UITableView!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var orderHeightConstraint: NSLayoutConstraint!
    
    // REcent Orders DataSource
    @objc var orders = [Stock]()
    
    
    // current graph
   
    @objc var currentGraph = CAShapeLayer()
    
    // flags 
    @objc var firstFlag = true
    
    
    // IBActions
    @IBAction func buyPressed(_ sender: Any) {
        performSegue(withIdentifier: "buySegue", sender: self)
    }
    
    
    @IBAction func followPressed(_ sender: Any) {
        if self.stock != nil{
            if self.followButton.title(for: .normal) == "Follow"{
                insertStock(self.stock!, orderType: nil, quantity: nil, priceBought: nil, worthBefore: nil,stopLoss: nil, status: "following")
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
        self.RecentOrderTableView.dataSource = self
        self.RecentOrderTableView.delegate = self
        self.chart.delegate = self
        self.segmentControl.delegate = self
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stock = stockNameG
        orders = allOrders(stockName: stock)
        self.RecentOrderTableView.rowHeight = 60.0
        
        if let status = getStockStatus(forStockName: self.stock) {
            if status.contains("following"){
                self.followButton.setTitle("UnFollow", for: .normal)
            }
            else {
                let buySellTitle = isStockBought(forStockName: stockNameG) ? "Sell" : "Follow"
                self.followButton.setTitle(buySellTitle, for: .normal)
            }
        }
        
        
        stockNews = getNewsForStock(stockName: stock)
        
        // update Values
        updateStockPrice(delay: 60)
        updateDayStats(delay: 120)
        updateLongStats()
        updateChart(inRange: .oneDay)
    }
    
    
    @objc func updateStockPrice(delay time: UInt32){
        // updating fast
        DispatchQueue.global(qos: .userInitiated).async {
            
            while true{
                if let stockTemp = StockDetails.getStockPrice(stockName: self.stock) {
                    print("123")
                    if let sPrice = stockTemp.quote.price{
                        print("1232")
                        print(stockTemp)
                        print(StockDetails.getStockPrice(stockName: self.stock))
                        if sPrice.characters.count != 0 {
                            print("1234")
                            let splitPrice = sPrice.components(separatedBy: ".")
                            DispatchQueue.main.async {
                                
                                self.stockName.text = stockTemp.name
                                self.price.text = splitPrice.first
                                
                                if stockTemp.quote.change.contains("+"){
                                    self.change.textColor = Colors.materialGreen
                                } else {
                                    self.change.textColor = Colors.materialRed
                                }
                                self.change.text = stockTemp.quote.change
                                // fatal error: Index out of range occure
                                print(splitPrice)
                                self.priceFloat.text = "." + splitPrice[1]
                                
                            }
                        }
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
                prices = prices.reversed()
                dates = dates.reversed()
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
    
    @objc func updateDayStats(delay time: UInt32){
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            while true{
                
                if let jsonOpenClose = StockDetails.getOpenClose(forStockName: self.stock){
                
                
                    // Getting today's Date
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    dateFormatter.timeZone = TimeZone(abbreviation: "EST")
                    
                    var currentDate = Date()
                    
                    // subtracting 10 minutes for added delay
                    currentDate = currentDate.addingTimeInterval(-60*10)
                    
                    var currentDateString = dateFormatter.string(from: currentDate)
                    let endIndex = currentDateString.index(currentDateString.endIndex, offsetBy: -2)
                    currentDateString = currentDateString.substring(to: endIndex)
                    currentDateString = currentDateString.appending("00")
                    print(currentDateString)
                    
                    // warning here
                    let open = jsonOpenClose[currentDateString]["1. open"].floatValue
                    let high = jsonOpenClose[currentDateString]["2. high"].floatValue
                    let low = jsonOpenClose[currentDateString]["3. low"].floatValue
                    let volume = jsonOpenClose[currentDateString]["5. volume"].intValue
            
                    DispatchQueue.main.async {
            
                        self.openPrice.text = String(format: "%.2f", open)
                        self.highPrice.text = String(format: "%.2f", high)
                        self.lowPrice.text = String(format: "%.2f", low)
                        self.volume.text = volume.abbreviated
                    }
                } else {
                    print("Open Close Date Problem")
                }
                sleep(time)
            }
        }
        

    }
    
    
    @objc func updateLongStats(){
        
        if let stockTemp = StockDetails.getStockPrice(stockName: stock){
    
            self.wkHigh.text = stockTemp.quote.wkHigh
            self.wkLow.text = stockTemp.quote.wkLow
            self.div.text = stockTemp.quote.div
            self.prRatio.text = stockTemp.quote.peRatio
            if let avgVolumeI = Int(stockTemp.quote.avgVolume){
                self.avgVolume.text = avgVolumeI.abbreviated
            }
        
            if let mrktCap = Int(stockTemp.quote.marketCap){
                self.mktCap.text = mrktCap.abbreviated
            }
            
            self.newsTable.reloadData()
        }
    }
    
    
    // MARK: Update Tables
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == newsTable{
            return stockNews.news.count
        } else {
            return orders.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == newsTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell
        
            return cell.configureCell(title: stockNews.news[indexPath.row].title, source: stockNews.news[indexPath.row].source)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! RecentOrderTableViewCell
            
            return cell.configureCell(stock: orders[indexPath.row])
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    // Custom Delegates
    
    @objc func chartMoved(currentPrice price: Float, currentDate date: Date) {
        self.priceChart.text = String(describing: price)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
        self.dateChart.text = dateFormatter.string(from: date)
        self.scrollView.isScrollEnabled = false
    }
    
    @objc func chartStopped() {
        self.scrollView.isScrollEnabled = true
    }
    
    @objc func changedIndex(selectedIndex index: Int) {
        self.updateChart(inRange: indexDetails[index])
    }
    
    //MARK segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segues")
        if segue.identifier == "buySegue"{
            
            let vc = segue.destination as! BuySellViewController
            

            vc.price = self.price.text! + self.priceFloat.text!
            
                
            
        }
    }

    
    

    


}

