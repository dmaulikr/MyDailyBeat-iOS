//
//  RegistrationScreenNameViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 3/20/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import UIKit
import EasyTipView
import API

class RegistrationScreenNameViewController: UIViewController {
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var screenNameField: UITextField!
    @IBOutlet var passField: UITextField!
    @IBOutlet var pass2Field: UITextField!
    @IBOutlet var userOuter: UITextField!
    @IBOutlet var passOuter: UITextField!
    @IBOutlet var pass2Outer: UITextField!
    var screenNameExists = false
    var tipView: EasyTipView =  EasyTipView(text: "Black ToolTip")
    var nextPage: (() -> ()) = {
        // empty by default
    }
    
    @IBAction func next(_ sender: Any) {
        guard isValidInput else {
            // TODO: Show error messages here.
            return
        }
        let obj = RegistrationObject.getInstance()
        obj.screenName = screenNameField.text!
        obj.password = passField.text!
        obj.verifiedPass = pass2Field.text!
        RegistrationObject.updateInstance(modified: obj)
        self.nextPage()
    }
    
    var isValidInput: Bool {
        var result = !self.screenNameExists
        guard allFieldsFilledIn else {
            return false
        }
        if let enteredPass = self.passField.text, let enteredPassVerification = self.pass2Field.text {
            result = (enteredPass == enteredPassVerification)
            result = result && (enteredPass.characters.count >= 6 && enteredPass.characters.count <= 20)
            result = result && (enteredPass.rangeOfCharacter(from: CharacterSet.alphanumerics) != nil)
        }
        return result
    }
    
    var allFieldsFilledIn: Bool {
        var result = false
        if let _ = self.screenNameField.text, let _ = self.passField.text, let _ = self.pass2Field.text {
            result = true
        }
        return result
    }
    
    override var nibName: String? {
        get {
            return "RegistrationScreenNameViewController"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenNameField.delegate = self
        self.passField.delegate = self
        self.pass2Field.delegate = self
        self.userOuter.delegate = DisableOuterField()
        self.passOuter.delegate = DisableOuterField()
        self.pass2Outer.delegate = DisableOuterField()
        self.screenNameField.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.pass2Field.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.passField.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.userOuter.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.passOuter.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.pass2Outer.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
        self.userOuter.layer.borderColor = UIColor.white.cgColor
        self.userOuter.layer.borderWidth = 2
        self.userOuter.layer.cornerRadius = 8
        self.userOuter.clipsToBounds = true
        self.passOuter.layer.borderColor = UIColor.white.cgColor
        self.passOuter.layer.borderWidth = 2
        self.passOuter.layer.cornerRadius = 8
        self.passOuter.clipsToBounds = true
        self.pass2Outer.layer.borderColor = UIColor.white.cgColor
        self.pass2Outer.layer.borderWidth = 2
        self.pass2Outer.layer.cornerRadius = 8
        self.pass2Outer.clipsToBounds = true
        
        self.screenNameField.layer.borderColor = UIColor.white.cgColor
        self.screenNameField.layer.borderWidth = 2
        self.screenNameField.layer.cornerRadius = 8
        self.screenNameField.clipsToBounds = true
        
        self.passField.layer.borderColor = UIColor.white.cgColor
        self.passField.layer.borderWidth = 2
        self.passField.layer.cornerRadius = 8
        self.passField.clipsToBounds = true
        
        self.pass2Field.layer.borderColor = UIColor.white.cgColor
        self.pass2Field.layer.borderWidth = 2
        self.pass2Field.layer.cornerRadius = 8
        self.pass2Field.clipsToBounds = true
        
        screenNameField.attributedPlaceholder = NSAttributedString(string: "Screen Name", attributes: [NSForegroundColorAttributeName: UIColor(netHex: 0x0097A4)])
        passField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor(netHex: 0x0097A4)])
        pass2Field.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSForegroundColorAttributeName: UIColor(netHex: 0x0097A4)])
    
        // Do any additional setup after loading the view.
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class DisableOuterField: NSObject, UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

extension RegistrationScreenNameViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.white
        if textField == self.screenNameField {
            if textField.text == "" {
                self.tipView = EasyTipView(text: "Please enter a screenName")
            } else {
                // show existing tipView
                
            }
            self.tipView.show(animated: true, forView: textField, withinSuperview: self.view)
        } else {
            self.tipView = EasyTipView(text: "Password must be a minimum of 6 characters long with at least one letter and one number. Maximum length 20 characters.")
            self.tipView.show(animated: true, forView: self.passField, withinSuperview: self.view)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        if textField == self.screenNameField {
            self.tipView.dismiss(withCompletion: { 
                // check if screenName exists
                DispatchQueue.global().async {
                    DispatchQueue.main.sync {
                        self.view.makeToastActivity(.center)
                    }
                    if let enteredScreenName = self.screenNameField.text {
                        self.screenNameExists = RestAPI.getInstance().doesUserExist(withScreenName: enteredScreenName)
                    }
                    DispatchQueue.main.sync {
                        self.view.hideToastActivity()
                    }
                }
            })
        } else {
            self.tipView.dismiss()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == screenNameField {
            passField.becomeFirstResponder()
        } else if textField == passField {
            pass2Field.becomeFirstResponder()
        }
        return false
    }
}
