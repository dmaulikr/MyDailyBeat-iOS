
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

fileprivate let RESOURCE_LINKS: [String: [String]] = [
    "Finance": ["finance.yahoo.com", "money.cnn.com", "bloomberg.com"],
    "FeelingBlue": ["suicidepreventionlifeline.org", "psychcentral.com/helpme.htm", "hopeline.com"],
    "Jobs": ["livecareer.com", "careerservices.princeton.edu"],
    "Health": ["webmd.com", "mayoclinic.org", "cdc.gov", "medicineonline.com", "online-medical-dictionary.org"],
    "Relationships": [],
    "Shopping": [],
    "Travel": ["travelchannel.com", "cnn.com/travel", "forbestravelguide.com", "tripadvisor.com"],
    "Volunteering": ["signup.com", "agingnetworkvolunteercollaborative.org", "communityservice.org", "retiredbrains.com/senior-living-resources/volunteering"]
]
class EVCResourceLinksTableViewController: UITableViewController {
    var module: String = ""
    var resLinks = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let insets: UIEdgeInsets? = UIEdgeInsetsMake(0, 0, (self.tabBarController?.tabBar.frame.height)!, 0)
        self.tableView.contentInset = insets!
        self.tableView.scrollIndicatorInsets = insets!
        self.edgesForExtendedLayout = .all
        self.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.makeToastActivity(.center)
        self.reloadData()
        self.view.hideToastActivity()
    }

    func reloadData() {
        self.resLinks = RESOURCE_LINKS[self.module] ?? [String]()
        self.tableView.reloadData()
    }

    
// MARK: - Table view data source

override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.resLinks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CELL")
        if self.resLinks.isEmpty {
            cell.textLabel?.text = "No Links Found"
        }
        else {
            cell.textLabel?.text = self.resLinks[indexPath.row]
        }
        return cell
    }
// MARK: - Table view delegate
    // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.resLinks.count > 0 {
            if self.module == "Jobs" && indexPath.row == 1 {
                self.openURLinBrowser(self.resLinks[indexPath.row], useWWW: false)
            } else {
                self.openURLinBrowser(self.resLinks[indexPath.row])
            }
            
        }
    }

    func openURLinBrowser(_ url: String, useWWW: Bool = true) {
        let fullURL: String
        if useWWW {
            fullURL = "http://www.\(url)"
        } else {
            fullURL = "http://\(url)"
        }
        UIApplication.shared.open(URL(string: fullURL)!, options: [:], completionHandler: nil)
    }
}
