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
    public var blobKey: String = ""
    public var servingURL: String = ""
    public var userScreenName: String = ""
    public var dateTimeMillis: Int64 = 0


    public func copy(with zone: NSZone?) -> Any {
        let copy = Post()
        copy.postText = self.postText.copy() as! String
        copy.blobKey = self.blobKey.copy() as! String
        copy.servingURL = self.servingURL.copy() as! String
        copy.userScreenName = self.userScreenName.copy() as! String
        copy.dateTimeMillis = self.dateTimeMillis
        copy.post_id = self.post_id
        return copy
    }
    
    class func fromJSON(_ post: JSON) -> Post {
        let p = Post()
        p.postText = post["postText"].stringValue
        p.blobKey = post["blobKey"].stringValue
        p.servingURL = post["servingURL"].stringValue
        p.post_id = post["id"].intValue
        p.userScreenName = post["userScreenName"].stringValue
        p.dateTimeMillis = post["when"].int64Value
        return p
    }
}
