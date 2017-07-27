//
//  StockDetailViewController.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 16/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit
import SwiftDate
import SwiftyJSON

class StockDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Data 
    open var stock: String!

    // label
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var priceFloat: UILabel!
    @IBOutlet weak var change: UILabel!
    
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
    
    
    // IBActions
    @IBAction func buyPressed(_ sender: Any) {
    }
    
    
    @IBAction func followPressed(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Constantly update
        
        self.newsTable.dataSource = self
        self.newsTable.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stock = stockNameG
        
        //Get StockDetails
        DispatchQueue.global(qos: .userInitiated).async {
            while true{
                
                let jsonPrice = StockDetails.getStockPrice(self.stock)
                let jsonOpenClose = StockDetails.getOpenClose(self.stock)
                let jsonDetails = StockDetails.getStockInfo(self.stock)
                
                
                let sPrice = jsonPrice["l"].stringValue
                let splitPrice = sPrice.components(separatedBy: ".")
                
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
                
                
                let yearHigh = jsonDetails["YearHigh"].stringValue
                let yearLow = jsonDetails["YearLow"].stringValue
                let dividendYield = jsonDetails["DividendYield"].stringValue
                let peRatio = jsonDetails["PERatio"].stringValue
                let mrktCap = jsonDetails["MarketCapitalization"].stringValue
                let avgVolume = jsonDetails["AverageDailyVolume"].stringValue
                
                
                StockNews.getNews(self.stock)
                DispatchQueue.main.async {
                    
                    self.stockName.text = jsonPrice["t"].stringValue
                    self.price.text = splitPrice.first
                    self.priceFloat.text = "." + splitPrice[1]
                    self.openPrice.text = String(format: "%.2f", open)
                    self.highPrice.text = String(format: "%.2f", high)
                    self.lowPrice.text = String(format: "%.2f", low)
                    self.volume.text = volume
                    self.wkHigh.text = yearHigh
                    self.wkLow.text = yearLow
                    self.div.text = dividendYield
                    self.prRatio.text = peRatio
                    self.mktCap.text = mrktCap
                    self.avgVolume.text = avgVolume
                
                }
                sleep(1)
            }
        }
        
        
        //Get News
       
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return StockTableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    


}

