//
//  EVCUserPreferencesViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 5/29/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import UIKit
import API
class EVCUserPreferencesViewController: UITableViewController {
    var prefs: VerveUserPreferences!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(ToggleTableViewCell.self, forCellReuseIdentifier: "ToggleCell")
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func cancel() {
        self.performSegue(withIdentifier: "BackToPrefsSegue", sender: self)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return GenderRefList.getInstance().list.keys.count
        } else if section == 1 {
            return MaritalRefList.getInstance().list.keys.count
        } else if section == 2 {
            return EthnicityRefList.getInstance().list.keys.count
        } else if section == 3 {
            return ReligionRefList.getInstance().list.keys.count
        } else if section == 4 {
            return DrinkerRefList.getInstance().list.keys.count
        } else {
            return 3
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleCell", for: indexPath) as! ToggleTableViewCell
        if indexPath.section == 0 {
            cell.textLabel?.text = GenderRefList.getInstance().list[indexPath.row + 1]
            cell.update()
            cell.toggleSwitch.setOn(indexPath.row + 1 == self.prefs.gender, animated: true)
            cell.onToggle = {
                if cell.toggleSwitch.isOn {
                    self.prefs.gender = indexPath.row + 1
                } else {
                    self.prefs.gender = 1
                }
                self.tableView.reloadData()
            }
        } else if indexPath.section == 1 {
            cell.textLabel?.text = MaritalRefList.getInstance().list[indexPath.row + 1]
            cell.update()
            cell.toggleSwitch.setOn(indexPath.row + 1 == self.prefs.status, animated: true)
            cell.onToggle = {
                if cell.toggleSwitch.isOn {
                    self.prefs.status = indexPath.row + 1
                } else {
                    self.prefs.status = 0
                }
                self.tableView.reloadData()
            }
        } else if indexPath.section == 2 {
            cell.textLabel?.text = EthnicityRefList.getInstance().list[indexPath.row + 1]
            cell.update()
            cell.toggleSwitch.setOn(indexPath.row + 1 == self.prefs.ethnicity, animated: true)
            cell.onToggle = {
                if cell.toggleSwitch.isOn {
                    self.prefs.ethnicity = indexPath.row + 1
                } else {
                    self.prefs.ethnicity = 0
                }
                self.tableView.reloadData()
            }
        } else if indexPath.section == 3 {
            cell.textLabel?.text = ReligionRefList.getInstance().list[indexPath.row + 1]
            cell.update()
            cell.toggleSwitch.setOn(indexPath.row + 1 == self.prefs.beliefs, animated: true)
            cell.onToggle = {
                if cell.toggleSwitch.isOn {
                    self.prefs.beliefs = indexPath.row + 1
                } else {
                    self.prefs.beliefs = 0
                }
                self.tableView.reloadData()
            }
        } else if indexPath.section == 4 {
            cell.textLabel?.text = DrinkerRefList.getInstance().list[indexPath.row + 1]
            cell.update()
            cell.toggleSwitch.setOn(indexPath.row + 1 == self.prefs.drinker, animated: true)
            cell.onToggle = {
                if cell.toggleSwitch.isOn {
                    self.prefs.drinker = indexPath.row + 1
                } else {
                    self.prefs.drinker = 0
                }
                self.tableView.reloadData()
            }
        } else {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Smoker"
                cell.update()
                cell.toggleSwitch.setOn(self.prefs.isSmoker, animated: true)
                cell.onToggle = {
                    self.prefs.isSmoker = cell.toggleSwitch.isOn
                    self.tableView.reloadData()
                }
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Veteran"
                cell.update()
                cell.toggleSwitch.setOn(self.prefs.isVeteran, animated: true)
                cell.onToggle = {
                    self.prefs.isVeteran = cell.toggleSwitch.isOn
                    self.tableView.reloadData()
                }
            } else {
                cell.textLabel?.text = "Willing to Connect Anonymously"
                cell.update()
                cell.toggleSwitch.setOn(self.prefs.willingToConnectAnonymously, animated: true)
                cell.onToggle = {
                    self.prefs.willingToConnectAnonymously = cell.toggleSwitch.isOn
                    self.tableView.reloadData()
                }
            }
        }
        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = self.tableView(tableView, cellForRowAt: indexPath) as! ToggleTableViewCell
        cell.toggleSwitch.setOn(!cell.toggleSwitch.isOn, animated: true)
        cell.onToggle()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Gender"
        } else if section == 1 {
            return "Marital Status"
        } else if section == 2 {
            return "Ethnicity"
        } else if section == 3 {
            return "Religion"
        } else if section == 4 {
            return "Drinker"
        } else {
            return nil
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let dest = segue.destination as? EVCPreferencesViewController {
            dest.userPreferences = self.prefs
        }
    }
    

}
