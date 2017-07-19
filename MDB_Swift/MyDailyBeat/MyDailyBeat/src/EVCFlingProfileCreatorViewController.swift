
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
    var isModal: Bool = false
    var mode: REL_MODE = .friends_MODE

    func save() {
        let about: String = self.aboutMeView.text
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            let success: Bool
            if self.mode == .fling_MODE {
                success = RestAPI.getInstance().saveFlingProfile(for: RestAPI.getInstance().getCurrentUser(), andDescription: about)
            } else if self.mode == .relationship_MODE {
                success = RestAPI.getInstance().saveRelationshipProfile(for: RestAPI.getInstance().getCurrentUser(), andDescription: about)
            } else {
                success = RestAPI.getInstance().saveFriendsProfile(for: RestAPI.getInstance().getCurrentUser(), andDescription: about)
            }
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                if success {
                    self.view.makeToast("Upload successful!", duration: 3.5, position: .bottom, title: nil, image: UIImage(named: "check.png"), style: nil, completion: nil)
                    if self.isModal {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                }
                else {
                    self.view.makeToast("Upload failed!", duration: 3.5, position: .bottom, title: nil, image: UIImage(named: "error.png"), style: nil, completion: nil)
                    return
                }
            })
        })
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Edit Fling Profile"
        self.aboutMeView.layer.borderWidth = 1.0
        self.aboutMeView.layer.borderColor = UIColor(netHex: 0x0097a4).cgColor
        self.aboutMeView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
        self.loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let save = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.save))
        self.navigationItem.rightBarButtonItem = save
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func loadData() {
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            let profile: FlingProfile
            if self.mode == .fling_MODE {
                profile = RestAPI.getInstance().getFlingProfile(for: RestAPI.getInstance().getCurrentUser())
            } else if self.mode == .relationship_MODE {
                profile = RestAPI.getInstance().getRelationshipProfile(for: RestAPI.getInstance().getCurrentUser())
            } else {
                profile = RestAPI.getInstance().getFriendsProfile(for: RestAPI.getInstance().getCurrentUser())
            }
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.aboutMeView.text = profile.aboutMe
            })
        })
    }
}
