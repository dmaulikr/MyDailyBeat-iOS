
//
//  EVCFirstTimeSetupViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 7/12/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import UIKit
import Toast_Swift
import API
class EVCFirstTimeSetupViewController: UIViewController {
    var api: RestAPI!
    @IBOutlet var message: UILabel!
    @IBOutlet var nextButton: UIButton!

    @IBAction func next(_ sender: Any) {
        var prefs = VervePreferences()
        var queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            prefs.userPreferences = self.api.getUserPreferences(for: self.api.getCurrentUser())
            prefs.matchingPreferences = self.api.getMatchingPreferences(for: self.api.getCurrentUser())
            prefs.hobbiesPreferences = self.api.getHobbiesPreferencesForUser(withScreenName: self.api.getCurrentUser().screenName)
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                var prefsView = EVCFirstTimePreferencesViewController(nibName: "EVCFirstTimePreferencesViewController", bundle: nil)
                self.navigationController?.pushViewController(prefsView, animated: true)
            })
        })
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        api = RestAPI.getInstance()
        self.message.text = "Welcome to MyDailyBeat! Before you begin, please set the following preferences."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
