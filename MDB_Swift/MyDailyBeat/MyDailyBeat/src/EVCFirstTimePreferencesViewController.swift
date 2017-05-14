
//
//  EVCFirstTimePreferencesViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 7/12/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import UIKit
import Toast_Swift
import API
import FXForms
class EVCFirstTimePreferencesViewController: UIViewController, FXFormControllerDelegate {
    @IBOutlet var tableView: UITableView!
    var prefs: VervePreferences?
    var api: RestAPI!
    var formController: FXFormController!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.formController = FXFormController()
        self.formController.tableView = self.tableView
        self.formController.delegate = self
        self.formController.form = VervePreferences()
        api = RestAPI.getInstance()
        self.retrievePrefs()
    }

    func retrievePrefs() {
        
        DispatchQueue.global().async(execute: {() -> Void in
            var prefs = VervePreferences()
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            self.prefs?.userPreferences = self.api.getUserPreferences()
            self.prefs?.matchingPreferences = self.api.getMatchingPreferences()
            self.prefs?.hobbiesPreferences = self.api.getHobbiesPreferencesForUser()
            self.formController.form = self.prefs
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.tableView.reloadData()
            })
        })
    }

    

    func selectEthnicity(_ cell: FXFormBaseCell) {
        let prefs: VervePreferences? = cell.field.form as? VervePreferences
        self.formController.form = prefs
        self.tableView.reloadData()
    }

    func selectBeliefs(_ cell: FXFormBaseCell) {
        let prefs: VervePreferences? = cell.field.form as! VervePreferences?
        self.formController.form = prefs
        self.tableView.reloadData()
    }

    func submit(_ cell: FXFormBaseCell) {
        var prefs: VervePreferences? = cell.field.form as! VervePreferences?
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            var success: Bool = self.api.save(self.prefs!.userPreferences, andMatchingPreferences: self.prefs!.matchingPreferences)
            var success2: Bool = self.api.save(self.prefs!.hobbiesPreferences)
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                if success && success2 {
                    UserDefaults.standard.set(false, forKey: "FirstTimeLogin")
                    _ = self.navigationController?.popToRootViewController(animated: true)
                }
                else {
                    print("Failed")
                }
            })
        })
    }
}
