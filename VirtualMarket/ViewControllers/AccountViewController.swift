//
//  AccountViewController.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 15/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    
    @IBOutlet weak var buyingPowerLabel: UILabel!
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.buyingPowerLabel.text = String(getBuyingPower())
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
}
