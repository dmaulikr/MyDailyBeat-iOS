
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
class EVCPreferencesViewController: UIViewController, FXFormControllerDelegate {
    @IBOutlet var tableView: UITableView!
    var api: RestAPI!
    var formController: FXFormController!

    override func viewDidLoad() {
        super.viewDidLoad()
        api = RestAPI.getInstance()
        self.formController = FXFormController()
        self.formController.tableView = self.tableView
        self.formController.delegate = self
        self.formController.form = VervePreferences()
        self.retrievePrefs()
    }

    func selectEthnicity(_ cell: FXFormBaseCell) {
        let prefs: VervePreferences? = cell.field.form as! VervePreferences?
        self.formController.form = prefs
        self.tableView.reloadData()
    }

    func selectBeliefs(_ cell: FXFormBaseCell) {
        let prefs: VervePreferences? = cell.field.form as! VervePreferences?
        self.formController.form = prefs
        self.tableView.reloadData()
    }

    func retrievePrefs() {
        
        DispatchQueue.global().async(execute: {() -> Void in
            let prefs = VervePreferences()
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            prefs.userPreferences = self.api.getUserPreferences()
            prefs.matchingPreferences = self.api.getMatchingPreferences()
            prefs.hobbiesPreferences = self.api.getHobbiesPreferencesForUser()
            self.formController.form = prefs
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.tableView.reloadData()
            })
        })
    }

    func submit(_ cell: FXFormBaseCell) {
        let prefs: VervePreferences? = cell.field.form as! VervePreferences?
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            let success: Bool = self.api.save((prefs?.userPreferences)!, andMatchingPreferences: (prefs?.matchingPreferences)!)
            let success2 = self.api.save((prefs?.hobbiesPreferences)!)
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                if success && success2 {
                    _ = self.sideMenuViewController.contentViewController.navigationController?.popToRootViewController(animated: true)
                }
                else {
                    print("Failed")
                }
            })
        })
    }

    

    
}
