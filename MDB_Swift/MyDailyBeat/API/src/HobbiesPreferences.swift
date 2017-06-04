//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  HobbiesPreferences.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 6/14/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import Foundation
import FXForms
import SwiftyJSON
public class HobbiesPreferences: NSObject, FXForm {
    open var hobbies: [Int: Bool] = [Int: Bool]()

    class func fromJSON(_ array: [JSON]) -> HobbiesPreferences {
        let prefs = HobbiesPreferences()
        let masterList = HobbiesRefList.getInstance().list.map { (key, value) -> Int in
            return key
        }
        guard array.count > 0 else {
            for hobby in masterList {
                prefs.hobbies[hobby] = false
            }
            return prefs
        }
        
        let myList = array.map { (json) -> Int in
            return json.intValue
        }
        
        for hobby in masterList {
            prefs.hobbies[hobby] = myList.contains(hobby)
        }
        return prefs
    }

    class func toJSON(_ prefs: HobbiesPreferences) -> JSON {
        let on = prefs.hobbies.filter { (key, value) -> Bool in
            return value
        }
        return JSON(on.map({ (key, value) -> Int in
            return key
        }))
    }
    
    func toggle(_ cell: FXFormBaseCell) {
        if let field = cell.field, let key = Int(field.key), let bool = field.value as? Bool {
            self.hobbies[key] = bool
        }
    }
    
    public func fields() -> [Any]! {
        let masterList = HobbiesRefList.getInstance().list
        var fieldsList: [Any] = []
        let action: ((Any?) -> ()) = { (input) in
            if let cell = input as? FXFormBaseCell {
                self.toggle(cell)
            }
        }
        for item in masterList {
            let field: [String : Any] = [FXFormFieldTitle: item.value, FXFormFieldType: FXFormFieldTypeBoolean, FXFormFieldDefaultValue: hobbies[item.key] ?? false, FXFormFieldKey: "\(item.key)", FXFormFieldAction: action]
            fieldsList.append(field)
        }
        
        return fieldsList
    }
}
