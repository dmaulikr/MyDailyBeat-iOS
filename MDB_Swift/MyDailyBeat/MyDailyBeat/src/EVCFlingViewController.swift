
//
//  EVCFlingViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/21/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import UIKit
import API
import DLAlertView
class EVCFlingViewController: UITabBarController, UITabBarControllerDelegate {
    var mode: REL_MODE = .friends_MODE

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UserDefaults.standard.set(self.mode, forKey: "REL_MODE")
        var title: String = ""
        switch self.mode {
            case .friends_MODE:
                title = "Make Friends"
            case .fling_MODE:
                title = "Have a Fling"
            case .relationship_MODE:
                title = "Start a Relationship"
        }

        self.navigationItem.title = title
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func flingProf() {
        var queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                var alert = UIAlertController(title: "Create your Profile", message: "To fully enjoy all the features of MyDailyBeat, you need to create a relationship profile. This unified profile is used across the Have a Fling, Start a Relationship, and Make Friends sections of this app.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.performSegue(withIdentifier: "EditProfileSegue", sender: nil)
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            })
        })
    }
    
    func filter() {
        
    }
}
