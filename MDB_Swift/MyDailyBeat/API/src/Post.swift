//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  Post.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 10/1/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import Foundation
import SwiftyJSON
public class Post: NSObject, NSCopying {
    public var post_id: Int = 0
    public var postText: String = ""
    public var imageUrl: String = ""
    public var userid: Int = 0
    public var dateTimeMillis: Int64 = 0


    public func copy(with zone: NSZone?) -> Any {
        let copy = Post()
        copy.postText = self.postText.copy() as! String
        copy.imageUrl = self.imageUrl.copy() as! String
        copy.userid = self.userid
        copy.dateTimeMillis = self.dateTimeMillis
        copy.post_id = self.post_id
        return copy
    }
    
    class func fromJSON(_ post: JSON) -> Post {
        let p = Post()
        p.postText = post["post_bd"].stringValue
        p.imageUrl = post["pic_url"].stringValue
        p.post_id = post["post_id"].intValue
        p.userid = post["user_id"].intValue
        p.dateTimeMillis = post["create_sec_since_1970"].int64Value
        return p
    }
}
