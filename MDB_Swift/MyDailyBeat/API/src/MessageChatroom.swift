//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  MessageChatroom.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 12/26/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import Foundation
public class MessageChatroom: NSObject, NSCopying {
    public var chatroomID: Int = 0
    public var screenNames = [String]()
    public var messages = [String]()


    public func copy(with zone: NSZone?) -> Any {
        let other = MessageChatroom()
        other.screenNames = self.screenNames
        other.chatroomID = self.chatroomID
        other.messages = self.messages
        return other
    }
}
