
//
//  EVCShoppingSearchViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 1/25/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//
import UIKit
import API
import Toast_Swift
import SwiftyJSON
class EVCShoppingSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    var isFiltered: Bool = false

    @IBOutlet var mTableView: UITableView!
    @IBOutlet var sBar: UISearchBar!
    var searchResults = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.sBar.delegate = self
        self.mTableView.delegate = self
        self.mTableView.dataSource = self
        self.mTableView.tableHeaderView = self.sBar
        self.sBar.showsScopeBar = true
        self.sBar.setShowsCancelButton(false, animated: true)
        self.sBar.sizeToFit()
        self.sBar.autocorrectionType = .no
        self.sBar.autocapitalizationType = .none
        isFiltered = false
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
                return !arr.contains(value)
            })
            
            self.searchResults = arr2.map({ (json) -> String in
                return json["shpng_url"].stringValue
            })
            
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.mTableView.reloadData()
            })
        })
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CellIdentifier")
        }
        cell?.textLabel?.text = self.searchResults[indexPath.row]
        return cell!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }

func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let browserAction = UIAlertAction(title: "Open in Browser", style: .default) { (action) in
            self.openURLinBrowser(self.searchResults[indexPath.row])
        }
        let addAction = UIAlertAction(title: "Add to Favorites", style: .default) { (action) in
            self.add(toFavs: self.searchResults[indexPath.row])
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

    func add(toFavs url: String) {
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            _ = RestAPI.getInstance().addShoppingFavoriteURL(url)
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.loadData()
            })
        })
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.characters.count ) == 0 && isFiltered {
            isFiltered = false
            self.mTableView.reloadData()
        }
    }

    func updateSearch(_ text: String) {
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            
            let dic: JSON
            if text == "" {
                dic = RestAPI.getInstance().searchShoppingURLs(withQueryString: nil)
            } else {
                dic = RestAPI.getInstance().searchShoppingURLs(withQueryString: text)
            }
            let dic2 = RestAPI.getInstance().getShoppingFavorites()
            let arr = dic2.arrayValue.map({ (json) -> Int in
                return json["shpng_ref_id"].intValue
            })
            
            let arr2 = dic.arrayValue.filter({ (json) -> Bool in
                let value: Int = json["shpng_ref_id"].intValue
                return !arr.contains(value)
            })
            
            self.searchResults = arr2.map({ (json) -> String in
                return json["shpng_url"].stringValue
            })
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.mTableView.reloadData()
            })
        })
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        var text: String = searchBar.text!
        if (text.characters.count ) == 0 {
            isFiltered = false
        }
        else {
            isFiltered = true
            self.searchResults = [String]()
            self.updateSearch(text)
        }
    }
}
