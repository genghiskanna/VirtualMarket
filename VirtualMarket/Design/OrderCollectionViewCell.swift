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
    
    func configureCell(stockName name:String, orderType type:String){
        self.stockName.text = name
        self.orderType.text = type
        
        self.stockName.textColor = Colors.light
        self.orderType.textColor = Colors.light

    }
    
}
