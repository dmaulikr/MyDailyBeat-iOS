//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  BankInfo.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 5/20/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import Foundation
public class BankInfo: NSObject, NSCoding {

    public var uniqueId: Int = 0
    public var appName: String = ""
    public var appURL: String = ""
    public var iconURL: String = ""

    public convenience init(uniqueId: Int, name appName: String, appURL: String, iconURL: String) {
        self.init()
        self.uniqueId = uniqueId
        self.appName = appName
        self.appURL = "itms-apps://itunes.apple.com/app/id\(self.uniqueId)"
        self.iconURL = iconURL
    }
    
    override init() {
        
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.uniqueId, forKey: "myBankUniqueID")
        aCoder.encode(self.appName, forKey: "myBankAppName")
        aCoder.encode(self.appURL, forKey: "myBankAppURL")
        aCoder.encode(self.iconURL, forKey: "myBankIconURL")
    }

    required public init?(coder: NSCoder) {
        super.init()
        
        self.uniqueId = coder.decodeInteger(forKey: "myBankUniqueID")
        self.appName = (coder.decodeObject(forKey: "myBankAppName") as? String)!
        self.appURL = (coder.decodeObject(forKey: "myBankAppURL") as? String)!
        self.iconURL = (coder.decodeObject(forKey: "myBankIconURL") as? String)!
    
    }
}
