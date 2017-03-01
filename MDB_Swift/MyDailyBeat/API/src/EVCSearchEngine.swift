//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  EVCUserSearchEngine.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 10/31/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import Foundation
import SwiftyJSON

public class EVCSearchEngine: NSObject {

    public func getUsers(withScreenName screenName: String, withSortOrder order: EVCSearchSortOrder) -> [VerveUser] {
        let rawDict = RestAPI.getInstance().searchUsers(with: screenName, andQueryType: .searchByScreenName, withSortOrder: order)
        return self.dictofUsers(toArray: rawDict)
    }
    
    public func getUsers(withEmail email: String, withSortOrder order: EVCSearchSortOrder) -> [VerveUser] {
        let rawDict = RestAPI.getInstance().searchUsers(with: email, andQueryType: .searchByEmail, withSortOrder: order)
        return self.dictofUsers(toArray: rawDict)
    }
    
    public func getUsers(withName name: String, withSortOrder order: EVCSearchSortOrder) -> [VerveUser] {
        let rawDict = RestAPI.getInstance().searchUsers(with: name, andQueryType: .searchByName, withSortOrder: order)
        return self.dictofUsers(toArray: rawDict)
    }
    
    public func getUsersForFeelingBlue() -> [VerveUser] {
        let dict = RestAPI.getInstance().getUsersForFeelingBlue()
        return self.dictofUsers(toArray: dict)
    }


    public func dictofUsers(toArray dict: JSON) -> [VerveUser] {
        var jsonArr = dict["items"].arrayValue
        var result = [VerveUser]()
        for i in 0..<jsonArr.count {
            let resultDic = jsonArr[i]
            let currentUser = VerveUser.fromJSON(json: resultDic)
            result.append(currentUser)
        }
        return result
    }

    public func dictofGroups(toArray dict: JSON) -> [Group] {
        var items = dict["items"].arrayValue
        var retItems = [Group]()
        for i in 0..<items.count {
            let item = items[i]
            let g = Group.fromJSON(item)
            retItems.append(g)
        }
        return retItems
    }
}
