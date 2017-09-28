//
//  NewsTableViewCell.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 27/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var news: UILabel!
    
    
    open func configureCell(title:String, source: String) -> UITableViewCell{
        self.newsTitle.text = title
        return self as UITableViewCell
    }
}
