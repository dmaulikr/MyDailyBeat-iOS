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
    public var gender: [Int] = []
    public var age: [Int] = []
    public var status: [Int] = []
    public var ethnicity: [Int] = []
    public var beliefs: [Int] = []
    public var drinker: [Int] = []
    public var isSmoker: Int = 0
    public var isVeteran: Int = 0

    func toJSON() -> JSON {
        var dic = [String: JSON]()
        dic["gender"] = JSON(self.gender)
        dic["age"] = JSON(self.age)
        dic["mrrtl"] = JSON(self.status)
        dic["ethnct"] = JSON(self.ethnicity)
        dic["drnkr"] = JSON(self.drinker)
        dic["relgs"] = JSON(self.beliefs)
        dic["smkr_threechoice_id"] = JSON(self.isSmoker)
        dic["vtrn_threechoice_id"] = JSON(self.isVeteran)
        return JSON(dic)
    }
    
    func isSmokerField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: ThreeChoiceRefList.getInstance().list.reversed().map({ (key, value) -> String in
            return value
        }), FXFormFieldValueTransformer: ThreeChoiceValueTransformer(), FXFormFieldType: FXFormFieldTypeOption]
    }
    
    func isVeteranField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: ThreeChoiceRefList.getInstance().list.reversed().map({ (key, value) -> String in
            return value
        }), FXFormFieldValueTransformer: ThreeChoiceValueTransformer(), FXFormFieldType: FXFormFieldTypeOption]
    }


    func genderField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: GenderRefList.getInstance().list.reversed().map({ (key, value) -> String in
            return value
        }), FXFormFieldValueTransformer: GenderValueTransformer(), FXFormFieldType: FXFormFieldTypeOption]
    }
    
    func statusField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: MaritalRefList.getInstance().list.reversed().map({ (key, value) -> String in
            return value
        }), FXFormFieldValueTransformer: MaritalValueTransformer(), FXFormFieldType: FXFormFieldTypeOption]
    }
    
    func ethnicityField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: EthnicityRefList.getInstance().list.reversed().map({ (key, value) -> String in
            return value
        }), FXFormFieldValueTransformer: EthnicityValueTransformer(), FXFormFieldType: FXFormFieldTypeOption]
    }
    
    func drinkerField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: DrinkerRefList.getInstance().list.reversed().map({ (key, value) -> String in
            return value
        }), FXFormFieldValueTransformer: DrinkerValueTransformer(), FXFormFieldType: FXFormFieldTypeOption]
    }
    
    func beliefsField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: ReligionRefList.getInstance().list.reversed().map({ (key, value) -> String in
            return value
        }), FXFormFieldValueTransformer: ReligionValueTransformer(), FXFormFieldType: FXFormFieldTypeOption]
    }

    func ageField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: AgeRefList.getInstance().list.reversed().map({ (key, value) -> String in
            guard value.max < 120 else {
                return "\(value.min)+"
            }
            return "\(value.min) - \(value.max)"
        }), FXFormFieldValueTransformer: AgeValueTransformer(), FXFormFieldType: FXFormFieldTypeOption]
    }
}
