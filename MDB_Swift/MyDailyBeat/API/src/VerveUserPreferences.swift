//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  VerveUserPreferences.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/13/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//
import Foundation
import FXForms
import SwiftyJSON
public class VerveUserPreferences: NSObject, FXForm {
    public var gender: Int = 0
    public var age: Int = 0
    public var status: Int = 0
    public var ethnicity: Int = 0
    public var beliefs: Int = 0
    public var contact: Int = 0
    public var drinker: Int = 0
    public var isSmoker: Bool = false
    public var isVeteran: Bool = false
    public var otherEthnicity: String = ""
    public var otherBeliefs: String = ""
    public var willingToConnectAnonymously: Bool = false

    func toJSON() -> JSON {
        var dic = [String: JSON]()
        dic["gender"] = JSON(self.gender)
        dic["age"] = JSON(self.age)
        dic["status"] = JSON(self.status)
        dic["ethnicity"] = JSON(self.ethnicity)
        dic["drinker"] = JSON(self.drinker)
        dic["beliefs"] = JSON(self.beliefs)
        dic["contact"] = JSON(self.contact)
        dic["otherEthnicity"] = JSON(self.otherEthnicity)
        dic["otherBeliefs"] = JSON(self.otherBeliefs)
        dic["smoker"] = JSON(self.isSmoker)
        dic["veteran"] = JSON(self.isVeteran)
        dic["connectAnonymously"] = JSON(self.willingToConnectAnonymously)
        return JSON(dic)
    }


    public func excludedFields() -> [Any] {
        return ["age"]
    }

    func genderField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: GENDER_STRING_LIST, FXFormFieldTitle: "Gender"]
    }

    func statusField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: STATUS_STRING_LIST, FXFormFieldTitle: "Status"]
    }

    func ethnicityField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: ETHNICITY_STRING_LIST_1, FXFormFieldTitle: "Ethnicity"]
    }

    func drinkerField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: DRINKER_STRING_LIST, FXFormFieldTitle: "Drinker"]
    }

    func beliefsField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: BELIEFS_STRING_LIST_1, FXFormFieldTitle: "Beliefs"]
    }

    func contactField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: CONTACT_STRING_LIST, FXFormFieldTitle: "Contact"]
    }

    public func fields() -> [Any] {
        return ["gender", "status", "ethnicity", "otherEthnicity", "smoker", "drinker", "beliefs", "otherBeliefs", "veteran", "feelingBlue", "contact"]
    }
}
