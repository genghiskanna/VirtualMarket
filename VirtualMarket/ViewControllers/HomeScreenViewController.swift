//
//  HomeScreenViewController.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 02/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit
import CoreData

class HomeScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    // Labels
    @IBOutlet weak var netWorthLabel: UILabel!
    @IBOutlet weak var netWorth: UILabel!
    @IBOutlet weak var netWorthCent: UILabel!
    @IBOutlet weak var change: UILabel!
    //Empty indicator lables
    @IBOutlet weak var pendingOrderEmpty: UILabel!
    @IBOutlet weak var newsEmpty: UILabel!
    @IBOutlet weak var portfolioEmpty: UILabel!
    
    
    @IBOutlet weak var orderScrollView: UIScrollView!
    @IBOutlet weak var newsScrollView: UIScrollView!
    @IBOutlet weak var stockTableView: UITableView!
    
    
    @IBOutlet weak var segmentedControl2: SegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.stockTableView.rowHeight = 70.0
        self.stockTableView.delegate = self
        self.stockTableView.dataSource = self
        
        
        

        
        
    }
    
    func updateStocks(){
        DispatchQueue.global(qos: .userInitiated).async {
            while true{
                sleep(60)
                
                self.stockTableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLabelColor()
        setEmptyIndicator()
        
        self.view.backgroundColor = CurrentSettings.getTheme()["light"]
        
        let netWorth = String(describing: getPortfolioValue())
        let sPrice = netWorth.components(separatedBy: ".")
        
        self.netWorth.text = sPrice.first
        self.netWorthCent.text = "." + sPrice[1]
        
        // WARNING to change to show absolute price as well as percentage
        self.change.text = String(describing: getROI())
        updateStocks()
     }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if CurrentSettings.getStatusBar() == "dark"{
            return .default
            
        } else {
            return .lightContent
            
        }
    }
    
    
    
    
    // UIDesign
    
    func setLabelColor(){
        var color = Colors.dark
        if AppDelegate.darkMode{
            color = Colors.light
            
        }
        
        self.netWorthLabel.textColor = color
        self.netWorth.textColor = color
        self.netWorthCent.textColor = color
        self.change.textColor = Colors.materialGreen
    }
    
    func setEmptyIndicator(){
        if let stocks = allStocksUnderWatch(){
            if stocks.count == 0{
                self.pendingOrderEmpty.isHidden = false
                self.newsEmpty.isHidden = false
                self.portfolioEmpty.isHidden = false
            } else {
                self.pendingOrderEmpty.isHidden = true
                self.newsEmpty.isHidden = true
                self.portfolioEmpty.isHidden = true
            }
        }
    }
    
    
    // MARK Uitableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let stocks = allStocksUnderWatch() {
            if stocks.count == 0{
                tableView.isHidden = true
                return 0
            } else {
                tableView.isHidden = false
                return stocks.count
            }
        }
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath) as! StockTableViewCell
        if let stocks = allStocksUnderWatch(){
        let stock = stocks[indexPath.row]
            print(stocks.count)
            print(stock.status!)
            if stock.status! == "following"{
                cell.configureStockCell(stock.name!, shares: "Following", price: 123.0)
            } else {
                cell.configureStockCell(stock.name!, shares: "12", price: 123.0)
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! StockTableViewCell
        
        stockNameG = cell.stockName.text!
        performSegue(withIdentifier: "homeSegue", sender: self)
        
        
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! StockTableViewCell
        cell.isSelected = false
        cell.isHighlighted = false
        
    }
    
    
    
}


