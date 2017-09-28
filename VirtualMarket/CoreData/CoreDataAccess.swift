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


public func allPendingOrders(buy:Bool) -> Array<Stock>{
    let pending = buy ? "pendingBuy" : "pendingSell"
    let predicate = NSPredicate(format: "status == %@",pending)
    var stocks = Array<Stock>()
    do {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "Stock")
        request.predicate = predicate
        stocks = try context.fetch(request) as! Array<Stock>
    } catch {
        print("Error Fetching Pending Orders From Core Data")
    }
    return stocks
}


public func allStocksUnderWatch() -> Array<Stock>? {
    var stocks: Array<Stock>?
    do {
        stocks = try context.fetch(Stock.fetchRequest())
        
    } catch {
        print("Error Fetching All Stocks")
    }
    
    return stocks
}


public func getStockStatus(forStockName stockName:String) -> String?{
    let predicate = NSPredicate(format: "name == %@", stockName)
    var stocks: Array<Stock>
    var finalStatus = ""
    do {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "Stock")
        request.predicate = predicate
        
        stocks = try context.fetch(request) as! Array<Stock>
        if stocks.count != 0{
            for stock in stocks{
                print(stock.name!)
                print(stock.status!)
                print("Hola")
                if let status = stock.status{
                    return status
                }
            }
        }
    } catch {
        print("Error Fetching status for \(stockName)")
    }
    
    return finalStatus
}


public func isStockBought(forStockName stockName:String) -> Bool{
    let predicate = NSPredicate(format: "name == %@", stockName)
    var stocks: Array<Stock>
    do {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "Stock")
        request.predicate = predicate
        
        stocks = try context.fetch(request) as! Array<Stock>
        if stocks.count != 0{
            for stock in stocks{
                if let status = stock.status{
                    print(status)
                    if status.contains("bought"){
                        return true
                    }
                }
            }
        }
    } catch {
        print("Error Fetching status BuyOrSell for \(stockName)")
    }
    print("Gal Gadot")
    return false
}


public func specificStock(forStockName stockName: String) -> Any {
    
    return 1
}


public func specificStock(boughtDate forDate: Date) -> Any {
    
    return 1
}


public func getBuyingPower() -> Float {
    
    
    var user: Array<User>
    do {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        user = try context.fetch(request) as! Array<User>
        if user.count != 0{
            print("Hello")
            return user[0].tradingAccount
        }
    } catch {
        print("Error Fetching Data")
    }
    
    
    return 0.0
}

public func changeBuyingPower(value: Float) {
    var user: Array<User>
    do {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        user = try context.fetch(request) as! Array<User>
        if user.count != 0{
            print(user[0].tradingAccount)
            print(value)
            user[0].tradingAccount += value
        }
        
        try context.save()
    } catch {
        print("Error Changing Buying Power")
    }
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




// MARK Insert Functions

public func insertStock(_ stockName: String, orderType: String?, quantity: Int64?, priceBought:Float?, worthBefore: Float?, stopLoss:Float?, status: String) {
    
    
    let stock = Stock(context: context)
    // Deleting Following Stocks
    deleteStock(forStockName: stockName)
    if orderType != nil{
        stock.name = stockName
        stock.orderType = orderType!
        stock.quantity = quantity!
        // Price Bought
        stock.priceBought = priceBought!
        stock.worthBefore = worthBefore!
        stock.status = status
        
        if stopLoss != nil{
            stock.stopLoss = stopLoss!
        }
        
        if orderType!.contains("arket"){
            stock.status = "Bought"
            changeBuyingPower(value: -(Float(stock.quantity) * stock.priceBought))
        }
    } else {
        stock.name = stockName
        stock.status = status
    }
    
    do {
        try context.save()
        
    } catch {
        print("Error Saving \(error.localizedDescription) to Core Data")
    }
}




// MARK Delete Functions

public func deleteStock(forStockName stockName:String){
    let predicate = NSPredicate(format: "name == %@", stockName)
    var stocks: Array<Stock>
    do {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "Stock")
        request.predicate = predicate
        
        stocks = try context.fetch(request) as! Array<Stock>
        if stocks.count != 0{
            for stock in stocks{
                if let type = stock.status{
                    // Deleting stocks with status 'following' only because others shouldn't be removed
                    if type.contains("following"){
                        context.delete(stock)
                        try context.save()
                    }
                }
            }
        }
    } catch {
        print("Error Deleting \(stockName) from CoreData 'Following'")
    }
}




// MARK onetime functions

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
