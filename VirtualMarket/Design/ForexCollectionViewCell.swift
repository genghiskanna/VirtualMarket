//
//  MostStockCollectionViewCell.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna on 17/02/19.
//  Copyright © 2019 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit

class ForexCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var stockPrice: UILabel!
    @IBOutlet weak var mktCap: UILabel!
    @IBOutlet weak var graph: UIView!
    func configureCell(_ currencyName: String,currencyPrice: String,graphLayer: CAGradientLayer){
        
        self.stockName.text = currencyName
        self.stockPrice.text = currencyPrice
        self.graph.layer.addSublayer(graphLayer)
    }
}
