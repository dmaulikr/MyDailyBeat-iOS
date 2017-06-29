
//
//  EVCShoppingFavoritesTableViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 1/29/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//
import UIKit
import API
import Toast_Swift
import SwiftyJSON
class EVCShoppingFavoritesTableViewController: UITableViewController {
    var searchResults = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }

    

    func loadData() {
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            let dic = RestAPI.getInstance().searchShoppingURLs(withQueryString: nil)
            let dic2 = RestAPI.getInstance().getShoppingFavorites()
            let arr = dic2.arrayValue.map({ (json) -> Int in
                return json["shpng_ref_id"].intValue
            })
            
            let arr2 = dic.arrayValue.filter({ (json) -> Bool in
                let value: Int = json["shpng_ref_id"].intValue
                return arr.contains(value)
            })
            
            self.searchResults = arr2.map({ (json) -> String in
                return json["shpng_url"].stringValue
            })
            
            
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.tableView.reloadData()
            })
        })
    }
// MARK: - Table view data source

override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CellIdentifier")
        }
        cell?.textLabel?.text = self.searchResults[indexPath.row]
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let browserAction = UIAlertAction(title: "Open in Browser", style: .default) { (action) in
            self.openURLinBrowser(self.searchResults[indexPath.row])
        }
        let addAction = UIAlertAction(title: "Remove from Favorites", style: .default) { (action) in
            self.remove(fromFavs: self.searchResults[indexPath.row])
        }
        sheet.addAction(browserAction)
        sheet.addAction(addAction)
        self.present(sheet, animated: true, completion: nil)
    }

    func openURLinBrowser(_ url: String) {
        let fullURL: String
        if url.hasPrefix("http://") || url.hasPrefix("https://") {
            fullURL = "\(url)"
        } else {
            fullURL = "http://\(url)"
        }
        UIApplication.shared.open(URL(string: fullURL)!, options: [:], completionHandler: nil)
    }

    func remove(fromFavs url: String) {
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            _ = RestAPI.getInstance().removeShoppingFavoriteURL(url)
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.loadData()
            })
        })
    }

    
}
