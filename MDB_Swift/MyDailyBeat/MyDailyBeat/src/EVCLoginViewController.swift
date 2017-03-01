
//
//  EVCLoginViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/18/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import UIKit
import Toast_Swift
import API
import RESideMenu
class EVCLoginViewController: UIViewController {

    @IBOutlet var header: UIImageView!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var userNameFeild: UITextField!
    @IBOutlet var passWordFeild: UITextField!

    @IBAction func login(_ sender: Any) {
        let username: String = userNameFeild.text!
        let pass: String = passWordFeild.text!
        let queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            var groups = [Any]()
            let success: Bool = RestAPI.getInstance().login(withScreenName: username, andPassword: pass)
            if success {
                //groups = RestAPI.getInstance().getGroupsForCurrentUser()
                DispatchQueue.main.async(execute: {() -> Void in
                    UserDefaults.standard.set(username, forKey: KEY_SCREENNAME)
                    UserDefaults.standard.set(pass, forKey: KEY_PASSWORD)
                    self.view.hideToastActivity()
                    
                    self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                })
            }
            else {
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.hideToastActivity()
                    self.view.makeToast("Username and password do not match.", duration: 3.5, position: .bottom)
                })
            }
        })
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view?.backgroundColor = UIColor.clear
        header.image = UIImage(named: "Logo.png")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadLoginData()
    }

    func loadLoginData() {
        let queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            let defScreenName: String? = UserDefaults.standard.string(forKey: KEY_SCREENNAME)
            let defPass: String? = UserDefaults.standard.string(forKey: KEY_PASSWORD)
            var groups = [Any]()
            if defScreenName != nil {
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.makeToastActivity(ToastPosition.center)
                })
                _ = RestAPI.getInstance().login(withScreenName: defScreenName!, andPassword: defPass!)
                //groups = RestAPI.getInstance().getGroupsForCurrentUser()
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.hideToastActivity()
                    self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                })
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
