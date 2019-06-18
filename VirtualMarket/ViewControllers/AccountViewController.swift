//
//  AccountViewController.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 15/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    
    @IBOutlet weak var portfolioValue: UILabel!
    @IBOutlet weak var buyingPowerLabel: UILabel!
    @IBOutlet weak var account: UILabel!
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buyVirtualPressed(_ sender: Any) {
        changeAccountValue(value: 1000.0)
        self.account.text = String(getAccountValue())
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.buyingPowerLabel.text = String(getBuyingPower())
        self.account.text = String(getAccountValue())
        self.portfolioValue.text = String(getTotalStockValue())
        print(getBuyingPower())
        print(getAccountValue())
        print(getTotalStockValue())
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
}
