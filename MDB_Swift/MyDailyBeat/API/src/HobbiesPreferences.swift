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
    var isBooks: Bool = false
    var isGolf: Bool = false
    var isCars: Bool = false
    var isWalking: Bool = false
    var isHiking: Bool = false
    var isWine: Bool = false
    var isWoodworking: Bool = false
    var isCardsonline: Bool = false
    var isCards: Bool = false
    var isGamesonline: Bool = false
    var isArts: Bool = false
    var isPrayer: Bool = false
    var isSupport: Bool = false
    var isShopping: Bool = false
    var isTravel: Bool = false
    var isLocalfieldtrips: Bool = false
    var isHistory: Bool = false
    var isSports: Bool = false

    class func fromJSON(_ array: [JSON]) -> HobbiesPreferences {
        let prefs = HobbiesPreferences()
        guard array.count > 0 else {
            return prefs
        }
        prefs.isBooks = array[0]["yesno"].boolValue
        prefs.isGolf = array[1]["yesno"].boolValue
        prefs.isCars = array[2]["yesno"].boolValue
        prefs.isWalking = array[3]["yesno"].boolValue
        prefs.isHiking = array[4]["yesno"].boolValue
        prefs.isWine = array[5]["yesno"].boolValue
        prefs.isWoodworking = array[6]["yesno"].boolValue
        prefs.isCardsonline = array[7]["yesno"].boolValue
        prefs.isCards = array[8]["yesno"].boolValue
        prefs.isGamesonline = array[9]["yesno"].boolValue
        prefs.isArts = array[10]["yesno"].boolValue
        prefs.isPrayer = array[11]["yesno"].boolValue
        prefs.isSupport = array[12]["yesno"].boolValue
        prefs.isShopping = array[13]["yesno"].boolValue
        prefs.isTravel = array[14]["yesno"].boolValue
        prefs.isLocalfieldtrips = array[15]["yesno"].boolValue
        prefs.isHistory = array[16]["yesno"].boolValue
        prefs.isSports = array[17]["yesno"].boolValue
        return prefs
    }

    class func toJSON(_ prefs: HobbiesPreferences) -> JSON {
        var array = [JSON]()
        array.append(JSON(["id": 0, "yesno": prefs.isBooks]))
        array.append(JSON(["id": 1, "yesno": prefs.isGolf]))
        array.append(JSON(["id": 2, "yesno": prefs.isCars]))
        array.append(JSON(["id": 3, "yesno": prefs.isWalking]))
        array.append(JSON(["id": 4, "yesno": prefs.isHiking]))
        array.append(JSON(["id": 5, "yesno": prefs.isWine]))
        array.append(JSON(["id": 6, "yesno": prefs.isWoodworking]))
        array.append(JSON(["id": 7, "yesno": prefs.isCardsonline]))
        array.append(JSON(["id": 8, "yesno": prefs.isCards]))
        array.append(JSON(["id": 9, "yesno": prefs.isGamesonline]))
        array.append(JSON(["id": 10, "yesno": prefs.isArts]))
        array.append(JSON(["id": 11, "yesno": prefs.isPrayer]))
        array.append(JSON(["id": 12, "yesno": prefs.isSupport]))
        array.append(JSON(["id": 13, "yesno": prefs.isShopping]))
        array.append(JSON(["id": 14, "yesno": prefs.isTravel]))
        array.append(JSON(["id": 15, "yesno": prefs.isLocalfieldtrips]))
        array.append(JSON(["id": 16, "yesno": prefs.isHistory]))
        array.append(JSON(["id": 17, "yesno": prefs.isSports]))
        return JSON(array)
    }


    public func fields() -> [Any] {
        return [[FXFormFieldKey: "isBooks", FXFormFieldTitle: "Books/Reading"], [FXFormFieldKey: "isGolf", FXFormFieldTitle: "Golf"], [FXFormFieldKey: "isCars", FXFormFieldTitle: "Car Enthusiast"], [FXFormFieldKey: "isWalking", FXFormFieldTitle: "Walking"], [FXFormFieldKey: "isHiking", FXFormFieldTitle: "Hiking"], [FXFormFieldKey: "isWine", FXFormFieldTitle: "Wine Enthusiast"], [FXFormFieldKey: "isWoodworking", FXFormFieldTitle: "Woodworking"], [FXFormFieldKey: "isCardsonline", FXFormFieldTitle: "Card Games - Online"], [FXFormFieldKey: "isCards", FXFormFieldTitle: "Card Games"], [FXFormFieldKey: "isGamesonline", FXFormFieldTitle: "Online Games"], [FXFormFieldKey: "isArts", FXFormFieldTitle: "Arts & Crafts"], [FXFormFieldKey: "isPrayer", FXFormFieldTitle: "Prayer Group"], [FXFormFieldKey: "isSupport", FXFormFieldTitle: "Support Group"], [FXFormFieldKey: "isShopping", FXFormFieldTitle: "Shopping"], [FXFormFieldKey: "isTravel", FXFormFieldTitle: "Travel"], [FXFormFieldKey: "isLocalfieldtrips", FXFormFieldTitle: "Local Interest Field Trips"], [FXFormFieldKey: "isHistory", FXFormFieldTitle: "History"], [FXFormFieldKey: "isSports", FXFormFieldTitle: "Sports"]]
    }
}
