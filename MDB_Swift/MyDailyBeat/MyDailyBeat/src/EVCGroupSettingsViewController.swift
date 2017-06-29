
//
//  EVCGroupSettingsViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/26/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

import UIKit
import API
import Toast_Swift
import FXForms
class EVCGroupSettingsViewController: UITableViewController {
    var frm = GroupPrefs()
    var group = Group()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Edit Group"
        self.tableView.register(ToggleTableViewCell.self, forCellReuseIdentifier: "HobbiesCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DeleteCell")
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(editGroup))
        self.navigationItem.rightBarButtonItem = saveButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadPrefs()
    }
    
    func loadPrefs() {
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(.center)
            })
            let hobbies = RestAPI.getInstance().getHobbiesForGroup(self.group).map({ (json) -> Int in
                return json["hby_ref_id"].intValue
            })
            
            for key in HobbiesRefList.getInstance().list.keys {
                self.frm.hobbies[key] = hobbies.contains(key)
            }
            
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.tableView.reloadData()
            })
        })
    }
    
    
    func deleteGroup() {
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(.center)
            })
            let success: Bool = RestAPI.getInstance().delete(group: self.group)
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                if success {
                    self.view.makeToast("Group delete successful!", duration: 3.5, position: .bottom)
                }
                else {
                    self.view.makeToast("Group delete failed!", duration: 3.5, position: .bottom)
                    return
                }
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.navigationController?.popToRootViewController(animated: true)
            })
        })
    }
    
    func editGroup() {
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(.center)
            })
            let success: Bool = RestAPI.getInstance().setHobbiesforGroup(ID: self.group.groupID, self.frm)
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                if success {
                    self.view.makeToast("Group editing successful!", duration: 3.5, position: .bottom)
                }
                else {
                    self.view.makeToast("Group editing failed!", duration: 3.5, position: .bottom)
                    return
                }
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.navigationController?.popToRootViewController(animated: true)
            })
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        } else {
            return HobbiesRefList.getInstance().list.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return nil
        } else {
            return "Group Hobbies"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let textCell = tableView.dequeueReusableCell(withIdentifier: "DeleteCell", for: indexPath)
            textCell.textLabel?.textAlignment = .center
            textCell.textLabel?.textColor = UIColor.white
            textCell.backgroundColor = UIColor.red
            textCell.textLabel?.text = "Delete Group"
            return textCell
        } else {
            let toggleCell = tableView.dequeueReusableCell(withIdentifier: "HobbiesCell", for: indexPath) as! ToggleTableViewCell
            let list = HobbiesRefList.getInstance()
            toggleCell.textLabel?.text = list.list[indexPath.row + 1]!
            toggleCell.update()
            toggleCell.toggleSwitch.setOn(self.frm.hobbies[indexPath.row + 1] ?? false, animated: true)
            toggleCell.onToggle = {
                self.frm.toggle(key: indexPath.row + 1, value: toggleCell.toggleSwitch.isOn)
                self.tableView.reloadData()
            }
            return toggleCell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            self.deleteGroup()
        }
    }
    
    
}

