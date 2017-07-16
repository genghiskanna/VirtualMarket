//
//  ReportStockTableViewCell.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 16/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit

class ReportStockTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var descriptionStock: UILabel!
    @IBOutlet weak var worthBTLabel: UILabel!
    @IBOutlet weak var worthATLabel: UILabel!
    @IBOutlet weak var change: UILabel!
    
    
    
    func configureCell(stockName: String, description: String, worthBT: Float, worthAT:Float, change: Float){
        
        self.stockName.text = stockName
        self.descriptionStock.text = description
        self.worthBTLabel.text = String(worthBT)
        self.worthATLabel.text = String(worthAT)
        self.change.text = String(change)
        
        
    }

}
