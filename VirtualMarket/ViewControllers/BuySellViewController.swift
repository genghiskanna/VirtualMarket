//
//  BuySellViewController.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 16/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit
import M13Checkbox
import TextFieldEffects
import IHKeyboardAvoiding
import SCLAlertView

class BuySellViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    //DATA
    struct StockData{
        var stockName: String!
        var orderType: String!
        var price: Float!
        var quantity: Int!
        var stopLoss: Float!
        var validity: String!
    }
    
    var currentStock = StockData()
    
    public var price = String()
    
    @IBOutlet weak var optionalViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeCurrent: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var orderPickerView: UIPickerView!
    @IBOutlet weak var orderDescription: UILabel!
    
    // Quantity
    @IBOutlet weak var numberOfShares: AkiraTextField!
    @IBOutlet weak var totalAmount: UILabel!
    
    // Validity
    @IBOutlet weak var today: M13Checkbox!
    @IBOutlet weak var untilCancelled: M13Checkbox!
    
    //Optional
    @IBOutlet weak var optionalView: SmallFloatingView!
    @IBOutlet weak var priceTitle: UILabel!
    @IBOutlet weak var priceDescription: UILabel!
    @IBOutlet weak var priceInput: YokoTextField!
    @IBOutlet weak var stopLimitInput: HoshiTextField!
    
    // Extras
    @IBOutlet weak var placeOrder: ButtonOrder!
    @IBOutlet weak var orderTitle: UILabel!
    
    
    @IBAction func orderPressed(_ sender: Any) {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "CircularAirPro", size: 20)!,
            kTextFont: UIFont(name: "CircularAirPro", size: 14)!,
            kButtonFont: UIFont(name: "CircularAirPro-Book", size: 14)!,
            showCloseButton: false,
            showCircularIcon: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        let alertWrongView = SCLAlertView(appearance: appearance)
        if currentStock.quantity != nil{
            if Float(self.currentStock.price) * Float(self.currentStock.quantity) < getBuyingPower(){
                alertView.addButton("Cancel Order", backgroundColor: Colors.materialRed, textColor: Colors.light, showDurationStatus: false, action: {})
                
                alertView.addButton("Confirm Order", backgroundColor: Colors.materialGreen, textColor: Colors.light, showDurationStatus: true, action: {
                    if self.checkOrderValidity(){
                        insertStock(self.currentStock.stockName, orderType: self.currentStock.orderType, quantity: Int64(self.currentStock.quantity), priceBought: Float(self.currentStock.price), worthBefore: getBuyingPower(), stopLoss: self.currentStock.stopLoss, status: "pendingBuy")
                    } else {
                        alertWrongView.addButton("I'll Check", backgroundColor: Colors.teal, textColor: Colors.light, showDurationStatus: false, action: {})
                        _ = alertWrongView.showCustom("Wrong Price", subTitle: "You might have given wrong combination of price.Check Help to Know More.", color: Colors.teal, icon: UIImage())
                    }
                })
                var subTitle = ""
                switch currentStock.orderType {
                    
                    case "Market":
            
                            subTitle = "\(currentStock.quantity!) Shares of \((currentStock.stockName)!) at \(currentStock.price!). \(currentStock.orderType!)"
                       
                        break
                    
                    case "Limit":
                        
                            // error force unwrap alternative
                            subTitle = "\(currentStock.quantity!) Shares of \((currentStock.stockName)!) at \(currentStock.price!) . valid \(currentStock.validity!). Limit Price at \(currentStock.price!)"
                        
                        break
                    
                    case "Stop Loss":
                        
                        subTitle = "\(currentStock.quantity!) Shares of \((currentStock.stockName)!) at \(currentStock.price!) . valid \(currentStock.validity!). Stop Loss at \(currentStock.stopLoss!)"
                        
                        break
                    
                    case "Stop Limit":
                        
                        subTitle = "\(currentStock.quantity!) Shares of \((currentStock.stockName)!) at \(currentStock.price!) . valid \(currentStock.validity!).Stop Loss is set at \(currentStock.stopLoss!) and Limit Price at \(currentStock.price!)"
                        
                        break
                    
                    default:
                        print("Wrong Choice in \\_('^')_//")
                    }
                
                _ = alertView.showCustom("Confirm Order", subTitle: subTitle, color: Colors.teal, icon: UIImage())
            
            } else {
                
                alertView.addButton("Ok", backgroundColor: Colors.teal, textColor: Colors.light, showDurationStatus: false, action: {})
                
                _ = alertView.showCustom("Insufficient Funds", subTitle: "You have Insufficient Funds to Buy this Stock. Consider reducing the quantity, transfer funds to your virtual trading account or buying more virtual money in the market.", color: Colors.teal, icon: UIImage())
            }
            
        } else {
        
            alertView.addButton("Ok", backgroundColor: Colors.teal, textColor: Colors.light, showDurationStatus: false, action: {})
        
            var subTitle = ""
        
            switch currentStock.orderType {
        
                case "Market":
        
                    subTitle = "Quantity Field Should Not Be Empty"
        
                break
        
                case "Limit":
        
                    subTitle = "Quantity and Limit Price Field Should Not Be Empty"
        
                break
        
                case "Stop Loss":
        
                    subTitle = "Quantity and Stop Loss Field Should Not Be Empty"
        
                break
        
                case "Stop Limit":
        
                    subTitle = "Quantity, Stop Loss and Stop Limit Field Should Not Be Empty"
        
                break
        
                default:
                    print("Wrong Choice in ??^-^??")
            }
        
            _ = alertView.showCustom("Empty Fields", subTitle: subTitle, color: Colors.teal, icon: UIImage())
        }
    }
    
    
    var data = ["Market","Limit","Stop Loss","Stop Limit"]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.orderPickerView.dataSource = self
        self.orderPickerView.delegate = self
        
        KeyboardAvoiding.avoidingView = self.view
    
        
        
        initUI()
        initTextFields()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = Colors.teal
        self.optionalViewHeightConstraint.constant  = 0.0
        self.optionalView.isHidden = true
        self.closeCurrent.setTitle(stockNameG, for: .normal)
        self.currentPrice.text = price
        self.currentStock.stockName = stockNameG
        
        self.currentStock.orderType = "Market"
        
        
        
    }
    
    // MARK utility
    
    func initUI(){
        self.today.toggleCheckState()
        self.today.stateChangeAnimation = .expand(.fill)
        self.untilCancelled.stateChangeAnimation = .expand(.fill)
        self.today.addTarget(self, action: #selector(markChanged(_:)), for: .allEvents)
        self.untilCancelled.addTarget(self, action: #selector(markChanged(_:)), for: .allEvents)
    }
    
    
    func initTextFields(){
        // TextField Initialization
        self.numberOfShares.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.priceInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.stopLimitInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        
        KeyboardAvoiding.padding = 10.0
        
        
        
        
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolBar.setItems([done], animated: true)
        
        self.numberOfShares.inputAccessoryView = toolBar
        self.priceInput.inputAccessoryView = toolBar
        self.stopLimitInput.inputAccessoryView = toolBar
        
        
        
    }
    
    func changeView(order orderType:String){
        switch orderType {
            
            case "Market":
                UIView.animate(withDuration: 0.3, animations: {
                    self.optionalViewHeightConstraint.constant  = 0.0
                    self.optionalView.isHidden = true
                    self.view.layoutIfNeeded()
                })
                
            break
            
            case "Limit":
                UIView.animate(withDuration: 0.3, animations: {
                    self.optionalViewHeightConstraint.constant  = 160.0
                    self.optionalView.isHidden = false
                    self.view.layoutIfNeeded()
                })
                
                self.priceTitle.text = "Limit Price"
                self.priceDescription.text = "Enter the Limit Price"
                self.priceInput.placeholder = "Limit Price"
                self.stopLimitInput.isHidden = true
            break
            
            case "Stop Loss":
                UIView.animate(withDuration: 0.3, animations: {
                    self.optionalViewHeightConstraint.constant  = 160.0
                    self.optionalView.isHidden = false
                })
                self.priceTitle.text = "Stop Loss"
                self.priceDescription.text = "Enter the Stop Loss"
                self.priceInput.placeholder = "Stop Loss"
                self.stopLimitInput.isHidden = true
            break
            
            case "Stop Limit":
                UIView.animate(withDuration: 0.3, animations: {
                    self.optionalViewHeightConstraint.constant  = 160.0
                    self.optionalView.isHidden = false
                    self.view.layoutIfNeeded()
                })
                self.priceTitle.text = "Stop Limit"
                self.priceDescription.text = "Enter the Limit Price and Stop Loss"
                self.priceInput.placeholder = "Limit Price"
                self.stopLimitInput.placeholder = "Stop Loss"
                UIView.animate(withDuration: 0.3, animations: {
                    self.stopLimitInput.isHidden = false
                    self.view.layoutIfNeeded()
                })
            break
            
            default:
                print("Wrong Choice in changeView")
        }
    }
    
    func markChanged(_ checkbox:M13Checkbox){
        print("In")
        if checkbox == today{
            if checkbox.checkState == .checked{
                untilCancelled.checkState = .unchecked
                currentStock.validity = "Today"
            }
        } else {
            if checkbox.checkState == .checked{
                today.checkState = .unchecked
                currentStock.validity = "Until Cancelled"
            }
        }
    }
    
    func donePressed(){
        self.view.endEditing(true)
    }
    
    
    // MARK PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.orderTitle.text = data[row] + " Order"
        
        currentStock.orderType = data[row]

        changeView(order:data[row])
    }
    
    // MARK TextField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.scrollView.isScrollEnabled = false
        
        if textField == self.numberOfShares{
            KeyboardAvoiding.setAvoidingView(self.view, withTriggerView: self.totalAmount)
        } else {
            KeyboardAvoiding.setAvoidingView(self.view, withTriggerView: textField)
        }
    }
    
    func textFieldDidChange(_ textField: UITextField){
        
        if textField == numberOfShares && numberOfShares.text?.characters.count != 0{
            switch currentStock.orderType {
            // error occurred "fatal error: unexpectedly found nil while unwrapping an Optional value"
                
                case "Market":
                    if let amount = self.numberOfShares.text{
                        if let amountFloat = Float(amount),let priceFloat = Float(price){
                            self.totalAmount.text = String(describing: (amountFloat * priceFloat))
                            currentStock.price = priceFloat
                            currentStock.quantity = Int(amountFloat)
                        }
                    }
                    break
                
                case "Limit":
                    if let limitPrice = self.priceInput.text, let amount = self.numberOfShares.text{
                        if let limitPriceFloat = Float(limitPrice), let amountFloat = Float(amount),let priceFloat=Float(price){
                            if limitPriceFloat < priceFloat{
                                self.totalAmount.text = String(describing: (amountFloat * limitPriceFloat))
                                currentStock.price = limitPriceFloat
                                currentStock.quantity = Int(amountFloat)
                                print(currentStock.price)
                                print("Et tue Brute")
                            }
                        }
                    }
                    break
                
                case "Stop Loss":
                    
                    // when current price reaches stop loss (buy) the order is executed
                    if let stopLoss = self.priceInput.text, let amount = self.numberOfShares.text{
                        if let stopLossFloat = Float(stopLoss), let amountFloat = Float(amount), let priceFloat = Float(price){
                            if stopLossFloat < priceFloat{
                                self.totalAmount.text = String(describing: (amountFloat * stopLossFloat))
                                currentStock.price = stopLossFloat
                                currentStock.quantity = Int(amountFloat)
                            }
                        }
                    }
                    break
                
                case "Stop Limit":
                    
                    // when current price reaches stop loss (buy) and again reaches the limit price it sells
                    if let stopLoss = self.stopLimitInput.text, let limitPrice = self.priceInput.text, let amount = self.numberOfShares.text{
                        if let stopLossFloat = Float(stopLoss), let limitPriceFloat = Float(limitPrice), let amountFloat = Float(amount), let priceFloat = Float(price){
                            if stopLossFloat > priceFloat && limitPriceFloat < stopLossFloat{
                                self.totalAmount.text = String(describing: (amountFloat * limitPriceFloat))
                                currentStock.price = limitPriceFloat
                                currentStock.stopLoss = stopLossFloat
                                currentStock.quantity = Int(amountFloat)
                            }
                        }
                    }
                    break
                
                default:
                    print("Wrong Choice in \\_('^')_//")
                }
        }
        
//        if textField == stopLimitInput{
//            if let stopLoss = textField.text{
//                if let stopLossFloat = Float(stopLoss){
//                    currentStock.stopLoss = stopLossFloat
//                }
//            }
//        }
//        
//        if textField == priceInput{
//            if let limitPrice = textField.text{
//                if let limitPriceFloat = Float(limitPrice){
//                    currentStock.price = limitPriceFloat
//                }
//            }
//        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.scrollView.isScrollEnabled = true
    }
    
    // MARK Order Utilities
    
    func checkOrderValidity() -> Bool{
        if (Float(totalAmount.text!)!) < getBuyingPower(){
            switch currentStock.orderType {
                case "Limit":
                    if let limitPrice = self.priceInput.text{
                        if let limitPriceFloat = Float(limitPrice){
                            if limitPriceFloat < Float(currentPrice.text!)!{
                                print("HELLO")
                                return true
                            }
                        }
                    }
                
                    
                case "Stop Loss":
                    // when current price reaches stop loss (buy) the order is executed
                    if let stopLoss = self.priceInput.text{
                        if let stopLossFloat = Float(stopLoss){
                            if stopLossFloat > Float(currentPrice.text!)!{
                                return true
                            }
                        }
                    }
                
                    
                case "Stop Limit":
                    // when current price reaches stop loss (buy) and again reaches the limit price it sells
                    
                    if let stopLoss = self.stopLimitInput.text, let limitPrice = self.priceInput.text{
                        if let stopLossFloat = Float(stopLoss), let limitPriceFloat = Float(limitPrice){
                            if stopLossFloat > Float(currentPrice.text!)! && limitPriceFloat < stopLossFloat{
                                return true
                            }
                        }
                    }
                
                    
                default:
                    print("Wrong Choice in \\_('^')_//")
                }
            

            }
        
        return false
    }
    
    
    // MARK Action
    @IBAction func closeWasPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
