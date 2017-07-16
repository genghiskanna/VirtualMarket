//
//  ReportViewController.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 16/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var valueCent: UILabel!

    @IBOutlet weak var segmentControl: SegmentedControl6!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func backPortfolioPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    


}
