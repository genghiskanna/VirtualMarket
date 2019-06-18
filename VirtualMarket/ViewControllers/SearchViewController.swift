//
//  SearchViewController.swift
//  VirtualMarket
//
//  Created by Nishaanth Kanna Ravichandran on 04/07/17.
//  Copyright © 2017 Nishaanth Kanna Ravichandran. All rights reserved.
//

import UIKit

public var stockNameG: String!

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate var searchResultsGlobal = Array<String>()

    @IBOutlet weak var navigationBar: CustomNavigationBar!
    @IBOutlet weak var searchResults: UITableView!
    @IBOutlet weak var stockField: TextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = CurrentSettings.getTheme()["light"]
        self.navigationBar.topItem?.title = "Enter Stock Name"
        self.searchResults.backgroundColor = CurrentSettings.getTheme()["light"]
        self.searchResults.isHidden = true
        
        self.stockField.delegate = self
        self.stockField.leftViewMode = .always
        self.searchResults.rowHeight = 60.0
        
        self.searchResults.delegate = self
        self.searchResults.dataSource = self
        
        self.stockField.becomeFirstResponder()
        if CurrentSettings.getTheme()["light"] == Colors.dark{
            self.stockField.keyboardAppearance = .dark
        } else{
            self.stockField.keyboardAppearance = .light
        }
        
        
        self.stockField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        

        // Checking if the setting is dark mode
        if CurrentSettings.getTheme()["light"] == Colors.dark {
            self.stockField.leftView = UIImageView(image: UIImage(named: "searchWhite"))
        } else {
            self.stockField.leftView = UIImageView(image: UIImage(named: "search"))
        }
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField){
        
        self.searchResults.reloadData()
        if let text = textField.text {
            let searchResultsA : Array<String> = SearchJSON.SearchStock(text.trimmingCharacters(in: CharacterSet(charactersIn: " ")))
            if searchResultsA.count != 1 {
                self.searchResultsGlobal = searchResultsA
                self.searchResults.isHidden = false
            }
            
        }
        
        if textField.text?.count == 0 {
            self.searchResults.isHidden = true
        }
        self.searchResults.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.stockField.text = ""
        self.searchResults.reloadData()
    }
  
    
    
    
    // Tableview datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.searchResultsGlobal.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! SearchTableViewCell
        
        stockNameG = cell.stockName.text!
        
        performSegue(withIdentifier: "searchSegue", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! SearchTableViewCell
        tableView.tableFooterView = UIView()
        cell = cell.configureCell(searchResultsGlobal[indexPath.row]) as! SearchTableViewCell
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func prepareForUnwind(_ segue:UIStoryboardSegue){
    
    }
    
    
    
    

    

}
