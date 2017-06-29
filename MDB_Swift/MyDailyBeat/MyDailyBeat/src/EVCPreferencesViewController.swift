
//
//  EVCPreferencesViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/23/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import UIKit
import AssetsLibrary
import Toast_Swift
import API
import FXForms
import RESideMenu
class EVCPreferencesViewController: UITableViewController {
    var api: RestAPI!
    var prefs: VervePreferences = VervePreferences()
    var userPreferences: VerveUserPreferences!
    var matchingPreferences: VerveMatchingPreferences!
    var hobbiesPreferences: HobbiesPreferences!
    var unwindSegueID: String = "RegularUnwindSegue"
    var onSuccess: ((Bool, UIViewController) -> ()) = { (success, vc) in
        _ = vc.sideMenuViewController.contentViewController.navigationController?.popToRootViewController(animated: true)
    }
    var canSave: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        api = RestAPI.getInstance()
        self.retrievePrefs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func retrievePrefs() {
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            self.userPreferences = self.api.getUserPreferences()
            self.matchingPreferences = self.api.getMatchingPreferences()
            self.hobbiesPreferences = self.api.getHobbiesPreferencesForUser()
            if self.api.preferencesExistForUser() {
                self.prefs.userPreferences = self.userPreferences
            }
            
            if self.api.matchingPreferencesExistForUser() {
                self.prefs.matchingPreferences = self.matchingPreferences
            }
            
            if self.api.hobbiesPreferencesExistForUser() {
                self.prefs.hobbiesPreferences = self.hobbiesPreferences
            }
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.reloadData()
            })
        })
    }
    
    func reloadData() {
        if self.prefs.userPreferences == nil || self.prefs.matchingPreferences == nil || self.prefs.hobbiesPreferences == nil {
            self.canSave = false
        } else {
            self.canSave = true
        }
        self.tableView.reloadData()
    }

    func submit() {
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            let success: Bool = self.api.save(self.prefs.userPreferences!, andMatchingPreferences: self.prefs.matchingPreferences!)
            let success2 = self.api.save(self.prefs.hobbiesPreferences!)
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                if success && success2 {
                    if self.unwindSegueID == "RegularUnwindSegue" {
                        self.navigationController?.setNavigationBarHidden(true, animated: true)
                    }
                    self.performSegue(withIdentifier: self.unwindSegueID, sender: self)
                }
                else {
                    print("Failed")
                }
            })
        })
    }
    
    @IBAction func backToPrefs(sender: UIStoryboardSegue) {
        if sender.source is EVCUserPreferencesViewController {
            self.prefs.userPreferences = self.userPreferences
        } else if sender.source is EVCMatchingPreferencesViewController {
            self.prefs.matchingPreferences = self.matchingPreferences
        } else {
            self.prefs.hobbiesPreferences = self.hobbiesPreferences
        }
        self.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "User Preferences"
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Matching Preferences"
            } else {
                cell.textLabel?.text = "Hobbies Preferences"
            }
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.textLabel?.text = "Save"
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let segue: String
            if indexPath.row == 0 {
                segue = "UserPrefSegue"
            } else if indexPath.row == 1 {
                segue = "MatchingPrefSegue"
            } else {
                segue = "HobbyPrefSegue"
            }
            self.performSegue(withIdentifier: segue, sender: nil)
        } else {
            if self.canSave {
                self.submit()
            } else {
                let alert = UIAlertController(title: "Preferences are not complete.", message: "You have not completed entering all your preferences.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? EVCUserPreferencesViewController {
            dest.prefs = self.userPreferences
        } else if let dest = segue.destination as? EVCMatchingPreferencesViewController {
            dest.prefs = self.matchingPreferences
        } else if let dest = segue.destination as? EVCHobbiesPreferencesViewController {
            dest.prefs = self.hobbiesPreferences
        }
    }
    
}
