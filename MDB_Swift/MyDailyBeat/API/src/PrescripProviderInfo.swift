//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  PrescripProviderInfo.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 5/30/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import Foundation
public class PrescripProviderInfo: NSObject, NSCoding {

    public var uniqueId: Int = 0
    public var url: String = ""
    public var logoURL: String = ""

    public convenience init(uniqueId: Int, url URL: String, logoURL: String) {
        self.init()
        self.uniqueId = uniqueId
        self.url = URL
        self.logoURL = logoURL
    }
    
    public override init() {
        // no need to do anything here
    }


    public func encode(with coder: NSCoder) {
        coder.encode(Int(self.uniqueId), forKey: "myPrescripProviderUniqueID")
        coder.encode(self.url, forKey: "myPrescripProviderURL")
        coder.encode(self.logoURL, forKey: "myPrescripProviderlogoURL")
    }

    required public init?(coder: NSCoder) {
        super.init()
        
        self.uniqueId = Int(CInt((coder.decodeObject(forKey: "myPrescripProviderUniqueID") as? NSNumber)!))
        self.url = (coder.decodeObject(forKey: "myPrescripProviderURL") as? String)!
        self.logoURL = (coder.decodeObject(forKey: "myPrescripProviderlogoURL") as? String)!
    
    }
}
