
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
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var userNameFeild: UITextField!
    @IBOutlet var passWordFeild: UITextField!
    @IBOutlet var userOuter: UITextField!
    @IBOutlet var passOuter: UITextField!
    var seguePerformer: ((String, Any?) -> ())? = nil

    @IBAction func login(_ sender: Any) {
        let username: String = userNameFeild.text!
        let pass: String = passWordFeild.text!
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            let verified = RestAPI.getInstance().isUserVerified(screenName: username, password: pass)
            if verified {
                let success: Bool = RestAPI.getInstance().login(withScreenName: username, andPassword: pass)
                if success {
                    DispatchQueue.main.async(execute: {() -> Void in
                        UserDefaults.standard.set(username, forKey: KEY_SCREENNAME)
                        UserDefaults.standard.set(pass, forKey: KEY_PASSWORD)
                        self.view.hideToastActivity()
                        if let performer = self.seguePerformer {
                            performer("LoginSegue", nil)
                        }
                    })
                } else {
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.hideToastActivity()
                        self.view.makeToast("Username and password do not match.", duration: 3.5, position: .bottom)
                    })
                }
            } else {
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.hideToastActivity()
                    let alert = UIAlertController(title: "Verify your user information.", message: "You must verify your user information before logging in. Check the email you used to register.", preferredStyle: .alert)
                    let okaction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okaction)
                    let resendAction = UIAlertAction(title: "Re-send Activation Email", style: .default, handler: { (action) in
                        DispatchQueue.global().async {
                            RestAPI.getInstance().resendEmail(screenName: username, password: pass)
                        }
                    })
                    alert.addAction(resendAction)
                    self.present(alert, animated: true, completion: nil)
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
        userNameFeild.attributedPlaceholder = NSAttributedString(string: "Screen Name", attributes: [NSForegroundColorAttributeName: UIColor(netHex: 0x0097A4)])
        passWordFeild.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor(netHex: 0x0097A4)])
        userNameFeild.delegate = self
        passWordFeild.delegate = self
        userNameFeild.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        passWordFeild.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        userOuter.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        passOuter.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        userOuter.layer.borderWidth = 2
        userOuter.layer.borderColor = UIColor.white.cgColor
        userOuter.layer.cornerRadius = 8
        userOuter.clipsToBounds = true
        passOuter.clipsToBounds = true
        passOuter.layer.borderWidth = 2
        passOuter.layer.borderColor = UIColor.white.cgColor
        passOuter.layer.cornerRadius = 8
        userNameFeild.layer.borderColor = UIColor.white.cgColor
        userNameFeild.layer.cornerRadius = 8
        userNameFeild.clipsToBounds = true
        passWordFeild.clipsToBounds = true
        passWordFeild.layer.borderWidth = 2
        passWordFeild.layer.borderColor = UIColor.white.cgColor
        passWordFeild.layer.cornerRadius = 8
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadLoginData()
    }

    func loadLoginData() {
        
        DispatchQueue.global().async(execute: {() -> Void in
            let defScreenName: String? = UserDefaults.standard.string(forKey: KEY_SCREENNAME)
            let defPass: String? = UserDefaults.standard.string(forKey: KEY_PASSWORD)
            if defScreenName != nil {
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.makeToastActivity(ToastPosition.center)
                })
                let verified = RestAPI.getInstance().isUserVerified(screenName: defScreenName!, password: defPass!)
                if verified {
                    _ = RestAPI.getInstance().login(withScreenName: defScreenName!, andPassword: defPass!)
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.hideToastActivity()
                        if let performer = self.seguePerformer {
                            performer("LoginSegue", nil)
                        }
                    })
                } else {
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.hideToastActivity()
                        let alert = UIAlertController(title: "Verify your user information.", message: "You must verify your user information before logging in. Check the email you used to register.", preferredStyle: .alert)
                        let okaction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(okaction)
                        let resendAction = UIAlertAction(title: "Re-send Activation Email", style: .default, handler: { (action) in
                            DispatchQueue.global().async {
                                RestAPI.getInstance().resendEmail(screenName: defScreenName!, password: defPass!)
                            }
                        })
                        alert.addAction(resendAction)
                        self.present(alert, animated: true, completion: nil)
                    })
                }
                
            }
        })
    }

    
}

extension EVCLoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.white
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.7)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameFeild {
            self.userNameFeild.resignFirstResponder()
            self.passWordFeild.becomeFirstResponder()
        } else {
            self.passWordFeild.resignFirstResponder()
        }
        return false
    }
}
