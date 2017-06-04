
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func retrievePrefs() {
        
        DispatchQueue.global().async(execute: {() -> Void in
            var prefs = VervePreferences()
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
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    print("Failed")
                }
            })
        })
    }
}
