//
//  StockTableViewCell.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 16/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit

class StockTableViewCell: UITableViewCell {

    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var numberOfShares: UILabel!
    @IBOutlet weak var stockButton: UIButton!
    
    func configureStockCell(stockName: String, shares: Int, price: Float){
        
        self.stockName.text = stockName
        self.numberOfShares.text = String(shares)
        self.stockButton.titleLabel?.text = String(price)
        self.stockButton.layer.cornerRadius = 5.0
        
    }

}
