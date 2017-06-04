
//
//  EVCTravelTableViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/31/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//
import UIKit
import API
import Toast_Swift
import SwiftyJSON
class EVCTravelTableViewController: UITableViewController {
    var travelSites = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.travelSites = TRAVEL_SITES /* copyItems: true */
        self.loadData()
    }
    
    func loadData() {
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            
            let dic2 = RestAPI.getInstance().getTravelFavorites()
            let arr = dic2.arrayValue.map({ (json) -> Int in
                return json["trvl_ref_id"].intValue
            })
            
            self.travelSites = TravelRefList.getInstance().list.filter({ (key, value) -> Bool in
                return !arr.contains(key)
            }).map({ (key, value) -> String in
                return value
            })
            
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.tableView.reloadData()
            })
        })
    }

    
// MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CellIdentifier")
        }
        cell?.textLabel?.text = self.travelSites[indexPath.row]
        return cell!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.travelSites.count
    }

override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let browserAction = UIAlertAction(title: "Open in Browser", style: .default) { (action) in
            self.openURLinBrowser(self.travelSites[indexPath.row])
        }
        let addAction = UIAlertAction(title: "Add to Favorites", style: .default) { (action) in
            self.add(toFavs: self.travelSites[indexPath.row])
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(browserAction)
        sheet.addAction(addAction)
        sheet.addAction(cancelAction)
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
            _ = RestAPI.getInstance().addTravelFavoriteURL(url)
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.tableView.reloadData()
            })
        })
    }
}
