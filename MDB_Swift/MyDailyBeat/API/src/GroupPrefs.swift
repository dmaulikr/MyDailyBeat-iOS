//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  GroupPrefs.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/17/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//
import Foundation
import FXForms
public class GroupPrefs: NSObject, FXForm {
    public var groupPicture: UIImage!
    public var hobbies: [Int: Bool] = [Int: Bool]()

    public init(servingURL: String = "") {
        super.init()
        //self.loadPicture(withServingURL: servingURL)
    
    }


    func loadPicture(withServingURL servingURL: String) {
        
        DispatchQueue.global().async(execute: {() -> Void in
            let imageURL = URL(string: servingURL)
            let imageData: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imageURL!)
            DispatchQueue.main.async(execute: {() -> Void in
                // Update the UI
                self.groupPicture = UIImage(data: imageData!)
            })
        })
    }
    
    func toggleField(_ cell: FXFormBaseCell) {
        if let field = cell.field, let key = Int(field.key), let bool = field.value as? Bool {
            let trueCount = self.hobbies.filter({ (key, value) -> Bool in
                return value
            }).count
            if trueCount <= 3 && bool || !bool {
                self.hobbies[key] = bool
            }
            
        }
    }
    
    public func fields() -> [Any]! {
//        var fields: [Any] = [[FXFormFieldTitle: "Change Group Picture", FXFormFieldHeader: "", FXFormFieldAction: "saveImage:"]]
        var fields = [Any]()
        let masterList = HobbiesRefList.getInstance().list
        let action: ((Any?) -> ()) = { (input) in
            if let cell = input as? FXFormBaseCell {
                self.toggleField(cell)
            }
        }
        let realMasterList: [(key: Int, value: String)] = masterList.map { (key, value) -> (key: Int, value: String) in
            return (key: key, value: value)
        }
        for index in 0..<realMasterList.count {
            let item = realMasterList[index]
            var field: [String : Any] = [FXFormFieldTitle: item.value, FXFormFieldType: FXFormFieldTypeBoolean, FXFormFieldDefaultValue: hobbies[item.key] ?? false, FXFormFieldKey: "\(item.key)", FXFormFieldAction: action]
            if index == 0 {
                field[FXFormFieldHeader] = "Hobbies"
            }
            fields.append(field)
        }
        
        fields.append([FXFormFieldTitle: "Delete Group", FXFormFieldHeader: "", FXFormFieldAction: "deleteGroup:", "contentView.backgroundColor": UIColor.red, "textLabel.color": UIColor.white])
        return fields
    }
}
