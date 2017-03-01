
//
//  EVCFlingProfileCreatorViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 1/4/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//
import UIKit
import Toast_Swift
import API
class EVCFlingProfileCreatorViewController: UIViewController {
    @IBOutlet var aboutMeView: UITextView!
    @IBOutlet var okButton: UIButton!
    var mode: REL_MODE = .friends_MODE

    @IBAction func save(_ sender: Any) {
        let about: String = self.aboutMeView.text
        let queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            let prefs: VerveUserPreferences? = RestAPI.getInstance().getUserPreferences(for: RestAPI.getInstance().getCurrentUser())
            let age: Int? = prefs?.age
            _ = RestAPI.getInstance().saveFlingProfile(for: RestAPI.getInstance().getCurrentUser(), withAge: age!, andDescription: about)
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
//                if success {
//                    self.view.makeToast("Upload successful!", duration: 3.5, position: .bottom, image: UIImage(named: "check.png"))
//                    self.navigationController?.popViewController(animated: true)
//                }
//                else {
//                    self.view.makeToast("Upload failed!", duration: 3.5, position: .bottom, image: UIImage(named: "error.png"))
//                    return
//                }
            })
        })
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.mode = REL_MODE(rawValue: Int(UserDefaults.standard.integer(forKey: "REL_MODE")))!
        self.navigationItem.title = "Edit Fling Profile"
        self.aboutMeView.layer.borderWidth = 1.0
        self.aboutMeView.layer.borderColor = UIColor(netHex: 0x0097a4).cgColor
        self.aboutMeView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
    }
}
