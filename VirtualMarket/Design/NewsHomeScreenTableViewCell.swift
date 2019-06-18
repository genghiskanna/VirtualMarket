//
//  NewsHomeScreenTableViewCell.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna on 17/02/19.
//  Copyright © 2019 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit
import FeedKit

class NewsHomeScreenTableViewCell: UITableViewCell {

    @IBOutlet weak var firstStock: UILabel!
    @IBOutlet weak var firstStockChange: UILabel!
    @IBOutlet weak var secondStock: UILabel!
    @IBOutlet weak var secondStockChange: UILabel!
    @IBOutlet weak var thirdStock: UILabel!
    @IBOutlet weak var thirdStockChange: UILabel!
    
    @IBOutlet weak var heading: UILabel!
    
    @IBOutlet weak var newsImage: UIImageView!
    
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var datePublished: UILabel!
    
    func configureCell(_ rssFeed:RSSFeedItem,publisher:String){
        // Initalization
        firstStock.text = ""
        firstStockChange.text = ""
        secondStock.text = ""
        secondStockChange.text = ""
        thirdStock.text = ""
        thirdStockChange.text = ""
        
        self.newsImage.layer.cornerRadius = 5.0
        self.newsImage.contentMode = .scaleToFill
        
        
        self.heading.text = rssFeed.title!
        if let author = rssFeed.author{
            self.publisher.text = author
        }
        if let imageLinkURLString = rssFeed.comments{
            if let imageURL = URL(string: imageLinkURLString){
                do{
                    self.newsImage.image = try UIImage(data: Data(contentsOf: imageURL))
                } catch {
                    print("News Image Failed")
                }
            }
        }
        let dFormat = DateFormatter()
        dFormat.dateFormat = "dd-MM"
        self.datePublished.text = dFormat.string(from:rssFeed.pubDate!)
        
        
    }

}
