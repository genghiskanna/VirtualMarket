//
//  TransferViewController.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 16/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding
import SCLAlertView

class TransferViewController: UIViewController, UITextFieldDelegate {

    // labels 
    @IBOutlet weak var buyingPower: UILabel!
    @IBOutlet weak var account: UILabel!
    // TextField
    @IBOutlet weak var amountField: TextField!
    
    
    
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func transferToBankingAccountPressed(_ sender: Any) {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "CircularAirPro", size: 20)!,
            kTextFont: UIFont(name: "CircularAirPro", size: 14)!,
            kButtonFont: UIFont(name: "CircularAirPro-Book", size: 14)!,
            showCloseButton: false,
            showCircularIcon: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Ok", backgroundColor: Colors.teal, textColor: Colors.light, showDurationStatus: false, action: {})
        
        if let amount = amountField.text{
            if (getBuyingPower() - Float(amount)!) >= 0 {
                changeBuyingPower(value: -Float(amount)!)
                changeAccountValue(value: Float(amount)!)
                self.account.text = String(getAccountValue())
                self.buyingPower.text = String(getBuyingPower())
            } else {
                 _ = alertView.showCustom("Insufficient Funds", subTitle: "You have Insufficient Funds to transfer funds from Virtual Trading Account to Virtual Bank Account. Consider reducing the amount or buying more virtual money in the market.", color: Colors.teal, icon: UIImage())
            }
        }
    }
    
    @IBAction func transferToTradingAccount(_ sender: Any) {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "CircularAirPro", size: 20)!,
            kTextFont: UIFont(name: "CircularAirPro", size: 14)!,
            kButtonFont: UIFont(name: "CircularAirPro-Book", size: 14)!,
            showCloseButton: false,
            showCircularIcon: false
        )
        
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Ok", backgroundColor: Colors.teal, textColor: Colors.light, showDurationStatus: false, action: {})
        
        if let amount = amountField.text{
            if (getAccountValue() - Float(amount)!) >= 0 {
                changeBuyingPower(value: Float(amount)!)
                changeAccountValue(value: -Float(amount)!)
                self.account.text = String(getAccountValue())
                self.buyingPower.text = String(getBuyingPower())
            } else {
                _ = alertView.showCustom("Insufficient Funds", subTitle: "You have Insufficient Funds to transfer funds from Virtual Bank Account to Virtual Trading Account. Consider reducing the amount or buying more virtual money in the market.", color: Colors.teal, icon: UIImage())
            }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        KeyboardAvoiding.avoidingView = self.view
        
        self.amountField.delegate = self
        
        self.buyingPower.text = String(getBuyingPower())
        self.account.text = String(getAccountValue())
       
        customizeDone()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func customizeDone(){
        self.amountField.backgroundColor = .clear
        self.amountField.textColor = Colors.dark
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolBar.setItems([done], animated: true)
        self.amountField.inputAccessoryView = toolBar
        
    }
    
    @objc func donePressed(){
        self.view.endEditing(true)
    }
    
    
    
    
    
    

    
}
