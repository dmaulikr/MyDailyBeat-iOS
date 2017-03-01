
//
//  EVCRegistrationViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/18/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import UIKit
import Toast_Swift
import FXForms
import API
class EVCRegistrationViewController: UITableViewController, FXFormControllerDelegate {
    var formController: FXFormController!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.formController = FXFormController()
        self.formController.tableView = self.tableView
        self.formController.delegate = self
        let obj1 = RegisterObject1()
        self.formController.form = obj1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func submit(_ cell: FXFormBaseCell) {
        let frm: RegisterObject1? = self.formController.form as? RegisterObject1
        var result: Bool? = (frm?.first != nil) || !(frm?.first == "")
        result = result! && (frm?.last != nil) || !(frm?.last == "")
        result = result! && (frm?.birthday != nil)
        result = result! && (frm?.zipcode != nil) || !(frm?.zipcode == "")
        result = result! && (frm?.part2?.screenName != nil) || !(frm?.part2?.screenName == "")
        result = result! && (frm?.part2?.password != nil) || !(frm?.part2?.password == "")
        result = result! && (frm?.part2?.verifyPassword != nil) || !(frm?.part2?.verifyPassword == "")
        result = result! && (frm?.part2?.part3?.email != nil) || !(frm?.part2?.part3?.email == "")
        result = result! && (frm?.part2?.part3?.mobile != nil) || !(frm?.part2?.part3?.mobile == "")
        if result != nil {
            var pass: String? = frm?.part2?.password
            let numset = CharacterSet(charactersIn: "0123456789")
            var lset: String = "abcdefghijklmnopqrstuvwxyz"
            lset = lset + lset.uppercased()
            let abcset = CharacterSet(charactersIn: lset)
            result = ((pass?.characters.count ?? 0) >= 6 && (pass?.characters.count ?? 0) <= 20)
            result = result! && (!(pass?.rangeOfCharacter(from: numset)?.isEmpty)!)
            result = result! && (!(pass?.rangeOfCharacter(from: abcset)?.isEmpty)!)
            if result != nil {
                if (frm?.part2?.password == frm?.part2?.verifyPassword) {
                    let userExistsWithScreenName: Bool? = RestAPI.getInstance().doesUserExist(withScreenName: (frm?.part2?.screenName)!)
                    let userExistsWithEmail: Bool? = RestAPI.getInstance().doesUserExist(withEmail: (frm?.part2?.part3?.email)!)
                    let userExistsWithMobile: Bool? = RestAPI.getInstance().doesUserExist(withMobile: (frm?.part2?.part3?.mobile)!)
                    if !userExistsWithScreenName! && !userExistsWithEmail! && !userExistsWithMobile! {
                        let newuser = VerveUser()
                        newuser.name = "\(frm?.first) \(frm?.last)"
                        let gregorianCalendar = Calendar(identifier: .gregorian)
                        var bd: DateComponents? = gregorianCalendar.dateComponents([.month, .day, .year], from: (frm?.birthday)!)
                        let df = DateFormatter()
                        let monthName: String? = df.monthSymbols[((bd?.month)! - 1)]
                        newuser.birth_month = monthName!
                        newuser.birth_date = (bd?.day)!
                        newuser.birth_year = (bd?.year)!
                        newuser.zipcode = (frm?.zipcode)!
                        newuser.screenName = (frm?.part2?.screenName)!
                        newuser.password = (frm?.part2?.password)!
                        newuser.email = (frm?.part2?.part3?.email)!
                        newuser.mobile = (frm?.part2?.part3?.mobile)!
                        DispatchQueue.global().async(execute: {() -> Void in
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.view.makeToastActivity(ToastPosition.center)
                            })
                            let result: Bool = RestAPI.getInstance().createUser(newuser)
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.view.hideToastActivity()
                                if result {
                                    self.view.makeToast("User creation successful!", duration: 3.5, position: .bottom)
                                    UserDefaults.standard.set(newuser.screenName, forKey: KEY_SCREENNAME)
                                    UserDefaults.standard.set(newuser.password, forKey: KEY_PASSWORD)
                                    UserDefaults.standard.set(false, forKey: "FirstTimeLogin")
                                    _ = self.navigationController?.popViewController(animated: true)
                                }
                                else {
                                    self.view.makeToast("User creation failed!", duration: 3.5, position: .bottom)
                                    return
                                }
                            })
                        })
                    }
                    else {
                        if userExistsWithScreenName != nil {
                            self.view.makeToast("This screen name is unavailable.", duration: 3.5, position: .bottom)
                        }
                        else if userExistsWithEmail != nil {
                            self.view.makeToast("An account with this email address already exists.", duration: 3.5, position: .bottom)
                        }
                        else {
                            self.view.makeToast("An account with this mobile phone number already exists.", duration: 3.5, position: .bottom)
                        }
                    }
                }
                else {
                    self.view.makeToast("Passwords do not match.", duration: 3.5, position: .bottom)
                }
            }
            else {
                self.view.makeToast("Invalid password.", duration: 3.5, position: .bottom)
            }
        }
        else {
            self.view.makeToast("Required field not filled.", duration: 3.5, position: .bottom)
        }
    }
}
