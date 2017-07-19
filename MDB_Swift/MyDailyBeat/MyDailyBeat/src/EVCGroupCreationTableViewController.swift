
//
//  EVCGroupCreationTableViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/31/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import UIKit
import API
import Toast_Swift
import FXForms
class EVCGroupCreationTableViewController: UITableViewController {
    var frm = GroupCreationForm()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "New Group"
        self.tableView.register(ToggleTableViewCell.self, forCellReuseIdentifier: "HobbiesCell")
        self.tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "GroupNameCell")
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(createGroup))
        self.navigationItem.rightBarButtonItem = saveButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    func createGroup() {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
        let name: String = frm.groupName

        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(.center)
            })
            var success: Bool = RestAPI.getInstance().createGroup(withName: name)
            if self.frm.hobbies.count > 0 {
                var groups = RestAPI.getInstance().getGroupsForCurrentUser()
                for i in 0..<groups.count {
                    let g: Group? = groups[i]
                    if (g?.groupName == name) {
                        let prefs = GroupPrefs()
                        prefs.hobbies = self.frm.hobbies
                        success = RestAPI.getInstance().setHobbiesforGroup(ID: (g?.groupID)!, prefs)
                        break
                    }
                }
            }
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                if success {
                    self.view.makeToast("Group creation successful!", duration: 3.5, position: .bottom)
                }
                else {
                    self.view.makeToast("Group creation failed!", duration: 3.5, position: .bottom)
                    return
                }
                self.navigationController?.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return HobbiesRefList.getInstance().list.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Group Name"
        } else {
            return "Group Hobbies"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let textCell = tableView.dequeueReusableCell(withIdentifier: "GroupNameCell", for: indexPath) as! TextFieldTableViewCell
            textCell.setup(onComplete: {
                self.frm.groupName = textCell.textInput ?? ""
            })
            textCell.textInput = self.frm.groupName
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
    
    
}
