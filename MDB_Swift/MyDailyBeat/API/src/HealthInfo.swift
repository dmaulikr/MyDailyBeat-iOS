//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  HealthInfo.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 5/28/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import Foundation
public class HealthInfo: NSObject, NSCoding {

    public var uniqueId: Int = 0
    public var url: String = ""
    public var logoURL: String = ""

    public init(uniqueId: Int, url URL: String, logoURL: String) {
        self.uniqueId = uniqueId
        self.url = URL
        self.logoURL = logoURL
    }


    public func encode(with coder: NSCoder) {
        coder.encode(self.uniqueId, forKey: "myHealthPortalUniqueID")
        coder.encode(self.url, forKey: "myHealthPortalURL")
        coder.encode(self.logoURL, forKey: "myHealthPortallogoURL")
    }

    required public init?(coder: NSCoder) {
        super.init()
        self.uniqueId = coder.decodeInteger(forKey: "myHealthPortalUniqueID")
        self.url = (coder.decodeObject(forKey: "myHealthPortalURL") as? String)!
        self.logoURL = (coder.decodeObject(forKey: "myHealthPortallogoURL") as? String)!
    
    }
}
