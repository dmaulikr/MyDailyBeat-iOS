
//
//  EVCGroupSettingsViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/26/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import UIKit
import Toast_Swift
import API
import FXForms
protocol EVCGroupSettingsViewControllerDelegate {
    func evcGroupSettingsViewControllerDelegateDidDeleteGroup(_ controller: EVCGroupSettingsViewController)
}
class EVCGroupSettingsViewController: UIViewController, FXFormControllerDelegate {
    @IBOutlet var tableView: UITableView!
    var api: RestAPI!
    var formController: FXFormController!
    var g: Group!
    var handler: (() -> ()) = {
        
    }
    var delegate: EVCGroupSettingsViewControllerDelegate?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.formController = FXFormController()
        self.formController.tableView = self.tableView
        self.formController.delegate = self
        var prefs = GroupPrefs(servingURL: self.g.servingURL)
        prefs.hobbies = self.g.hobbies
        self.formController.form = prefs
        self.api = RestAPI.getInstance()
        var cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
        self.navigationItem.leftBarButtonItem = cancelBarButton
        var postBarButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.done))
        self.navigationItem.rightBarButtonItem = postBarButton
    }

    func cancel() {
        self.dismiss(animated: true, completion: { _ in })
    }

    func done() {
        self.dismiss(animated: true, completion: {() -> Void in
                // save group preferences
            var prefs: GroupPrefs? = self.formController.form as? GroupPrefs
            if (prefs?.hobbies.count)! > 3 {
                self.view.makeToast("Cannot select more than 3 hobbies", duration: 3.5, position: .bottom)
                return
            }
            var queue = DispatchQueue(label: "dispatch_queue_t_dialog")
            queue.async(execute: {() -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.makeToastActivity(ToastPosition.center)
                })
                self.g.hobbies = (prefs?.hobbies)!
                var success: Bool = self.api.setHobbiesforGroup(self.g)
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.hideToastActivity()
                    if success {
                        self.view.makeToast("Upload successful!", duration: 3.5, position: .bottom, title: nil, image: UIImage(named: "check.png"), style: nil, completion: nil)
                    }
                    else {
                        self.view.makeToast("Upload failed!", duration: 3.5, position: .bottom, title: nil, image: UIImage(named: "error.png"), style: nil, completion: nil)
                        return
                    }
                })
            })
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadGroupPicture()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadGroupPicture() {
        var queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            var imageURL: URL? = RestAPI.getInstance().retrieveGroupPicture(for: self.g)
            if imageURL == nil {
                return
            }
            var imageData: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imageURL!)
            DispatchQueue.main.async(execute: {() -> Void in
                    // Update the UI
                var prefs: GroupPrefs? = self.formController.form as? GroupPrefs
                prefs?.groupPicture = UIImage(data: imageData!)
            })
        })
    }

    func saveImage(_ cell: FXFormBaseCell) {
        var prefs: GroupPrefs? = self.formController.form as! GroupPrefs?
        var queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            var imgData: Data? = UIImagePNGRepresentation((prefs?.groupPicture)!)
            var fileName: String = ASSET_FILENAME
            var success: Bool = RestAPI.getInstance().uploadGroupPicture(imgData!, withName: fileName, to: self.g)
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                if success {
                    self.view.makeToast("Upload successful!", duration: 3.5, position: .bottom, title: nil, image: UIImage(named: "check.png"), style: nil, completion: nil)
                }
                else {
                    self.view.makeToast("Upload failed!", duration: 3.5, position: .bottom, title: nil, image: UIImage(named: "error.png"), style: nil, completion: nil)
                    return
                }
            })
        })
    }

    func deleteGroup(_ cell: FXFormBaseCell) {
        var queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            var success: Bool = RestAPI.getInstance().delete(group: self.g)
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                if success {
                    self.delegate?.evcGroupSettingsViewControllerDelegateDidDeleteGroup(self)
                }
                else {
                    print("Failed")
                }
            })
        })
    }
}
