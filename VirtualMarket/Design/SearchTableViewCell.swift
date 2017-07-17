//
//  SearchTableViewCell.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 04/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var stockCompany: UILabel!
    @IBOutlet weak var stockMarket: UILabel!
    
    func configureCell(_ stock: Dictionary<String,Any> , market: String) -> UITableViewCell{
        
        self.stockName.text = stock["Symbol"] as! String
        self.stockCompany.text = stock["Name"] as! String
        self.stockMarket.text = market
        
        if CurrentSettings.getTheme()["light"] == Colors.dark{
            self.backgroundColor = Colors.dark
            self.stockName.textColor = Colors.light
            self.stockMarket.textColor = Colors.light.withAlphaComponent(0.45)
            self.stockCompany.textColor = Colors.light.withAlphaComponent(0.45)
        } else {
            self.backgroundColor = Colors.light
            self.stockName.textColor = Colors.dark
            self.stockMarket.textColor = Colors.dark.withAlphaComponent(0.45)
            self.stockCompany.textColor = Colors.dark.withAlphaComponent(0.45)
        }
        
        return self as! UITableViewCell
    }

}
