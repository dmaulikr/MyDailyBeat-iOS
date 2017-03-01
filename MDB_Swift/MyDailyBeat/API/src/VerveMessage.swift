//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  VerveMessage.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 1/4/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//
import Foundation
public class VerveMessage: NSObject, NSCopying {
    public var screenName: String = ""
    public var message: String = ""


    public func copy(with zone: NSZone?) -> Any {
        var other = VerveMessage()
        other.screenName = self.screenName
        other.message = self.message
        return other
    }
}
