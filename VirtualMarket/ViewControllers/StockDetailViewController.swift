//
//  StockDetailViewController.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 16/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit
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
                
                let sPrice = jsonPrice["l"].stringValue
                let splitPrice = sPrice.components(separatedBy: ".")
                
                // Getting today's Date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss";
                var currentData = dateFormatter.string(from: Date())
                print(currentData.components(separatedBy: ":"))
                currentData = currentData
                
                
                
                StockNews.getNews(self.stock)
                DispatchQueue.main.async {
                    self.stockName.text = jsonPrice["t"].stringValue
                    print(self.stockName.text!)
                    self.price.text = splitPrice.first
                    self.priceFloat.text = "." + splitPrice[1]
//                    self.openPrice.text =
                
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


extension Date {
    
    var zeroSeconds: Date? {
        get {
            let calender = Calendar.current
            let dateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute], from: self)
            return calender.date(from: dateComponents)
        }
    }
    
}
