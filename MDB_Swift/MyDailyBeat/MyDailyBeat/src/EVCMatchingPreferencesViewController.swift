//
//  EVCMatchingPreferencesViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 5/29/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import UIKit
import API
class EVCMatchingPreferencesViewController: UITableViewController {

    var prefs: VerveMatchingPreferences!
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
        return 8
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
        } else if section == 5 {
            return AgeRefList.getInstance().list.keys.count
        } else {
            return ThreeChoiceRefList.getInstance().list.keys.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleCell", for: indexPath) as! ToggleTableViewCell
        if indexPath.section == 0 {
            cell.textLabel?.text = GenderRefList.getInstance().list[indexPath.row + 1]
            cell.update()
            cell.toggleSwitch.setOn(self.prefs.gender.contains(indexPath.row + 1), animated: true)
            cell.onToggle = {
                if cell.toggleSwitch.isOn {
                    self.prefs.gender.append(indexPath.row + 1)
                } else {
                    let index = self.prefs.gender.index(of: indexPath.row + 1)!
                    self.prefs.gender.remove(at: index)
                }
                self.tableView.reloadData()
            }
        } else if indexPath.section == 1 {
            cell.textLabel?.text = MaritalRefList.getInstance().list[indexPath.row + 1]
            cell.update()
            cell.toggleSwitch.setOn(self.prefs.status.contains(indexPath.row + 1), animated: true)
            cell.onToggle = {
                if cell.toggleSwitch.isOn {
                    self.prefs.status.append(indexPath.row + 1)
                } else {
                    let index = self.prefs.status.index(of: indexPath.row + 1)!
                    self.prefs.status.remove(at: index)
                }
                self.tableView.reloadData()
            }
        } else if indexPath.section == 2 {
            cell.textLabel?.text = EthnicityRefList.getInstance().list[indexPath.row + 1]
            cell.update()
            cell.toggleSwitch.setOn(self.prefs.ethnicity.contains(indexPath.row + 1), animated: true)
            cell.onToggle = {
                if cell.toggleSwitch.isOn {
                    self.prefs.ethnicity.append(indexPath.row + 1)
                } else {
                    let index = self.prefs.ethnicity.index(of: indexPath.row + 1)!
                    self.prefs.ethnicity.remove(at: index)
                }
                self.tableView.reloadData()
            }
        } else if indexPath.section == 3 {
            cell.textLabel?.text = ReligionRefList.getInstance().list[indexPath.row + 1]
            cell.update()
            cell.toggleSwitch.setOn(self.prefs.beliefs.contains(indexPath.row + 1), animated: true)
            cell.onToggle = {
                if cell.toggleSwitch.isOn {
                    self.prefs.beliefs.append(indexPath.row + 1)
                } else {
                    let index = self.prefs.beliefs.index(of: indexPath.row + 1)!
                    self.prefs.beliefs.remove(at: index)
                }
                self.tableView.reloadData()
            }
        } else if indexPath.section == 4 {
            cell.textLabel?.text = DrinkerRefList.getInstance().list[indexPath.row + 1]
            cell.update()
            cell.toggleSwitch.setOn(self.prefs.drinker.contains(indexPath.row + 1), animated: true)
            cell.onToggle = {
                if cell.toggleSwitch.isOn {
                    self.prefs.drinker.append(indexPath.row + 1)
                } else {
                    let index = self.prefs.drinker.index(of: indexPath.row + 1)!
                    self.prefs.drinker.remove(at: index)
                }
                self.tableView.reloadData()
            }
        } else if indexPath.section == 5 {
            if let value = AgeRefList.getInstance().list[indexPath.row + 1] {
                let text: String
                if value.max > 100 {
                    text = "\(value.min)+"
                } else {
                    text = "\(value.min) - \(value.max)"
                }
                cell.textLabel?.text = text
            } else {
                cell.textLabel?.text = AGE_STRING_LIST[indexPath.row]
            }
            cell.update()
            cell.toggleSwitch.setOn(self.prefs.age.contains(indexPath.row + 1), animated: true)
            cell.onToggle = {
                if cell.toggleSwitch.isOn {
                    self.prefs.age.append(indexPath.row + 1)
                } else {
                    let index = self.prefs.age.index(of: indexPath.row + 1)!
                    self.prefs.age.remove(at: index)
                }
                self.tableView.reloadData()
            }
        } else if indexPath.section == 6 {
            cell.textLabel?.text = ThreeChoiceRefList.getInstance().list[indexPath.row + 1]
            cell.update()
            cell.toggleSwitch.setOn(indexPath.row + 1 == self.prefs.isSmoker, animated: true)
            cell.onToggle = {
                if cell.toggleSwitch.isOn {
                    self.prefs.isSmoker = indexPath.row + 1
                } else {
                    self.prefs.isSmoker = 0
                }
                self.tableView.reloadData()
            }
        } else {
            cell.textLabel?.text = ThreeChoiceRefList.getInstance().list[indexPath.row + 1]
            cell.update()
            cell.toggleSwitch.setOn(indexPath.row + 1 == self.prefs.isVeteran, animated: true)
            cell.onToggle = {
                if cell.toggleSwitch.isOn {
                    self.prefs.isVeteran = indexPath.row + 1
                } else {
                    self.prefs.isVeteran = 0
                }
                self.tableView.reloadData()
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
        } else if section == 5 {
            return "Age"
        } else if section == 6 {
            return "Smoker"
        } else {
            return "Veteran"
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let dest = segue.destination as? EVCPreferencesViewController {
            dest.matchingPreferences = self.prefs
        }
    }

}
