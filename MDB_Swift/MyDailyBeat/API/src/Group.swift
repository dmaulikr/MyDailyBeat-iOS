//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  Group.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 9/2/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import Foundation
import SwiftyJSON
public class Group: NSObject, NSCopying {
    public var groupName: String = ""
    public var adminID: Int = 0
    public var groupID: Int = 0
    public var posts = [Post]()


    public func copy(with zone: NSZone?) -> Any {
        let copy = Group()
        copy.groupName = self.groupName.copy() as! String
        copy.adminID = self.adminID
        for post in self.posts {
            copy.posts.append(post.copy() as! Post)
        }
        copy.groupID = self.groupID
        return copy
    }
    
    class func fromJSON(_ item: JSON) -> Group {
        let g = Group()
        g.groupName = item["group_nm"].stringValue
        g.adminID = item["admin_id"].intValue
        g.groupID = item["group_id"].intValue
        return g
    }
}
