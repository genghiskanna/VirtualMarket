//
//  HomeScreenViewController.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 02/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit
import CoreData
import FeedKit


var currentUrlForNews = "https://www.apple.com"



class HomeScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    // DATA
    fileprivate var currentMeasure = 0
    fileprivate var pendingOrder = Array<Stock>()
    fileprivate var smallGraphLayers = Array<CAGradientLayer>()
    fileprivate var newsFeed:Array<RSSFeedItem> = []
    fileprivate var currencies = ["EUR","AUD","CHF","JPY","QAR","GBP"]
    fileprivate var currencyValues = [Float]()
    fileprivate var smallForexGraphLayers = Array<CAGradientLayer>()
    
    //Empty indicator lables
    @IBOutlet weak var pendingOrderEmpty: UILabel!
    
    @IBOutlet weak var portfolioEmpty: UILabel!
    
    @IBOutlet weak var baseScrollView: UIScrollView!
    
    @IBOutlet weak var stockTableView: UITableView!
    @IBOutlet weak var newsTableView: UITableView!
    
    @IBOutlet weak var orderCollections: UICollectionView!
    @IBOutlet weak var mostCollection: UICollectionView!
    
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var navBar: CustomNavigationBar!
    
    
    @IBOutlet weak var baseView: UIView!
    //Private var
    private var stocksUnderWatch = Array<Stock>()
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var newsTableViewHeight: NSLayoutConstraint!
    // Constraints
    @IBOutlet weak var baseViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.stockTableView.rowHeight = 70.0
        self.stockTableView.delegate = self
        self.stockTableView.dataSource = self
        self.stockTableView.isScrollEnabled = false
        
        self.newsTableView.rowHeight = 150.0
        self.newsTableView.delegate = self
        self.newsTableView.dataSource = self
        self.newsTableView.isScrollEnabled = false
        
        self.mostCollection.backgroundColor = CurrentSettings.getTheme()["light"]
        
        self.mostCollection.dataSource = self
        self.mostCollection.delegate = self
        self.mostCollection.alwaysBounceVertical = true
        
        
        self.orderCollections.backgroundColor = CurrentSettings.getTheme()["light"]
        self.orderCollections.layer.cornerRadius = 30.0
        
        self.maskView.backgroundColor = CurrentSettings.getTheme()["light"]
        if AppDelegate.darkMode{
            self.navigationItem.rightBarButtonItem?.setBackButtonBackgroundImage(UIImage(named: "searchHomeLight"), for: .normal, barMetrics: .default)
            self.navigationItem.leftBarButtonItem?.setBackButtonBackgroundImage(UIImage(named: "account"), for: .normal, barMetrics: .default)
        }
        
    }
    
    @objc func updatePendingOrder(){
        if let pendingTemp = allPendingOrders(buy: true){
            pendingOrder = pendingTemp
        }
        
        
    }
    
    @objc func updateStocks(delay time: UInt32){
        DispatchQueue.global(qos: .background).async {
            while true{
                sleep(time)
                if let temp = allGroupedStocksUnderWatch(){
                    self.stocksUnderWatch = temp
                }
                self.stockTableView.reloadData()
            }
        }
    }
  
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
//        DispatchQueue.global(qos: .userInteractive).sync {
        
        
//            DispatchQueue.global(qos: .userInteractive).async {
            
                if let temp = stockNews(){
                    if let temp2 = temp.items{
                        self.newsFeed = temp2
                    }
                }
//            }
            
//            DispatchQueue.global(qos: .userInteractive).async {
                if let temp = allGroupedStocksUnderWatch(){
                    self.stocksUnderWatch = temp
                }
//            }
//            DispatchQueue.global(qos: .userInteractive).async {
                if self.smallForexGraphLayers.count != self.currencies.count{
                    var currencyQuery = ""
                    for curr in self.currencies{
                        currencyQuery += ("USD"+curr+",")
                        self.smallForexGraphLayers.append(drawSmallGraph(stockOrCurrencyName: curr,isCurrency: true))
                    }
                    //remove the last comma
                    currencyQuery.popLast()
                    self.currencyValues = ForexDetails.getForexPrice(currency: currencyQuery)
                }
//            }
        
//        }
//        DispatchQueue.global(qos: .userInteractive).sync {
        
            self.tableViewHeight.constant = CGFloat(70*stocksUnderWatch.count)
            self.newsTableViewHeight.constant = CGFloat(100*(newsFeed.count+1))
            print(self.newsTableViewHeight.constant)
            self.baseScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.baseScrollView.frame.height+CGFloat(70*stocksUnderWatch.count)+CGFloat(100*(newsFeed.count+1)))
            self.baseViewHeight.constant = self.baseScrollView.frame.height+CGFloat(70*stocksUnderWatch.count)+CGFloat(100*(newsFeed.count+1))
            

            setLabelColor()
            setEmptyIndicator()
            updatePendingOrder()
            self.view.backgroundColor = CurrentSettings.getTheme()["lightBase"]
            

            // WARNING to change to show absolute price as well as percentage
            
            
            updateStocks(delay: 60)
            
            
            // update small graph
            if smallGraphLayers.count != stocksUnderWatch.count{
                for stock in stocksUnderWatch{
                    smallGraphLayers.append(drawSmallGraph(stockOrCurrencyName: stock.name!, isCurrency: false))
                }
            }
        
//        }
        
        self.stockTableView.reloadData()
        self.newsTableView.reloadData()
     }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if AppDelegate.darkMode{
            return .lightContent
            
        } else {
            return .default
            
        }
    }
    
    
    
    
    // MARK: UIDesign
    
    @objc func setLabelColor(){
        var color = Colors.dark
        if AppDelegate.darkMode{
            color = Colors.light
        }
        
        
        
        
        self.portfolioEmpty.textColor = color
        self.pendingOrderEmpty.textColor = color
        
    }
    
    
    @objc func setEmptyIndicator(){
        if let stocks = allStocksUnderWatch(){
            if stocks.count == 0{
                
                self.portfolioEmpty.isHidden = false
            } else {
                
                self.portfolioEmpty.isHidden = true
            }
        }
        let ordersS = allPendingOrders(buy:true)
        if ordersS == nil{
                self.pendingOrderEmpty.isHidden = true
            } else {
                self.pendingOrderEmpty.isHidden = false
            }
        
    }
    
    
    // MARK: UITableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let stocks = allGroupedStocksUnderWatch() {
            if stocks.count == 0{
                tableView.isHidden = true
                return 0
            } else {
                tableView.isHidden = false
                if tableView == stockTableView{
                    return stocks.count
                } else {
                    print("ishk")
                    print(newsFeed.count)
                    return newsFeed.count
                }
            }
        }
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == stockTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath) as! StockTableViewCell
            if stocksUnderWatch.count != 0{
                let stock = stocksUnderWatch[indexPath.row]
                let graphLayer = smallGraphLayers[indexPath.row]
                if stock.status! == "following"{
                    cell.configureStockCell(stock.name!, shares: "Following",currentMeasure: currentMeasure,graphLayer: graphLayer)
                } else {
                    cell.configureStockCell(stock.name!, shares: ("\(getGroupedStockQuantity(stockName: stock.name!)) SHARES"),currentMeasure: currentMeasure,graphLayer: graphLayer)
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsHomeScreenTableViewCell
            if newsFeed.count != 0{
                cell.configureCell(newsFeed[indexPath.row],publisher: "Motley Fool")
                cell.layer.backgroundColor = Colors.light.cgColor
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! StockTableViewCell
        
        stockNameG = cell.stockName.text!
        performSegue(withIdentifier: "homeSegue", sender: self)
        
        
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if tableView == stockTableView{
            let cell = tableView.cellForRow(at: indexPath) as! StockTableViewCell
            cell.isSelected = false
            cell.isHighlighted = false
        }
        
    }
    
    
    
   
    // MARK: UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == orderCollections{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "orderCollection", for: indexPath) as! OrderCollectionViewCell
        
            if pendingOrder[indexPath.row].status!.contains("ell"){
                cell.configureCell(stockName: pendingOrder[indexPath.row].name!, orderType: pendingOrder[indexPath.row].orderType!,buyOrSell: "S")
            } else {
                cell.configureCell(stockName: pendingOrder[indexPath.row].name!, orderType: pendingOrder[indexPath.row].orderType!,buyOrSell: "B")
            }
        
            cell.layer.cornerRadius = 30.0
            cell.backgroundColor = Colors.materialGreen
        
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topGainerStockCell", for: indexPath) as! ForexCollectionViewCell
            print(currencies)
            print(currencyValues)
            print(smallForexGraphLayers.count)
            print("allegra")
            cell.configureCell(currencies[indexPath.row], currencyPrice: String(currencyValues[indexPath.row]), graphLayer: smallForexGraphLayers[indexPath.row])
            
            
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == orderCollections {
            return pendingOrder.count
        } else {
            return 0
        }
        
    }
    
    
    
    //IBAction
    
    
    @IBAction func changeMeasure(_ sender: Any) {
        if currentMeasure != 2{
            currentMeasure+=1
        } else {
            currentMeasure = 0
        }
        
        self.stockTableView.reloadData()
    }
}


