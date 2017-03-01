//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  RegisterObject1.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 9/18/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import Foundation
import FXForms
public class RegisterObject1: NSObject, FXForm {
    public var first: String = ""
    public var last: String = ""
    public var birthday: Date!
    public var zipcode: String = ""
    public var part2: RegisterForm2!


    func part2Field() -> [AnyHashable: Any] {
        return [FXFormFieldTitle: "Next >>>"]
    }

    func zipcodeField() -> [AnyHashable: Any] {
        return [FXFormFieldCell: "FXFormZipcodeCell"]
    }
}
