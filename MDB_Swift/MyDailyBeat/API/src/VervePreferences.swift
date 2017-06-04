//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  VervePreferences.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/17/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//
import UIKit
import FXForms
public class VervePreferences: NSObject, FXForm {
    public var userPreferences: VerveUserPreferences?
    public var matchingPreferences: VerveMatchingPreferences?
    public var hobbiesPreferences: HobbiesPreferences?
    
    public func fields() -> [Any]! {
        return [[FXFormFieldTitle: "User Preferences", FXFormFieldHeader: "", FXFormFieldKey: "userPreferences"],
                [FXFormFieldTitle: "Matching Preferences", FXFormFieldKey: "matchingPreferences"],
                [FXFormFieldTitle: "Hobbies Preferences", FXFormFieldKey: "hobbiesPreferences"],
                [FXFormFieldTitle: "Save", FXFormFieldHeader: "", FXFormFieldAction: "submit:"]
        ]
    }
}
