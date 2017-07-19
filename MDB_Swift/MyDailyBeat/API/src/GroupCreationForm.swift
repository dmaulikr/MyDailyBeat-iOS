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
    public var hobbies: [Int: Bool] = [Int: Bool]()
    
    public func toggle(key: Int, value: Bool) {
        let values: [Bool] = hobbies.values.filter({ (val) -> Bool in
            return val
        })
        if value && values.count < 3 {
            self.hobbies[key] = value
        } else if !value {
            self.hobbies[key] = value
        }
    }
}
