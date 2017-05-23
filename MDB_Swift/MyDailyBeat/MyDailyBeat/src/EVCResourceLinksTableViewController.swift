
//
//  EVCResourceLinksTableViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/30/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//
import UIKit
import API
import SwiftyJSON

fileprivate let resLinks: [String: [String]] = ["Finance": ["finance.yahoo.com", "money.cnn.com", "bloomberg.com"],
                                                "FeelingBlue": ["suicidepreventionlifeline.org", "psychcentral.com/helpme.htm", "hopeline.com"]
]
class EVCResourceLinksTableViewController: UITableViewController {
    var path: String = ""
    var module: String = ""
    var resLinks = JSON([])

    var dataArr = [JSON]()

    override func viewDidLoad() {
        super.viewDidLoad()
        path = RES_LINKS!
        let tempResLinks = NSDictionary(contentsOfFile: path)
        resLinks = JSON(tempResLinks!)
        let insets: UIEdgeInsets? = UIEdgeInsetsMake(0, 0, (self.tabBarController?.tabBar.frame.height)!, 0)
        self.tableView.contentInset = insets!
        self.tableView.scrollIndicatorInsets = insets!
        self.edgesForExtendedLayout = .all
        self.reloadData()
    }

    func reloadData() {
        if (module == "Finance") {
            self.dataArr = resLinks["Finances"].arrayValue
        }
        else if (module == "FeelingBlue") {
            self.dataArr = resLinks["FeelingBlue"].arrayValue
        }
        else if (module == "Relationships") {
            self.dataArr = resLinks["Relationships"].arrayValue
        }
        else if (module == "Jobs") {
            self.dataArr = resLinks["Jobs"].arrayValue
        }
        else if (module == "Health") {
            self.dataArr = resLinks["Health"].arrayValue
        }
        else if (module == "Travel") {
            self.dataArr = resLinks["Travel"].arrayValue
        }
        else if (module == "Volunteering") {
            self.dataArr = resLinks["Volunteering"].arrayValue
        }
        else if (module == "Shopping") {
            self.dataArr = resLinks["Shopping"].arrayValue
        }
        else {
            self.dataArr = [JSON]()
        }

        self.tableView.reloadData()
    }

    
// MARK: - Table view data source

override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.dataArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CELL")
        if (self.dataArr[indexPath.row] == "") {
            cell.textLabel?.text = "No Links Found"
        }
        else {
            cell.textLabel?.text = self.dataArr[indexPath.row].stringValue
        }
        return cell
    }
// MARK: - Table view delegate
    // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.openURLinBrowser(self.dataArr[indexPath.row] as! String)
    }

    func openURLinBrowser(_ url: String) {
        let fullURL: String = "http://www.\(url)"
        UIApplication.shared.openURL(URL(string: fullURL)!)
    }
}
