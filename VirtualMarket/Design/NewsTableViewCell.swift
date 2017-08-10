//
//  NewsTableViewCell.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 27/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit
import Kanna
import AlamofireRSSParser

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var news: UILabel!
    
    
    open func configureCell(newsFeed: RSSItem) -> UITableViewCell{
        self.newsTitle.text = newsFeed.title
        return self as UITableViewCell
    }
}
