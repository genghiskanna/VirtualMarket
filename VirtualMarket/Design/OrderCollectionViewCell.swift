//
//  OrderCollectionViewCell.swift
//  
//
//  Created by Nishaanth Kanna Ravichandran on 26/08/17.
//
//

import UIKit

class OrderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var orderType: UILabel!
    
    @objc func configureCell(stockName name:String, orderType type:String,buyOrSell:String){
        self.stockName.text = name
        self.orderType.text = type + " \(buyOrSell)"
        
        self.stockName.textColor = Colors.light
        self.orderType.textColor = Colors.light
        self.orderType.textColor = Colors.light

    }
    
}
