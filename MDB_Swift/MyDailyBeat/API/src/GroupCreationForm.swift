//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  GroupCreationForm.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/31/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import Foundation
import FXForms
public class GroupCreationForm: NSObject, FXForm {
    public var groupName: String = ""
    public var hobbies = [Bool]()


    func hobbiesField() -> [AnyHashable: Any] {
        return [FXFormFieldTitle: "Select Hobbies", FXFormFieldOptions: ["Books", "Golf", "Cars", "Walking", "Hiking", "Wine", "Woodworking", "Online Card Games", "Card Games", "Online Games", "Arts & Crafts", "Prayer", "Support Groups", "Shopping", "Travel", "Local Field Trips", "History", "Sports"], FXFormFieldViewController: "EVCGroupSettingsHobbiesSelectionTableViewController"]
    }

    public func extraFields() -> [Any] {
        return [[FXFormFieldTitle: "Create", FXFormFieldHeader: "", FXFormFieldAction: "createGroup:"]]
    }
}
