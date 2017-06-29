//
//  TextFieldTableViewCell.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 6/6/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {
    private var textField = UITextField()
    private var onComplete: (() -> ()) = {
        
    }
    public var textInput: String? {
        get {
            return self.textField.text
        }
        set (newValue){
            self.textField.text = newValue
        }
    }
    
    func setup(placeholder: String? = nil, onComplete: @escaping (() -> ())) {
        self.textField.removeFromSuperview()
        self.textField.autocorrectionType = .no
        self.textField.autocapitalizationType = .none
        self.textField.returnKeyType = .done
        self.textField.frame = self.contentView.bounds
        self.textLabel?.text = ""
        self.accessoryType = .none
        self.textField.delegate = self
        self.contentView.addSubview(self.textField)
        self.textField.placeholder = placeholder
        self.textField.becomeFirstResponder()
        self.selectionStyle = .none
        self.onComplete = onComplete
    }
    
    override func becomeFirstResponder() -> Bool {
        return self.textField.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        self.onComplete()
        return self.textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.onComplete()
    }
    

}
