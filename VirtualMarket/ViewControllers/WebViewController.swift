//
//  WebViewController.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 14/08/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let url = URL(string: currentUrlForNews)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
        
        
        
        
        
    }
    
   

}
