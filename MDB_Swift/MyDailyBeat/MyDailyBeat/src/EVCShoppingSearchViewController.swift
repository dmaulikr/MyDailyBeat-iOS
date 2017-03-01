
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
    var searchResults = [JSON]()


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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadData() {
        let queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            var dic = RestAPI.getInstance().searchShoppingURLS(withQueryString: "", with: .ascending)
            var dic2 = RestAPI.getInstance().getShoppingFavorites(for: RestAPI.getInstance().getCurrentUser(), with: .ascending)
            var arr = dic2["items"].arrayValue
            self.searchResults = dic["items"].arrayValue
            for i in 0..<arr.count {
                if self.searchResults.contains(arr[i]) {
                    self.searchResults.remove(at: self.searchResults.index(of: arr[i]) ?? -1)
                }
            }
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
        cell?.textLabel?.text = self.searchResults[indexPath.row].stringValue
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
        let queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            RestAPI.getInstance().addShoppingFavoriteURL(url, for: RestAPI.getInstance().getCurrentUser())
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
        var queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            var dic = RestAPI.getInstance().searchShoppingURLS(withQueryString: text, with: .ascending)
            var dic2 = RestAPI.getInstance().getShoppingFavorites(for: RestAPI.getInstance().getCurrentUser(), with: .ascending)
            var arr = dic2["items"].arrayValue
            self.searchResults = dic["items"].arrayValue
            for i in 0..<arr.count {
                if self.searchResults.contains(arr[i]) {
                    self.searchResults.remove(at: self.searchResults.index(of: arr[i]) ?? -1)
                }
            }
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
            self.searchResults = [Any]() as! [JSON]
            self.updateSearch(text)
        }
    }
}
