
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
// MARK: - Table view data source

override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.peeps.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CellIdentifier")
        }
        let user: VerveUser? = self.peeps[indexPath.row]
        cell?.textLabel?.text = user?.screenName
        return cell!
    }
// MARK: - Table view delegate
    // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.makeCall(indexPath.row)
    }

    func makeCall(_ index: Int) {
        let dialstring: String = self.peeps[index].mobile
        self.makeCall2(dialstring)
    }

    func makeCall2(_ num: String) {
        let dialstring: String = "tel:\(num)"
        let url = URL(string: dialstring)
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: {(_ success: Bool) -> Void in
                if success {
                    self.save(toCallHistoryNumber: num, withAccessCode: "")
                }
            })
        }
        else {
            let alView = UIAlertController(title: "Calling not supported", message: "This device does not support phone calls.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alView.addAction(action)
            self.present(alView, animated: true, completion: nil)
            
        }
    }

    func save(toCallHistoryNumber num: String, withAccessCode code: String) {
        if code == "" {
            if (num == "1-800-273-8255") {
                    // suicide
                var callHistory: [Any]? = UserDefaults.standard.object(forKey: "callHistory") as! [Any]?
                if callHistory == nil {
                    callHistory = [Any]()
                }
                callHistory?.insert("Suicide Hotline", at: 0)
                UserDefaults.standard.set(callHistory, forKey: "callHistory")
            }
            else {
                    // save number
                var callHistory: [Any]? = UserDefaults.standard.object(forKey: "callHistory") as! [Any]?
                if callHistory == nil {
                    callHistory = [Any]()
                }
                callHistory?.insert(num, at: 0)
                UserDefaults.standard.set(callHistory, forKey: "callHistory")
            }
        }
        else {
                // veterans
            var callHistory: [Any]? = UserDefaults.standard.object(forKey: "callHistory") as! [Any]?
            if callHistory == nil {
                callHistory = [Any]()
            }
            callHistory?.insert("Veterans' Hotline", at: 0)
            UserDefaults.standard.set(callHistory, forKey: "callHistory")
        }
        UserDefaults.standard.synchronize()
    }

    
}
