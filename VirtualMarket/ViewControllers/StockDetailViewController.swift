//
//  StockDetailViewController.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 16/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit

class StockDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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

        self.newsTable.dataSource = self
        self.newsTable.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    


}
