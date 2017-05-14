
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
    var searchResults = [JSON]()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }

    

    func loadData() {
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            var dic2 = RestAPI.getInstance().getShoppingFavorites()
            self.searchResults = dic2["items"].arrayValue
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
        cell?.textLabel?.text = self.searchResults[indexPath.row].stringValue
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let browserAction = UIAlertAction(title: "Open in Browser", style: .default) { (action) in
            self.openURLinBrowser(self.searchResults[indexPath.row].stringValue)
        }
        let addAction = UIAlertAction(title: "Add to Favorites", style: .default) { (action) in
            self.add(toFavs: self.searchResults[indexPath.row].stringValue)
        }
        sheet.addAction(browserAction)
        sheet.addAction(addAction)
        self.present(sheet, animated: true, completion: nil)
    }

    func openURLinBrowser(_ url: String) {
        let fullURL: String = "http://www.\(url)"
        UIApplication.shared.openURL(URL(string: fullURL)!)
    }

    func add(toFavs url: String) {
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            _ = RestAPI.getInstance().addShoppingFavoriteURL(url)
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.tableView.reloadData()
            })
        })
    }

    
}
