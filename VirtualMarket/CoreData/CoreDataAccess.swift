//
//  CoreDataAccess.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 16/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import CoreData
import UIKit

let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

public func allPendingOrders() -> Array<Any>{
    var stocks = Array<Any>()
    var pendingStocks = Array<Any>()
    do {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "Stock")
        stocks = try context.fetch(request)
    } catch {
        print("Error Fetching Data")
    }
    
    for stock in stocks {
        let tempStock = stock as! NSManagedObject
        if String(describing: tempStock.value(forKey: "status")) == "pending" {
            pendingStocks.append(stock)
        }
    }
    
    return pendingStocks
}

public func allStocksUnderWatch() -> Array<Stock>? {
    var stocks: Array<Stock>?
    do {
//        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "Stock")
        stocks = try context.fetch(Stock.fetchRequest())
        for stock in stocks!{
            print(stock.name)
        }
    } catch {
        print("Error Fetching Data")
    }
    
    return stocks
}


public func getStockStatus(forStockName stockName:String) -> String?{
    let predicate = NSPredicate(format: "name == %@", stockName)
    var stocks: Array<Stock>
    do {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "Stock")
        request.predicate = predicate
        
        stocks = try context.fetch(request) as! Array<Stock>
        if stocks.count != 0{
            if let type = stocks[0].status{
                return type
            }
        }
    } catch {
        print("Error Fetching Data")
    }
    
    return nil
}


public func deleteStock(forStockName stockName:String){
    let predicate = NSPredicate(format: "name == %@", stockName)
    var stocks: Array<Stock>
    do {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "Stock")
        request.predicate = predicate
        
        stocks = try context.fetch(request) as! Array<Stock>
        if stocks.count != 0{
            if let type = stocks[0].status{
                if type.contains("following"){
                    context.delete(stocks[0])
                    try context.save()
                }
            }
        }
    } catch {
        print("Error Fetching Data")
    }
}



public func specificStock(forStockName stockName: String) -> Any {
    
    return 1
}

public func specificStock(boughtDate forDate: Date) -> Any {
    
    return 1
}

public func getBuyingPower() -> Float {
    
    return 0.0
}

public func getDarkUser(){
    var mode = false
//    do {
//        let user = try context.fetch(User.fetchRequest())[0] as User
//        if user.darkMode != nil {
//            mode = user.darkMode as! Bool
//        }
//        
//    } catch {
//        print("Error Fetching Data")
//    }
    AppDelegate.darkMode = mode
}

public func getROI() -> Float {
    
    let user = User(context: context)
    return user.rateOI
}

public func getPortfolioValue() -> Float {
    var account = Float(1.0)
    do {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let user = try context.fetch(request)[0] as! NSManagedObject
        account = user.value(forKey: "account") as! Float
    } catch {
        print("Error Fetching Data")
    }
    return account
}

public func insertStock(_ stockName: String, orderType: String?, quantity: Int64?, priceBought:Float?, worthBefore: Float?, status: String) {
    
    
    let stock = Stock(context: context)
    if orderType != nil{
        stock.name = stockName
        stock.orderType = orderType!
        stock.quantity = quantity!
        stock.priceBought = priceBought!
        stock.worthBefore = worthBefore!
        stock.status = status
    } else {
        stock.name = stockName
        stock.status = status
    }
    
    do {
        try context.save()
    } catch {
        print("Error Saving \(error.localizedDescription)")
    }
}



// onetime functions

public func createUser(){
    let user = User(context: context)
    user.account = Float(10000.00)
    user.rateOI = Float(0.0)
    user.darkMode = false
    user.tradingAccount = Float(0.0)
    do {
        try context.save()
    } catch  {
        print("Error in saving the user account")
    }
}
