//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  RegisterForm2.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 9/18/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import Foundation
import FXForms
public class RegisterForm2: NSObject, FXForm {
    public var screenName: String = ""
    public var text1: String = ""
    public var text2: String = ""
    public var password: String = ""
    public var verifyPassword: String = ""
    public var part3: RegisterForm3!


    override init() {
        super.init()
        
        self.text1 = "Please note, only your screen name will be visible when you are engaging in the social sections."
        self.text2 = "Password must be a minimum of 6 characters long with at least one letter and one number. Maximum length 20 characters."
    
    }

    func part3Field() -> [AnyHashable: Any] {
        return [FXFormFieldTitle: "Next >>>"]
    }

    func text1Field() -> [AnyHashable: Any] {
        return [FXFormFieldCell: "FXFormTextCell"]
    }

    func text2Field() -> [AnyHashable: Any] {
        return [FXFormFieldCell: "FXFormTextCell"]
    }

    func screenNameField() -> [AnyHashable: Any] {
        return [FXFormFieldCell: "FXFormScreenNameCell"]
    }
}
