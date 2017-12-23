//
//  RecentOrderTableViewCell.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 03/10/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit

class RecentOrderTableViewCell : UITableViewCell{
    @IBOutlet weak var orderType: UILabel!
    @IBOutlet weak var orderDescription: UILabel!
    @IBOutlet weak var orderProfitButton: UIButton!
    
    func configureCell(stock:Stock) -> UITableViewCell{
        print(stock)
        var status = "Placed"
        orderProfitButton.isHidden = true
        if (stock.status?.contains("bought"))! || (stock.status?.contains("sold"))!{
            status = "Successful"
            if (stock.status?.contains("sold"))!{
                orderProfitButton.setTitle(String(stock.overallProfit), for: .normal)
            }
        } else if (stock.status?.contains("cancelled"))!{
            status = "Cancelled"
            
        }
        
        orderType.text = "\(stock.orderType!) \(status)"
        
        switch stock.orderType! {
        case "Limit":
            orderDescription.text = "\(String(stock.quantity)) SHARES at Limit Price : \(String(stock.limitPrice))"
        case "Stop Loss":
            orderDescription.text = "\(String(stock.quantity)) SHARES at Stop Loss : \(String(stock.stopLoss))"
        case "Stop Limit":
            orderDescription.text = "\(String(stock.quantity)) SHARES at Stop Loss : \(String(stock.stopLoss)), Limit Price : \(String(stock.limitPrice))"
        default:
            print("Switch case error at RecentOrderTableViewCell")
        }
        
        return self as UITableViewCell
    }
}
