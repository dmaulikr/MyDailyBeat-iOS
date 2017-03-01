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
    open var name: String = ""
    open var screenName: String = ""
    open var password: String = ""
    open var email: String = ""
    open var mobile: String = ""
    open var zipcode: String = ""
    open var birth_month: String = ""
    open var birth_date: Int = 0
    open var birth_year: Int = 0
    open var auth_token: String = ""

    func toJSON() -> JSON {
        var data = [String: JSON]()
        data["name"] = JSON(name)
        data["screenName"] = JSON(screenName)
        data["password"] = JSON(password)
        data["email"] = JSON(email)
        data["mobile"] = JSON(mobile)
        data["zipcode"] = JSON(zipcode)
        data["birth_month"] = JSON(birth_month)
        data["birth_date"] = JSON(birth_date)
        data["birth_year"] = JSON(birth_year)
        let json = JSON(data)
        return json
    }
    
    class func fromJSON(json: JSON) -> VerveUser {
        let user = VerveUser()
        user.name = json["name"].stringValue
        user.screenName = json["screenName"].stringValue
        user.password = json["password"].stringValue
        user.email = json["email"].stringValue
        user.mobile = json["mobile"].stringValue
        user.zipcode = json["zipcode"].stringValue
        user.birth_month = json["birth_month"].stringValue
        user.birth_date = json["birth_date"].intValue
        user.birth_year = json["birth_year"].intValue
        return user
        
    }

    func hasNilField() -> Bool {
        return false
    }


    public func copy(with zone: NSZone?) -> Any {
        let copy: VerveUser = VerveUser()
        copy.name = self.name.copy() as! String
        copy.email = self.email.copy() as! String
        copy.screenName = self.screenName.copy() as! String
        copy.password = self.password.copy() as! String
        copy.mobile = self.mobile.copy() as! String
        copy.zipcode = self.zipcode.copy() as! String
        copy.birth_month = self.birth_month.copy() as! String
        copy.birth_date = self.birth_date
        copy.birth_year = self.birth_year
        return copy
    }
}
