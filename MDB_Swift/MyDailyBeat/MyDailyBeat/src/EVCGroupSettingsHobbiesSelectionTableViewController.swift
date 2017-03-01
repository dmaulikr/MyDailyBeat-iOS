
//
//  EVCGroupSettingsHobbiesSelectionTableViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/24/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import UIKit
import Toast_Swift
import FXForms
class EVCGroupSettingsHobbiesSelectionTableViewController: UITableViewController, FXFormFieldViewControllerProtocol {
    var field: FXFormField!


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
// MARK: - Table view data source

override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(self.field.optionCount())
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "SELECT_HOBBIES_CELL")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "SELECT_HOBBIES_CELL")
        }
        cell?.textLabel?.text = self.field.option(at: UInt(indexPath.row)) as! String?
        if self.field.isOptionSelected(at: UInt(indexPath.row)) {
            cell?.accessoryType = .checkmark
        }
        else {
            cell?.accessoryType = .none
        }
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        var count: Int = 0
        for i in 0..<self.field.optionCount() {
            if self.field.isOptionSelected(at: i) {
                count += 1
            }
        }
        if count > 3 {
            self.view.makeToast("Cannot select more than 3 hobbies", duration: 3.5, position: .bottom)
        }
        else {
            if self.field.isOptionSelected(at: UInt(indexPath.row)) {
                self.field.setOptionSelected(false, at: UInt(indexPath.row))
            }
            else {
                self.field.setOptionSelected(true, at: UInt(indexPath.row))
            }
            self.tableView.reloadData()
        }
    }
}
