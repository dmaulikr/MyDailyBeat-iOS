
//
//  EVCCallHistoryTableViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 5/14/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import UIKit
import DLAlertView
import API
class EVCCallHistoryTableViewController: UITableViewController {

    var callHistory = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = UserDefaults.standard
        self.callHistory = userDefaults.stringArray(forKey: "callHistory") ?? [String]()
    }

    
// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.callHistory.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CELL")
        cell.textLabel?.text = self.callHistory[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: UITableViewCell? = tableView.cellForRow(at: indexPath)
        var number: String = ""
        var code: String = ""
        if (cell?.textLabel?.text == "Suicide Hotline") {
            number = "1-800-273-8255"
        }
        else if (cell?.textLabel?.text == "Veterans' Hotline") {
            number = "1-800-273-8255"
            code = "1"
        }
        else {
            number = (cell?.textLabel?.text)!
        }

        if !(code == "") {
            self.makeCall(number, withAccessCode: code)
        }
        else {
            self.makeCall(number)
        }
    }

    func makeCall(_ num: String) {
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

    func makeCall(_ num: String, withAccessCode code: String) {
        let dialstring: String = "tel:\(num),,\(code)#"
        let url = URL(string: dialstring)
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: {(_ success: Bool) -> Void in
                if success {
                    self.save(toCallHistoryNumber: num, withAccessCode: code)
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
                var callHistory = UserDefaults.standard.stringArray(forKey: "callHistory") ?? [String]()
                callHistory.insert("Suicide Hotline", at: 0)
                UserDefaults.standard.set(callHistory, forKey: "callHistory")
            }
            else {
                    // save number
                var callHistory = UserDefaults.standard.stringArray(forKey: "callHistory") ?? [String]()
                callHistory.insert(num, at: 0)
                UserDefaults.standard.set(callHistory, forKey: "callHistory")
            }
        }
        else {
                // veterans
            var callHistory = UserDefaults.standard.stringArray(forKey: "callHistory") ?? [String]()
            callHistory.insert("Veterans' Hotline", at: 0)
            UserDefaults.standard.set(callHistory, forKey: "callHistory")
        }
        UserDefaults.standard.synchronize()
    }
}
