
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
class EVCGroupCreationTableViewController: UITableViewController, FXFormControllerDelegate {
    var formController: FXFormController!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.formController = FXFormController()
        self.formController.tableView = self.tableView
        self.formController.delegate = self
        self.formController.form = GroupCreationForm()
        self.navigationItem.title = "New Group"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    func createGroup(_ cell: FXFormBaseCell) {
        var frm: GroupCreationForm? = cell.field.form as? GroupCreationForm
        var name: String? = frm?.groupName
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.sideMenuViewController.contentViewController.view.makeToastActivity(.center)
            })
            var success: Bool = RestAPI.getInstance().createGroup(withName: name!)
            if frm?.hobbies != nil && (frm?.hobbies.count)! > 0 {
                var groups = RestAPI.getInstance().getGroupsForCurrentUser()
                for i in 0..<groups.count {
                    var g: Group? = groups[i]
                    if (g?.groupName == name) {
                        g?.hobbies = (frm?.hobbies)!
                        success = RestAPI.getInstance().setHobbiesforGroup(g!)
                        break
                    }
                }
            }
            DispatchQueue.main.async(execute: {() -> Void in
                self.sideMenuViewController.contentViewController.view.hideToastActivity()
                if success {
                    self.sideMenuViewController.contentViewController.view.makeToast("Group creation successful!", duration: 3.5, position: .bottom)
                }
                else {
                    self.sideMenuViewController.contentViewController.view.makeToast("Group creation failed!", duration: 3.5, position: .bottom)
                    return
                }
                self.navigationController?.dismiss(animated: true, completion: { _ in })
            })
        })
    }
}
