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
    let pending = "pendingBuy"
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

public func allOrders(stockName: String) -> Array<Stock>{
    let order = "Market"
    let predicate1 = NSPredicate(format: "name == %@",stockName)
    let predicate2 = NSPredicate(format: "orderType != %@",order)
    
    let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1,predicate2])
    var stocks = [Stock]()
    
    do {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "Stock")
        request.predicate = compoundPredicate
        stocks = try context.fetch(request) as! Array<Stock>
    } catch {
        print("Error Fetching All Orders for \(stockName) From Core Data")
    }
    
    return stocks
}


public func allStocksUnderWatch() -> Array<Stock>? {
    var stocks: Array<Stock>?
    do {
        stocks = try context.fetch(Stock.fetchRequest())
        print(stocks)
        
    } catch {
        print("Error Fetching All Stocks")
    }
    
    return stocks
}

public func allGroupedStocksUnderWatch() -> Array<Stock>? {
    var tempStocks = [Stock]()
    var tempNames = [String]()
    do {
        if let stocks:[Stock] = try context.fetch(Stock.fetchRequest()){
            for stock in stocks{
                if !tempNames.contains(stock.name!){
                    tempNames.append(stock.name!)
                    tempStocks.append(stock)
                }
            }
        }
    } catch {
        print("Error Fetching All Stocks")
    }
    
    return tempStocks
}

public func getGroupedStockQuantity(stockName: String) -> Int64 {
    var stocks: Array<Stock>?
    var sum = Int64(0)
    do {
        stocks = try context.fetch(Stock.fetchRequest())
        for stock in stocks! {
            if stock.name!.contains(stockName){
                sum += stock.quantity
            }
        }
        
    } catch {
        print("Error Fetching All Stocks")
    }
    return sum
}

public func allStocksBought() -> Array<Stock>? {
    
    let bought = "bought"
    let predicate = NSPredicate(format: "status == %@",bought)
    var stocks = Array<Stock>()
    do {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "Stock")
        request.predicate = predicate
        stocks = try context.fetch(request) as! Array<Stock>
    } catch {
        print("Error Fetching  Bought Stocks From Core Data")
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



// Buying Power
public func getBuyingPower() -> Float {
    var users: Array<User>
    do {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        users = try context.fetch(request) as! Array<User>
        if users.count != 0{
            for user in users{
                if let name = user.name{
                    if name.contains("Jogendra"){
                        return user.tradingAccount
                    }
                }
            }
        }
    } catch {
        print("Error Fetching Data")
    }
    return -1.0
}

public func changeBuyingPower(value: Float) {
    var users: Array<User>
    do {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        users = try context.fetch(request) as! Array<User>
        if users.count != 0{
            for user in users{
                if let name = user.name{
                    if name.contains("Jogendra"){
                        user.tradingAccount += value
                    }
                }
            }
        }
        try context.save()
    } catch {
        print("Error Changing Buying Power")
    }
}



// Account
public func getAccountValue() -> Float {
    var users: Array<User>
    do {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        users = try context.fetch(request) as! Array<User>
        if users.count != 0{
            for user in users{
                if let name = user.name{
                    if name.contains("Jogendra"){
                        return user.account
                    }
                }
            }
        }
    } catch {
        print("Error Fetching Data")
    }
    return -1.0
}

public func changeAccountValue(value: Float) {
    var users: Array<User>
    do {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        users = try context.fetch(request) as! Array<User>
        if users.count != 0{
            for user in users{
                if let name = user.name{
                    if name.contains("Jogendra"){
                        user.account += value
                    }
                }
            }
        }
        
        try context.save()
    } catch {
        print("Error Changing Buying Power")
    }
}

// PortFolio Value
public func getTotalStockValue() -> Float {
    var sum = Float(0.0)
    if let stocks = allStocksBought(){
        for stock in stocks{
            StockDetails.getStockPriceUnderWatch()
            if let stockPrice = AppDelegate.stockData[stock.name!]?.quote.price{
                if let price = Float(stockPrice){
                    sum += price * Float(stock.quantity)
                }
            }
        }
    }
    
    return sum
}

// Order Updates
public func executeOrders(){
    var stocks: Array<Stock>
    do {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "Stock")

        stocks = try context.fetch(request) as! Array<Stock>
        if stocks.count != 0{
            for stock in stocks{
                if (stock.orderType != nil){
                    switch(stock.orderType!){
                        case "Limit":
                            if let sPrice = AppDelegate.stockData[stock.name!]?.quote.price{
                                if let price = Float(sPrice){
                                    if price <= stock.limitPrice{
                                        stock.status = "bought"
                                        stock.priceBought = price
                                        stock.worthBefore = getAccountValue() + getBuyingPower()
                                    }
                                }
                            }
                        case "Stop Loss":
                            if let sPrice = AppDelegate.stockData[stock.name!]?.quote.price{
                                if let price = Float(sPrice){
                                    if price >= stock.stopLoss{
                                        stock.status = "bought"
                                        stock.priceBought = price
                                        stock.worthBefore = getAccountValue() + getBuyingPower()
                                    }
                                }
                            }
                    
                        case "Stop Limit":
                            if let sPrice = AppDelegate.stockData[stock.name!]?.quote.price{
                                if let price = Float(sPrice){
                                    if price >= stock.stopLoss{
                                        stock.priceCrossedLimit = true
                                        stock.status = "bought"
                                        stock.priceBought = price
                                        stock.worthBefore = getAccountValue() + getBuyingPower()
                                    }
                                    
                                    if stock.priceCrossedLimit {
                                        if price <= stock.limitPrice {
                                            stock.status = "bought"
                                            stock.priceBought = price
                                            stock.worthBefore = getAccountValue() + getBuyingPower()
                                        }
                                    }
                                }
                            }
                        default:
                            print("Unexpected OrderType in executeOrder")
                    }
                }
            }
        }

        try context.save()
    } catch {
        print("Error Saving Context in ExecuteOrder")
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


// MARK Insert Functions

public func insertStock(_ stockName: String, orderType: String?, quantity: Int64?, priceBought:Float?, worthBefore: Float?, stopLoss:Float?, status: String) {
    
    
    let stock = Stock(context: context)
    // Deleting Following Stocks
    deleteStock(forStockName: stockName)
    if orderType != nil{
        stock.status = status
        switch orderType!{
            case "Market":
                stock.status = "bought"
                changeBuyingPower(value: -(Float(stock.quantity) * stock.priceBought))
                stock.dateBought = Date() as NSDate
            case "Limit":
                stock.limitPrice = priceBought!
            case "Stop Loss":
                stock.stopLoss = priceBought!
            case "Stop Limit":
                stock.limitPrice = priceBought!
                stock.stopLoss = stopLoss!
                stock.priceCrossedLimit = false
            default:
                print("Unexpected Switch Data Type")
        }
        stock.name = stockName
        stock.orderType = orderType!
        stock.quantity = quantity!
        stock.worthBefore = worthBefore!
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
    user.name = "Jogendra"
    do {
        try context.save()
    } catch  {
        print("Error in saving the user account")
    }
}
