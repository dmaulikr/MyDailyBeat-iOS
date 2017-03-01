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
    public var adminName: String = ""
    public var groupID: Int = 0
    public var posts = [Post]()
    public var hobbies = [Bool]()
    public var blobKey: String = ""
    public var servingURL: String = ""


    public func copy(with zone: NSZone?) -> Any {
        let copy = Group()
        copy.groupName = self.groupName.copy() as! String
        copy.adminName = self.adminName.copy() as! String
        for post in self.posts {
            copy.posts.append(post.copy() as! Post)
        }
        copy.blobKey = self.blobKey.copy() as! String
        copy.servingURL = self.servingURL.copy() as! String
        copy.groupID = self.groupID
        for hobby in self.hobbies {
            copy.hobbies.append(hobby)
        }
        return copy
    }
    
    class func fromJSON(_ item: JSON) -> Group {
        let g = Group()
        g.groupName = item["groupName"].stringValue
        g.adminName = item["adminScreenName"].stringValue
        g.blobKey = item["blobKey"].stringValue
        g.servingURL = item["servingURL"].stringValue
        g.groupID = item["id"].intValue
        let postJSON = item["posts"].arrayValue
        g.posts = []
        var temp: [Post] = []
        for post in postJSON {
            let postObj = Post.fromJSON(post)
            temp.append(postObj)
        }
        g.posts = temp
        var hobbyTemp: [Bool] = []
        let hobbiesJSON = item["hobbies"].arrayValue
        for hobby in hobbiesJSON {
            hobbyTemp.append(hobby.boolValue)
        }
        g.hobbies = hobbyTemp
        return g
    }
}
