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
        prefs.isBooks = array[0].boolValue
        prefs.isGolf = array[1].boolValue
        prefs.isCars = array[2].boolValue
        prefs.isWalking = array[3].boolValue
        prefs.isHiking = array[4].boolValue
        prefs.isWine = array[5].boolValue
        prefs.isWoodworking = array[6].boolValue
        prefs.isCardsonline = array[7].boolValue
        prefs.isCards = array[8].boolValue
        prefs.isGamesonline = array[9].boolValue
        prefs.isArts = array[10].boolValue
        prefs.isPrayer = array[11].boolValue
        prefs.isSupport = array[12].boolValue
        prefs.isShopping = array[13].boolValue
        prefs.isTravel = array[14].boolValue
        prefs.isLocalfieldtrips = array[15].boolValue
        prefs.isHistory = array[16].boolValue
        prefs.isSports = array[17].boolValue
        return prefs
    }

    class func toJSON(_ prefs: HobbiesPreferences) -> JSON {
        var array = [JSON]()
        array.append(JSON(prefs.isBooks.toInt()))
        array.append(JSON(Int(prefs.isGolf.toInt())))
        array.append(JSON(Int(prefs.isCars.toInt())))
        array.append(JSON(Int(prefs.isWalking.toInt())))
        array.append(JSON(Int(prefs.isHiking.toInt())))
        array.append(JSON(Int(prefs.isWine.toInt())))
        array.append(JSON(Int(prefs.isWoodworking.toInt())))
        array.append(JSON(Int(prefs.isCardsonline.toInt())))
        array.append(JSON(Int(prefs.isCards.toInt())))
        array.append(JSON(Int(prefs.isGamesonline.toInt())))
        array.append(JSON(Int(prefs.isArts.toInt())))
        array.append(JSON(Int(prefs.isPrayer.toInt())))
        array.append(JSON(Int(prefs.isSupport.toInt())))
        array.append(JSON(Int(prefs.isShopping.toInt())))
        array.append(JSON(Int(prefs.isTravel.toInt())))
        array.append(JSON(Int(prefs.isLocalfieldtrips.toInt())))
        array.append(JSON(Int(prefs.isHistory.toInt())))
        array.append(JSON(Int(prefs.isSports.toInt())))
        return JSON(array)
    }


    public func fields() -> [Any] {
        return [[FXFormFieldKey: "books", FXFormFieldTitle: "Books/Reading"], [FXFormFieldKey: "golf", FXFormFieldTitle: "Golf"], [FXFormFieldKey: "cars", FXFormFieldTitle: "Car Enthusiast"], [FXFormFieldKey: "walking", FXFormFieldTitle: "Walking"], [FXFormFieldKey: "hiking", FXFormFieldTitle: "Hiking"], [FXFormFieldKey: "wine", FXFormFieldTitle: "Wine Enthusiast"], [FXFormFieldKey: "woodworking", FXFormFieldTitle: "Woodworking"], [FXFormFieldKey: "cardsonline", FXFormFieldTitle: "Card Games - Online"], [FXFormFieldKey: "cards", FXFormFieldTitle: "Card Games"], [FXFormFieldKey: "gamesonline", FXFormFieldTitle: "Online Games"], [FXFormFieldKey: "arts", FXFormFieldTitle: "Arts & Crafts"], [FXFormFieldKey: "prayer", FXFormFieldTitle: "Prayer Group"], [FXFormFieldKey: "support", FXFormFieldTitle: "Support Group"], [FXFormFieldKey: "shopping", FXFormFieldTitle: "Shopping"], [FXFormFieldKey: "travel", FXFormFieldTitle: "Travel"], [FXFormFieldKey: "localfieldtrips", FXFormFieldTitle: "Local Interest Field Trips"], [FXFormFieldKey: "history", FXFormFieldTitle: "History"], [FXFormFieldKey: "sports", FXFormFieldTitle: "Sports"]]
    }
}
