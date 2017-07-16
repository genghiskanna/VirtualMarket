//
//  TransferViewController.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 16/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit

class TransferViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var amountField: TextField!
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.amountField.delegate = self
       
        customizeDone()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func customizeDone(){
        self.amountField.backgroundColor = .clear
        self.amountField.textColor = Colors.dark
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolBar.setItems([done], animated: true)
        self.amountField.inputAccessoryView = toolBar
        
    }
    
    func donePressed(){
        self.view.endEditing(true)
    }
    
    
    
    
    
    

    
}
