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
    public var drinker: Int = 0
    public var isSmoker: Bool = false
    public var isVeteran: Bool = false
    public var willingToConnectAnonymously: Bool = false

    func toJSON() -> JSON {
        var dic = [String: JSON]()
        dic["gndr_ref_id"] = JSON(self.gender)
        dic["mrrtl_ref_id"] = JSON(self.status)
        dic["ethnct_ref_id"] = JSON(self.ethnicity)
        dic["drnkr_ref_id"] = JSON(self.drinker)
        dic["relgs_ref_id"] = JSON(self.beliefs)
        dic["smkr_yn"] = JSON(self.isSmoker)
        dic["vtrn_yn"] = JSON(self.isVeteran)
        dic["flng_bl_cnt_anm"] = JSON(self.willingToConnectAnonymously)
        return JSON(dic)
    }
    
    


    public func excludedFields() -> [Any] {
        return ["age"]
    }
    
    func isSmokerField() -> [AnyHashable: Any] {
        return [FXFormFieldType: FXFormFieldTypeBoolean]
    }
    
    func isVeteranField() -> [AnyHashable: Any] {
        return [FXFormFieldType: FXFormFieldTypeBoolean]
    }
    
    func willingToConnectAnonymouslyField() -> [AnyHashable: Any] {
        return [FXFormFieldType: FXFormFieldTypeBoolean]
    }

    func genderField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: GenderRefList.getInstance().list.reversed().map({ (key, value) -> String in
            return value
        }), FXFormFieldValueTransformer: GenderValueTransformer()]
    }
    
    func statusField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: MaritalRefList.getInstance().list.reversed().map({ (key, value) -> String in
            return value
        }), FXFormFieldValueTransformer: MaritalValueTransformer()]
    }
    
    func ethnicityField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: EthnicityRefList.getInstance().list.reversed().map({ (key, value) -> String in
            return value
        }), FXFormFieldValueTransformer: EthnicityValueTransformer()]
    }
    
    func drinkerField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: DrinkerRefList.getInstance().list.reversed().map({ (key, value) -> String in
            return value
        }), FXFormFieldValueTransformer: DrinkerValueTransformer()]
    }
    
    func beliefsField() -> [AnyHashable: Any] {
        return [FXFormFieldOptions: ReligionRefList.getInstance().list.reversed().map({ (key, value) -> String in
            return value
        }), FXFormFieldValueTransformer: ReligionValueTransformer()]
    }
}
