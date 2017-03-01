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
    public var hobbies = [Bool]()

    public init(servingURL: String) {
        super.init()
        self.loadPicture(withServingURL: servingURL)
    
    }


    func loadPicture(withServingURL servingURL: String) {
        let queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            let imageURL = URL(string: servingURL)
            let imageData: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imageURL!)
            DispatchQueue.main.async(execute: {() -> Void in
                // Update the UI
                self.groupPicture = UIImage(data: imageData!)
            })
        })
    }

    func groupPictureField() -> [AnyHashable: Any] {
        return [FXFormFieldTitle: "Change Group Picture", FXFormFieldAction: "saveImage:"]
    }

    func hobbiesField() -> [AnyHashable: Any] {
        return [FXFormFieldTitle: "Select Hobbies", FXFormFieldOptions: ["Books", "Golf", "Cars", "Walking", "Hiking", "Wine", "Woodworking", "Online Card Games", "Card Games", "Online Games", "Arts & Crafts", "Prayer", "Support Groups", "Shopping", "Travel", "Local Field Trips", "History", "Sports"], FXFormFieldViewController: "EVCGroupSettingsHobbiesSelectionTableViewController"]
    }

    public func extraFields() -> [Any] {
        return [[FXFormFieldTitle: "Delete Group", FXFormFieldHeader: "", FXFormFieldAction: "deleteGroup:", "contentView.backgroundColor": UIColor.red, "textLabel.color": UIColor.white]]
    }
}
