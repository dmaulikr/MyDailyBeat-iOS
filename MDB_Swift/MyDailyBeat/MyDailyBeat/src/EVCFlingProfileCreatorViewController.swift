
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
    var isModal: Bool = false
    var mode: REL_MODE = .friends_MODE

    @IBAction func save(_ sender: Any) {
        let about: String = self.aboutMeView.text
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            let success = RestAPI.getInstance().saveFlingProfile(for: RestAPI.getInstance().getCurrentUser(), andDescription: about)
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
    }
}
