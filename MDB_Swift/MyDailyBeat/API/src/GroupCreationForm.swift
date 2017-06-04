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
    
    func toggle(_ cell: FXFormBaseCell) {
        if let field = cell.field, let key = Int(field.key), let bool = field.value as? Bool {
            let values: [Bool] = hobbies.values.filter({ (val) -> Bool in
                return val
            })
            if bool && values.count <= 3 {
                self.hobbies[key] = bool
            } else if !bool {
                self.hobbies[key] = bool
            }
            
        }
    }


    public func fields() -> [Any]! {
        let masterList = HobbiesRefList.getInstance().list
        var fieldsList: [Any] = [[FXFormFieldTitle: "Group Name", FXFormFieldKey: "groupName"]]
        let action: ((Any?) -> ()) = { (input) in
            if let cell = input as? FXFormBaseCell {
                self.toggle(cell)
            }
        }
        let realList = masterList.map { (key, value) -> (key: Int, value: String) in
            return (key: key, value: value)
        }
        for index in 0..<realList.count {
            let item = realList[index]
            var field: [String : Any] = [FXFormFieldTitle: item.value, FXFormFieldType: FXFormFieldTypeBoolean, FXFormFieldDefaultValue: hobbies[item.key] ?? false, FXFormFieldKey: "\(item.key)", FXFormFieldAction: action]
            if index == 0 {
                field[FXFormFieldHeader] = "Select Hobbies"
            }
            fieldsList.append(field)
        }
        
        fieldsList.append([FXFormFieldTitle: "Create", FXFormFieldHeader: "", FXFormFieldAction: "createGroup:"])
        
        return fieldsList
    }

    public func extraFields() -> [Any] {
        return []
    }
}
