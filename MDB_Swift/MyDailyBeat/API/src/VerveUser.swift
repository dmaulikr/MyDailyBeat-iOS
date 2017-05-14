//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  VerveUser.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/17/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import Foundation
import SwiftyJSON
public class VerveUser: NSObject, NSCopying {
    open var id: Int = 0
    open var name: String = ""
    open var screenName: String = ""
    open var password: String = ""
    open var email: String = ""
    open var mobile: String = ""
    open var zipcode: String = ""
    open var dob: Date = Date()

    func toJSON() -> JSON {
        var data = [String: JSON]()
        data["id"] = JSON(id)
        data["name"] = JSON(name)
        data["screenName"] = JSON(screenName)
        data["password"] = JSON(password)
        data["email"] = JSON(email)
        data["mobile"] = JSON(mobile)
        data["zipcode"] = JSON(zipcode)
        data["birth_month"] = JSON(Calendar.current.component(.month, from: dob))
        data["birth_day"] = JSON(Calendar.current.component(.day, from: dob))
        data["birth_year"] = JSON(Calendar.current.component(.year, from: dob))
        let json = JSON(data)
        return json
    }
    
    class func fromJSON(json: JSON) -> VerveUser {
        let user = VerveUser()
        user.id = json["id"].intValue
        user.name = json["name"].stringValue
        user.screenName = json["screenName"].stringValue
        user.password = json["password"].stringValue
        user.email = json["email"].stringValue
        user.mobile = json["mobile"].stringValue
        user.zipcode = json["zipcode"].stringValue
        let birth_month = json["birth_month"].intValue
        let birth_date = json["birth_day"].intValue
        let birth_year = json["birth_year"].intValue
        var dob = Date()
        dob = Calendar.current.date(bySetting: .month, value: birth_month, of: dob)!
        dob = Calendar.current.date(bySetting: .day, value: birth_date, of: dob)!
        var year = Calendar.current.component(.year, from: dob)
        if year > birth_year {
            while year > birth_year {
                dob = Calendar.current.date(byAdding: .year, value: -1, to: dob)!
                year = Calendar.current.component(.year, from: dob)
            }
        } else if year < birth_year {
            while year < birth_year {
                dob = Calendar.current.date(byAdding: .year, value: 1, to: dob)!
                year = Calendar.current.component(.year, from: dob)
            }
        }
        user.dob = dob
        return user
        
    }

    func hasNilField() -> Bool {
        return false
    }


    public func copy(with zone: NSZone?) -> Any {
        let copy: VerveUser = VerveUser()
        copy.id = self.id
        copy.name = self.name.copy() as! String
        copy.email = self.email.copy() as! String
        copy.screenName = self.screenName.copy() as! String
        copy.password = self.password.copy() as! String
        copy.mobile = self.mobile.copy() as! String
        copy.zipcode = self.zipcode.copy() as! String
        copy.dob = Date(timeIntervalSince1970: self.dob.timeIntervalSince1970)
        return copy
    }
}
