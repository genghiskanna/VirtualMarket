//
//  HomeScreenViewController.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 02/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {

    // Labels
    @IBOutlet weak var netWorthLabel: UILabel!
    @IBOutlet weak var netWorth: UILabel!
    @IBOutlet weak var netWorthCent: UILabel!
    @IBOutlet weak var change: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLabelColor()
        print("json")
        
        

        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = CurrentSettings.getTheme()["light"]
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if CurrentSettings.getStatusBar() == "dark"{
            return .default
            
        } else {
            return .lightContent
            
        }
    }
    
    
    
    
    // UIDesign
    
    func setLabelColor(){
        var color: UIColor?
        if CurrentSettings.getStatusBar() == "dark"{
            color = Colors.dark
            
        } else {
            color = Colors.light
            
        }
        
        self.netWorthLabel.textColor = color!
        self.netWorth.textColor = color!
        self.netWorthCent.textColor = color!
        self.change.textColor = Colors.materialGreen
    }
}


