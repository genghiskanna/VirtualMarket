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
    
    func configureStockCell(_ stockName: String, shares: String, price: Float){
        
        self.stockName.text = stockName
        self.numberOfShares.text = shares
        if let stockTemp = getStockPrice(forStockName: stockName){
            print(stockTemp)
            self.stockButton.setTitle(stockTemp.quote.price, for: .normal)
            if stockTemp.quote.change.contains("-"){
                self.stockButton.backgroundColor = Colors.materialRed
            } else {
                self.stockButton.backgroundColor = Colors.materialGreen
            }
        }
        self.stockButton.layer.cornerRadius = 5.0
        
    }

}
