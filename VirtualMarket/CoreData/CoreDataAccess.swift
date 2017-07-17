//
//  CoreDataAccess.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 16/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import CoreData
import UIKit


public func allPendingOrders() -> Array<Any>{
    
    return Array()
}

public func allStocksUnderWatch() -> Array<Any> {
    
    return Array()
}

public func specificStock(_ forStockName: String) -> Any {
    
    return 1
}

public func specificStock(_ forDate: Date) -> Any {
    
    return 1
}

public func getBuyingPower() -> Float {
    
    return 0.0
}

public func getPortfolioValue() -> Float {
    
    return 0.0
}

public func insertStock(_ stockName: String, orderType: String, quantity: Int64, priceBought:Float, worthBefore: Float, status: String) {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let stock = Stock(context: context)
    
    stock.name = stockName
    stock.orderType = orderType
    stock.quantity = quantity
    stock.priceBought = priceBought
    stock.worthBefore = worthBefore
    stock.status = status
    
    do {
        try context.save()
    } catch {
        print("Error Saving \(error.localizedDescription)")
    }
    
    
}
