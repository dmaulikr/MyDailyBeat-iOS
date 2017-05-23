
//
//  EVCFeelingBlueTableViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 2/6/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//
import UIKit
import API
import Toast_Swift
import SwiftyJSON
class EVCFeelingBlueTableViewController: UITableViewController {
    var search: EVCSearchEngine!

    var peeps: [VerveUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        search = EVCSearchEngine()
        self.loadData()
    }

    

    func loadData() {
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            self.peeps = self.search.getUsersForFeelingBlue()
            var i = 0
            while i < self.peeps.count {
                let user: VerveUser? = self.peeps[i]
                if (user?.screenName == RestAPI.getInstance().getCurrentUser().screenName) {
                    self.peeps.remove(at: i)
                }
                else {
                    i += 1
                }
                
            }
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.tableView.reloadData()
            })
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
// MARK: - Table view data source

override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        guard self.peeps.count > 0 else {
            return 1
        }
        return self.peeps.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CellIdentifier")
        }
        guard self.peeps.count > 0 else {
            cell?.textLabel?.text = "No users found"
            return cell!
        }
        let user: VerveUser? = self.peeps[indexPath.row]
        cell?.textLabel?.text = user?.screenName
        return cell!
    }
// MARK: - Table view delegate
    // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ViewProfileSegue", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? EVCFlingProfileViewController {
            let row = sender as! Int
            dest.currentViewedUser = self.peeps[row]
            dest.inRel = false
            dest.mode = .friends_MODE
        }
    }

    
}
