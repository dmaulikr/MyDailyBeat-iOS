//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  VerveMatchingPreferences.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/13/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//
import Foundation
import FXForms
import SwiftyJSON
public class VerveMatchingPreferences: NSObject, FXForm {
    public var gender: Int = 0
    public var age: Int = 0
    public var status: Int = 0
    public var ethnicity: Int = 0
    public var beliefs: Int = 0
    public var drinker: Int = 0
    public var isSmoker: Bool = false
    public var isVeteran: Bool = false

    func toJSON() -> JSON {
        var dic = [String: JSON]()
        dic["gender"] = JSON(self.gender)
        dic["age"] = JSON(self.age)
        dic["status"] = JSON(self.status)
        dic["ethnicity"] = JSON(self.ethnicity)
        dic["drinker"] = JSON(self.drinker)
        dic["beliefs"] = JSON(self.beliefs)
        dic["smoker"] = JSON(self.isSmoker)
        dic["veteran"] = JSON(self.isVeteran)
        return JSON(dic)
    }


    func genderField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: GENDER_STRING_LIST]
    }

    func statusField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: STATUS_STRING_LIST]
    }

    func ethnicityField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: ETHNICITY_STRING_LIST_2]
    }

    func drinkerField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: DRINKER_STRING_LIST]
    }

    func beliefsField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: BELIEFS_STRING_LIST_2]
    }

    func ageField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: AGE_STRING_LIST]
    }
}
