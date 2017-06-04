//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  VerveMessage.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 1/4/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//
import Foundation
import JSQMessagesViewController
public class VerveMessage: NSObject, NSCopying, JSQMessageData {
    public var screenName: String = ""
    public var message: String = ""
    public var date_created: String = ""


    public func copy(with zone: NSZone?) -> Any {
        let other = VerveMessage()
        other.screenName = self.screenName
        other.message = self.message
        other.date_created = date_created
        return other
    }
    
    public func senderId() -> String! {
        return screenName
    }
    
    public func senderDisplayName() -> String! {
        return screenName
    }
    
    public func date() -> Date! {
        let formatter =  DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.date(from: self.date_created)!
    }
    
    public func isMediaMessage() -> Bool {
        return false
    }
    
    public func messageHash() -> UInt {
        return UInt(self.screenName.md5()[0])
    }
}
