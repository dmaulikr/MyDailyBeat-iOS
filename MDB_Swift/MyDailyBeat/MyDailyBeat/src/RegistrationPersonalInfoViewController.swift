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

let START_INTERVAL: TimeInterval = -3773952000
let END_INTERVAL  : TimeInterval = -660441600

class RegistrationPersonalInfoViewController: UIViewController {
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var firstField: UITextField!
    @IBOutlet var lastField: UITextField!
    @IBOutlet var dobField: UITextField!
    @IBOutlet var firstOuter: UITextField!
    @IBOutlet var lastOuter: UITextField!
    @IBOutlet var dobOuter: UITextField!
    @IBOutlet var picker: UIDatePicker!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var doneButton: UIBarButtonItem!
    var userExists = false
    var birthDay: Date = Date()
    var tipView: EasyTipView =  EasyTipView(text: "ToolTip")
    var nextPage: (() -> ()) = {
        // empty by default
    }
    
    @IBAction func next(_ sender: Any) {
        guard isValidInput else {
            // TODO: Show error messages here.
            return
        }
        let obj = RegistrationObject.getInstance()
        obj.fname = firstField.text!
        obj.lname = lastField.text!
        obj.birthday = self.birthDay
        RegistrationObject.updateInstance(modified: obj)
        self.nextPage()
    }
    
    var isValidInput: Bool {
        let result = !userExists
        guard allFieldsFilledIn else {
            return false
        }
        
        return result
    }
    
    var allFieldsFilledIn: Bool {
        var result = false
        if let _ = self.firstField.text, let _ = self.lastField.text, let _ = self.dobField.text {
            result = true
        }
        return result
    }
    
    override var nibName: String? {
        get {
            return "RegistrationPersonalInfoViewController"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstField.delegate = self
        self.lastField.delegate = self
        self.dobField.delegate = self
        self.firstField.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.dobField.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.lastField.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.firstOuter.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.lastOuter.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.dobOuter.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
        self.firstOuter.layer.borderColor = UIColor.white.cgColor
        self.firstOuter.layer.borderWidth = 2
        self.firstOuter.layer.cornerRadius = 8
        self.firstOuter.clipsToBounds = true
        self.lastOuter.layer.borderColor = UIColor.white.cgColor
        self.lastOuter.layer.borderWidth = 2
        self.lastOuter.layer.cornerRadius = 8
        self.lastOuter.clipsToBounds = true
        self.dobOuter.layer.borderColor = UIColor.white.cgColor
        self.dobOuter.layer.borderWidth = 2
        self.dobOuter.layer.cornerRadius = 8
        self.dobOuter.clipsToBounds = true
        
        self.firstField.layer.borderColor = UIColor.white.cgColor
        self.firstField.layer.borderWidth = 2
        self.firstField.layer.cornerRadius = 8
        self.firstField.clipsToBounds = true
        
        self.lastField.layer.borderColor = UIColor.white.cgColor
        self.lastField.layer.borderWidth = 2
        self.lastField.layer.cornerRadius = 8
        self.lastField.clipsToBounds = true
        
        self.dobField.layer.borderColor = UIColor.white.cgColor
        self.dobField.layer.borderWidth = 2
        self.dobField.layer.cornerRadius = 8
        self.dobField.clipsToBounds = true
        
        firstField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSForegroundColorAttributeName: UIColor(netHex: 0x0097A4)])
        lastField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSForegroundColorAttributeName: UIColor(netHex: 0x0097A4)])
        dobField.attributedPlaceholder = NSAttributedString(string: "Date of Birth", attributes: [NSForegroundColorAttributeName: UIColor(netHex: 0x0097A4)])
        dobField.inputView = self.picker
        dobField.inputAccessoryView = self.toolbar
        self.picker.datePickerMode = .date
        self.picker.minimumDate = Date(timeInterval: START_INTERVAL, since: Calendar.current.startOfDay(for: Date()))
        self.picker.maximumDate = Date(timeInterval: END_INTERVAL, since: Calendar.current.startOfDay(for: Date()))
        self.birthDay = self.picker.date
        self.picker.addTarget(self, action: #selector(didSelect), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    
    func didSelect(picker: UIDatePicker) {
        self.birthDay = picker.date
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .medium
        self.dobField.text = formatter.string(from: self.birthDay)
    }

    @IBAction func done() {
        self.birthDay = self.picker.date
        self.dobField.resignFirstResponder()
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

extension RegistrationPersonalInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.white
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        if textField == self.dobField {
            self.birthDay = self.picker.date
        } else {
            if let firstName = self.firstField.text, let lastName = self.lastField.text {
                DispatchQueue.global().async {
                    DispatchQueue.main.sync {
                        self.view.makeToastActivity(.center)
                    }
                    let name = String(format: "%@ %@", firstName, lastName)
                    self.userExists = RestAPI.getInstance().doesUserExist(withName: name)
                    DispatchQueue.main.sync {
                        self.view.hideToastActivity()
                    }
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == firstField {
            lastField.becomeFirstResponder()
        }
        return false
    }
}
