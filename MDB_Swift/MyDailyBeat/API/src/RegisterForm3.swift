//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  RegisterForm3.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 9/18/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import Foundation
import FXForms
public class RegisterForm3: NSObject, FXForm {
    public var text1: String = ""
    public var text2: String = ""
    public var email: String = ""
    public var mobile: String = ""
    public var text3: String = ""


    override init() {
        super.init()
        
        self.text1 = "You are one click away from becoming an official member!"
        self.text2 = "So we can verify your membership, please provide the following."
        self.text3 = "(Additional text charges may apply based on your calling plan.)"
    
    }

    public func extraFields() -> [Any] {
        return [[FXFormFieldTitle: "Create User", FXFormFieldAction: "submit:"]]
    }

    func text1Field() -> [AnyHashable: Any] {
        return [FXFormFieldCell: "FXFormTextCell"]
    }

    func text2Field() -> [AnyHashable: Any] {
        return [FXFormFieldCell: "FXFormTextCell"]
    }

    func text3Field() -> [AnyHashable: Any] {
        return [FXFormFieldCell: "FXFormTextCell"]
    }

    func mobileField() -> [AnyHashable: Any] {
        return [FXFormFieldType: FXFormFieldTypePhone]
    }
}
