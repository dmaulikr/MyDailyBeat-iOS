//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  FlingProfile.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 12/31/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import Foundation
import SwiftyJSON
public class FlingProfile: NSObject {
    public var screenName: String = ""
    public var aboutMe: String = ""
    
    func toJSON() -> JSON {
        var dic = [String : JSON]()
        dic["screenName"] = JSON(self.screenName)
        dic["aboutMe"] = JSON(self.aboutMe)
        return JSON(dic)
    }
}
