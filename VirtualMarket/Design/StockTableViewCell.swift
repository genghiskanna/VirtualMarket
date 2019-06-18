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
    @IBOutlet weak var stockCompanyName: UILabel!
    @IBOutlet weak var numberOfShares: UILabel!
    @IBOutlet weak var stockButton: UIButton!
    
    @IBOutlet weak var graph: UIView!
    
    
    // 0:Price 1:Change 2:MarketCap
    
    @objc func configureStockCell(_ stockName: String, shares: String,currentMeasure:Int,graphLayer:CAGradientLayer){
        
        self.stockName.text = stockName
        self.numberOfShares.text = shares
        self.layer.backgroundColor = Colors.light.cgColor
        self.graph.layer.backgroundColor = Colors.light.cgColor
        self.graph.layer.addSublayer(graphLayer)
        if let stockTemp = StockDetails.getStockPrice(stockName: stockName){
            self.stockCompanyName.text = stockTemp.companyName
            switch currentMeasure {
            case 0:
                self.stockButton.setTitle(stockTemp.quote.price, for: .normal)
                break
                
            case 1:
                self.stockButton.setTitle(stockTemp.quote.change, for: .normal)
                break
                
            case 2:
                if let mrktCap = Int(stockTemp.quote.marketCap){
                    self.stockButton.setTitle(mrktCap.abbreviated, for: .normal)
                }
                break
                
            default:
                print("Error in StockTableViewCell")
            }
            
            
            if stockTemp.quote.change.contains("-"){
                self.stockButton.backgroundColor = Colors.materialRed
            } else {
                self.stockButton.backgroundColor = Colors.materialGreen
            }
        }
        self.stockButton.layer.cornerRadius = 5.0
        
    }
    

}
