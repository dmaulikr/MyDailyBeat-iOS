//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  API.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/17/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import Foundation
import MobileCoreServices
import Alamofire
import SwiftyJSON

let BASE_URL = "https://1-dot-mydailybeat-api.appspot.com/_ah/api/mydailybeat/v1"
let PUBLIC_BASE_URL = "https://mydailybeat.herokuapp.com"
let AUTH_BASE_URL = PUBLIC_BASE_URL + "/api"
public let GET_REQUEST = "GET"
let POST_REQUEST = "POST"
let PUT_REQUEST = "PUT"
let DELETE_REQUEST = "DELETE"
let NONE = ""
let BOUNDARY = "*****"
fileprivate var s_api: RestAPI? = nil
public class RestAPI: NSObject {
    open fileprivate(set) var currentUser: VerveUser!
    fileprivate var auth_token: String?
    /* getInstance */
    public class func getInstance() -> RestAPI {
        if s_api == nil {
            s_api = RestAPI()
        }
        
        return s_api!
    }
    /* Checks for Connectivity */

    public class func hasConnectivity() -> Bool {
//        var reachability = Reachability()
//        var networkStatus: NetworkStatus = reachability.currentReachabilityStatus()
//        return !(networkStatus == NotReachable)
        return true
    }

    public func getCurrentUser() -> VerveUser {
        return currentUser
    }

    public func createUser(withFirstName fName: String, andLastName lName: String, andEmail email: String, andMobile mobile: String, andZip zipcode: String, bornOn dob: Date, with screenName: String, and password: String) -> Bool {
        var postDic = [String: JSON]()
        postDic["fname"] = JSON(fName)
        postDic["lname"] = JSON(lName)
        postDic["email"] = JSON(email)
        postDic["mobile"] = JSON(mobile)
        postDic["screenName"] = JSON(screenName)
        postDic["password"] = JSON(password)
        postDic["zipcode"] = JSON(zipcode)
        let month = Calendar.current.component(.month, from: dob)
        let day = Calendar.current.component(.day, from: dob)
        let year = Calendar.current.component(.year, from: dob)
        postDic["month"] = JSON(month)
        postDic["day"] = JSON(day)
        postDic["year"] = JSON(year)
        let postData: JSON = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: PUBLIC_BASE_URL, withPath: "users/register", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
        if result["name"].string != nil {
            return true
        }
        return false
    }

    public func edit(_ userData: VerveUser) -> Bool {
        let postData = userData.toJSON()
        var result = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "users/edit", withParameters: "", andAuthToken: auth_token, withRequestType: POST_REQUEST, andPost: postData)
        if result["name"].string != nil {
            return true
        }
        return false
    }

    public func doesUserExist(withName name: String) -> Bool {
        let parameters: String = "name=" + self.urlencode(name)
        var result = self.makeRequest(withBaseUrl: PUBLIC_BASE_URL, withPath: "users/exists", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        return false
    }

    public func doesUserExist(withScreenName screenName: String) -> Bool {
        let parameters: String = "screenName=" + self.urlencode(screenName)
        var result = self.makeRequest(withBaseUrl: PUBLIC_BASE_URL, withPath: "users/exists", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        return false
    }

    public func doesUserExist(withEmail email: String) -> Bool {
        let parameters: String = "email=" + self.urlencode(email)
        var result = self.makeRequest(withBaseUrl: PUBLIC_BASE_URL, withPath: "users/exists", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        return false
    }

    public func doesUserExist(withMobile mobile: String) -> Bool {
        let parameters: String = "mobile=" + self.urlencode(mobile)
        var result = self.makeRequest(withBaseUrl: PUBLIC_BASE_URL, withPath: "users/exists", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        return false
    }

    public func login(withScreenName screenName: String, andPassword password: String) -> Bool {
        var postDic = [String: JSON]()
        postDic["screenName"] = JSON(screenName)
        postDic["password"] = JSON(password)
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: PUBLIC_BASE_URL, withPath: "login", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
        if result["name"].string != nil {
            currentUser = VerveUser.fromJSON(json: result)
            auth_token = result["auth_token"].stringValue
            print("Auth Token = " + auth_token!)
            return true
        }
        return false
    }

    public func refreshCurrentUserData() {
        var resultDic = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "users/get", withParameters: "", andAuthToken: auth_token, withRequestType: GET_REQUEST, andPost: nil)
        if resultDic["screenName"].string != nil {
            currentUser = VerveUser.fromJSON(json: resultDic)
        }
    }

    public func logout() -> Bool {
        let result = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "logout", withParameters: "", andAuthToken: auth_token, withRequestType: GET_REQUEST, andPost: nil);
        let response = result["success"].boolValue
        if response {
            auth_token = nil
        }
        return response
    }

    public func sendReferral(from user: VerveUser, toPersonWithName name: String, andEmail email: String) -> Bool {
        var postDic = [String: JSON]()
        postDic["name"] = JSON(name)
        postDic["email"] = JSON(email)
        let postData = JSON(postDic)
        let result = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "refer/send", withParameters: "", andAuthToken: auth_token, withRequestType: POST_REQUEST, andPost: postData)
        return result["success"].boolValue
    }

    public func getOpportunitiesInLocation(_ zipcode: String, onPage page: Int) -> JSON{
        let path = "volunteering/search/\(zipcode)/\(page)"
        var result = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: path, withParameters: "", andAuthToken: auth_token, withRequestType: GET_REQUEST, andPost: nil)
        var json = result["jsonString"].stringValue
        json = json.removingPercentEncoding!
        json = json.replacingOccurrences(of: "\\", with: "")
        
        let range = json.range(of: "{")
        if !(range?.isEmpty)! {
            json = json.substring(from: (range?.lowerBound)!)
        } else {
            print("Error: Malformed Result: \(json)")
        }
        print("\(json)")
        return JSON(parseJSON: json)
    }

    public func uploadProfilePicture(_ profilePicture: Data, withName name: String) -> Bool {
            //start by getting upload url
        var returnVal: Bool = false
        var parsedJSONResponse: JSON = JSON("")
        let uploadurl = AUTH_BASE_URL + "/profile/upload"
        let semaphore = DispatchSemaphore(value: 0)
        
        let headers = [
            "x-access-token": auth_token ?? ""
        ]
        Alamofire.upload(multipartFormData: { (formData) in
            formData.append(profilePicture, withName: "file", fileName: name, mimeType: self.getMimeType(name))
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: uploadurl, method: HTTPMethod.post, headers: headers) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseSwiftyJSON(completionHandler: { (response) in
                    returnVal = true
                    parsedJSONResponse = response.result.value!
                    semaphore.signal()
                })
            case .failure(let encodingError):
                print(encodingError)
                returnVal = false
                semaphore.signal()
            }
            
        }

        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        if let success = parsedJSONResponse["success"].bool {
            returnVal = success
        }
        
        return returnVal
    }

    public func retrieveProfilePicture() -> URL? {
        return self.retrieveProfilePictureForUser(withScreenName: currentUser.screenName)
    }

    public func retrieveProfilePictureForUser(withScreenName screenName: String) -> URL? {
        let path = "profile/\(screenName)/get"
        var getServingURLResult = self.makeRequest(withBaseUrl: PUBLIC_BASE_URL, withPath: path, withParameters: "", withRequestType: GET_REQUEST, andPost: nil)
        guard getServingURLResult["profilePicUrl"].stringValue != "" else {
            return nil
        }
        let s: String = getServingURLResult["profilePicUrl"].stringValue
        if s == "" {
            return nil
        }
        let url = URL(string: s)
        return url
    }

    public func getUserPreferences() -> VerveUserPreferences {
        let prefs = VerveUserPreferences()
        var resultDic = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "preferences/user/get", withParameters: "", andAuthToken: auth_token, withRequestType: GET_REQUEST, andPost: nil)
        prefs.gender = resultDic["gender"].intValue
        prefs.age = resultDic["age"].intValue
        prefs.status = resultDic["status"].intValue
        prefs.ethnicity = resultDic["ethnicity"].intValue
        prefs.beliefs = resultDic["beliefs"].intValue
        prefs.contact = resultDic["contact"].intValue
        prefs.drinker = resultDic["gender"].intValue
        prefs.isSmoker = resultDic["smoker"].boolValue
        prefs.isVeteran = resultDic["veteran"].boolValue
        prefs.otherEthnicity = resultDic["otherEthnicity"].stringValue
        prefs.otherBeliefs = resultDic["otherBeliefs"].stringValue
        prefs.willingToConnectAnonymously = resultDic["connectAnonymously"].boolValue
        return prefs
    }

    public func getMatchingPreferences() -> VerveMatchingPreferences {
        let prefs = VerveMatchingPreferences()
        var resultDic = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "preferences/matching/get", withParameters: "", andAuthToken: auth_token, withRequestType: GET_REQUEST, andPost: nil)
        prefs.gender = resultDic["gender"].intValue
        prefs.age = resultDic["age"].intValue
        prefs.status = resultDic["status"].intValue
        prefs.ethnicity = resultDic["ethnicity"].intValue
        prefs.beliefs = resultDic["beliefs"].intValue
        prefs.drinker = resultDic["gender"].intValue
        prefs.isSmoker = resultDic["smoker"].boolValue
        prefs.isVeteran = resultDic["veteran"].boolValue
        return prefs
    }

    public func save(_ preferences: VerveUserPreferences, andMatchingPreferences matchingPreferences: VerveMatchingPreferences) -> Bool {
        return (self.save(preferences: preferences) && self.save(matchingPreferences: matchingPreferences))
    }

    public func save(preferences prefs: VerveUserPreferences) -> Bool {
        var result = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "preferences/user/save", withParameters: "", andAuthToken: auth_token, withRequestType: POST_REQUEST, andPost: prefs.toJSON())
        return result["success"].boolValue
    }

    public func save(matchingPreferences prefs: VerveMatchingPreferences) -> Bool {
        var result = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "preferences/matching/save", withParameters: "", andAuthToken: auth_token, withRequestType: POST_REQUEST, andPost: prefs.toJSON())
        return result["success"].boolValue
    }

    public func doesAppExist(withTerm name: String, andCountry country: String) -> Bool {
        var parameters: String = "term=" + self.urlencode(name)
        parameters = parameters + "&country="
        parameters = parameters + self.urlencode(country)
        parameters = parameters + "&media=software&entity=software&attribute=softwareDeveloper"
        parameters = parameters + "&limit=200"
        var resultDic = self.makeRequest(withBaseUrl: "https://itunes.apple.com", withPath: "search", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        let count = resultDic["resultCount"].intValue
        if count < 1 {
            return false
        }
        return true
    }

    public func getBankInfoForBank(withName name: String, inCountry country: String) -> VerveBankObject {
        var parameters: String = "term=" + self.urlencode(name)
        parameters = parameters + "&country="
        parameters = parameters + self.urlencode(country)
        parameters = parameters + "&media=software&entity=software&attribute=softwareDeveloper"
        parameters = parameters + "&limit=200"
        var resultDic = self.makeRequest(withBaseUrl: "https://itunes.apple.com", withPath: "search", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        var results = resultDic["results"].arrayValue
        var bankDic = results[0]
        let bankObj = VerveBankObject()
        bankObj.uniqueID = bankDic["trackId"].intValue
        bankObj.appName = bankDic["trackCensoredName"].stringValue
        bankObj.appStoreListing = bankDic["trackViewUrl"].stringValue
        bankObj.appIconURL = bankDic["artworkUrl512"].stringValue
        return bankObj
    }

    public func getHobbiesPreferencesForUser() -> HobbiesPreferences {
        var resultDic = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "preferences/hobbies/get", withParameters: "", andAuthToken: auth_token, withRequestType: GET_REQUEST, andPost: nil)
        return HobbiesPreferences.fromJSON(resultDic.arrayValue)
    }

    public func save(_ prefs: HobbiesPreferences) -> Bool {
        let array: JSON = HobbiesPreferences.toJSON(prefs)
        var result = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "preferences/hobbies/save", withParameters: "", andAuthToken: auth_token, withRequestType: POST_REQUEST, andPost: array)
        return result["success"].boolValue
    }

    public func getHobbiesMatchesForUser() -> [FlingProfile] {
        var resultDic = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "friends/match", withParameters: "", andAuthToken: auth_token, withRequestType: GET_REQUEST, andPost: nil)
        var items: [JSON] = resultDic.arrayValue
        var retItems = [FlingProfile]()
        for i in 0..<items.count {
            let profile = FlingProfile()
            let item = items[i]
            profile.screenName = item["screenname"].stringValue
            profile.aboutMe = item["aboutme"].stringValue
            retItems.append(profile)
        }
        return retItems
    }

    public func getGroupsForCurrentUser() -> [Group] {
        return self.getGroupsFor(currentUser)
    }

    public func getGroupsFor(_ user: VerveUser) -> [Group] {
        var resultDic = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "groups/get", withParameters: "", andAuthToken: auth_token, withRequestType: GET_REQUEST, andPost: nil)
        var items = resultDic["groups"].arrayValue
        var retItems = [Group]()
        for i in 0..<items.count {
            let g = Group.fromJSON(items[i])
            retItems.append(g)
        }
        return retItems
    }

    public func createGroup(withName groupName: String) -> Bool {
        var postDic = [String: JSON]()
        postDic["groupName"] = JSON(groupName)
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "groups/create", withParameters: "", andAuthToken: auth_token, withRequestType: POST_REQUEST, andPost: postData)
        return result["success"].boolValue
    }

    public func joinGroup(_ group: Group) -> Bool {
        let path = "groups/\(group.groupID)/join"
        var result = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: path, withParameters: "", andAuthToken: auth_token, withRequestType: GET_REQUEST, andPost: nil)
        return result["success"].boolValue
    }

    public func uploadGroupPicture(_ groupPicture: Data, withName name: String, to group: Group) -> Bool {
        var returnVal: Bool = true
//        var parsedJSONResponse: JSON? = nil
//        let semaphore = DispatchSemaphore(value: 0)
//            //start by getting upload url
//        var getURLResult = self.makeRequest(withBaseUrl: BASE_URL, withPath: "users/getuploadurl", withParameters: "", withRequestType: GET_REQUEST, andPost: nil)
//        let uploadurl: String = getURLResult["response"].stringValue
//        Alamofire.upload(multipartFormData: { (formData) in
//            formData.append(groupPicture, withName: "file", fileName: name, mimeType: self.getMimeType(name))
//            formData.append((name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUserAllowed)?.data(using: String.Encoding.utf8))!, withName: "name")
//        }, to: uploadurl) { (encodingResult) in
//            switch encodingResult {
//            case .success(let upload, _, _):
//                upload.responseSwiftyJSON(completionHandler: { (response) in
//                    debugPrint(response)
//                    returnVal = true
//                    parsedJSONResponse = response.result.value
//                })
//            case .failure(let encodingError):
//                print(encodingError)
//                returnVal = false
//            }
//            semaphore.signal()
//        }
//        
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
//        if let json = parsedJSONResponse {
//            var postDic = [String: JSON]()
//            postDic["blobKey"] = json["blobKey"]
//            postDic["servingURL"] = json["servingUrl"]
//            postDic["id"] = JSON(group.groupID)
//            let postData = JSON(postDic)
//            var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "groups/blobkey/save", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
//            let response: String? = result["response"].string
//            if (response! == "Operation succeeded") {
//                returnVal = true
//            }
//            else {
//                returnVal = false
//            }
//        }
//        else {
//            returnVal = false
//        }
        return returnVal
    }

    public func retrieveGroupPicture(for group: Group) -> URL? {
//        let parameters: String = "id=\(group.groupID)"
//        var getServingURLResult = self.makeRequest(withBaseUrl: BASE_URL, withPath: "groups/blobkey/retrieve", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
//        let s: String? = getServingURLResult["servingURL"].string
//        if s == nil {
//            return nil
//        }
//        let url = URL(string: s!)
//        return url
        return nil
    }

    public func write(_ p: Post, withPictureData attachedPic: Data?, andPictureName picName: String, to g: Group) -> Bool {
        var returnVal: Bool = false
        let uploadurl = AUTH_BASE_URL + "/groups/\(g.groupID)/posts/new"
        
        if attachedPic != nil {
            var parsedJSONResponse: JSON? = nil
            let semaphore = DispatchSemaphore(value: 0)
            let headers = [
                "x-access-token": auth_token ?? ""
            ]
            Alamofire.upload(multipartFormData: { (formData) in
                formData.append(attachedPic!, withName: "file", fileName: picName, mimeType: self.getMimeType(picName))
                formData.append((picName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUserAllowed)?.data(using: String.Encoding.utf8))!, withName: "name")
            }, to: uploadurl, method: .post, headers: headers, encodingCompletion: { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseSwiftyJSON(completionHandler: { (response) in
                        returnVal = true
                        parsedJSONResponse = response.result.value
                        semaphore.signal()
                    })
                case .failure(let encodingError):
                    print(encodingError)
                    returnVal = false
                    semaphore.signal()
                }
                
            })
            
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
            if parsedJSONResponse != nil {
                returnVal = true
            } else {
                returnVal = false
            }
            return returnVal
        } else {
            var postDic = [String: JSON]()
            postDic["postText"] = JSON(p.postText)
            let postData = JSON(postDic)
            var result = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: uploadurl, withParameters: "", andAuthToken: auth_token, withRequestType: POST_REQUEST, andPost: postData)
            return result["success"].boolValue
        }
        
    }

    public func getPostsFor(_ g: Group) -> [Post] {
        let path: String = "groups/\(g.groupID)/posts/get"
        var resultDic = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: path, withParameters: "", andAuthToken: auth_token, withRequestType: GET_REQUEST, andPost: nil)
        var items: [JSON] = resultDic["items"].arrayValue
        var retItems = [Post]()
        for i in 0..<items.count {
            let p = Post.fromJSON(items[i])
            retItems.append(p)
        }
        return retItems
    }

    public func setHobbiesforGroup(_ group: Group) -> Bool {
        var postDic = [String: JSON]()
        var bools: [JSON] = []
        for hobby in group.hobbies {
            bools.append(JSON(hobby))
        }
        postDic["hobbies"] = JSON(bools)
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "groups/\(group.groupID)/edit", withParameters: "", andAuthToken: auth_token, withRequestType: POST_REQUEST, andPost: postData)
        return result["success"].boolValue
    }

    public func delete(post p: Post) -> Bool {
        let parameters: String = "id=" + "\(p.post_id)"
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "groups/posts/delete", withParameters: parameters, andAuthToken: auth_token, withRequestType: GET_REQUEST, andPost: nil)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        return false
    }

    public func delete(group g: Group) -> Bool {
        let parameters: String = "id=" + "\(g.groupID)"
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "groups/delete", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        return false
    }

    public func invite(_ invitee: VerveUser, toJoin groupOfChoice: Group, by method: EVCUserInviteSendingMethod, withMessage inviteMessage: String) -> Bool {
        var path = ""
        switch method {
            case .sendByEmail:
                path = "groups/\(groupOfChoice.groupID)/invite/email"
            case .sendByMobile:
                //send by mobile
                path = "groups/\(groupOfChoice.groupID)/invite/mobile"
        }
        var postDic = [String: JSON]()
        postDic["other"] = JSON(invitee.screenName)
        postDic["message"] = JSON(inviteMessage)
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: path, withParameters: "", andAuthToken: auth_token, withRequestType: POST_REQUEST, andPost: postData)
        return result["success"].boolValue
    }
    
    public func getUserData(for id: Int) -> VerveUser {
        var resultDic = self.makeRequest(withBaseUrl: PUBLIC_BASE_URL, withPath: "users/\(id)/get", withParameters: "", withRequestType: GET_REQUEST, andPost: nil)
        return VerveUser.fromJSON(json: resultDic)
    }
    
    public func searchUsers(with query: String, andQueryType type: UserSearchType, withSortOrder order: EVCSearchSortOrder) -> JSON {
        let parameters = "query=\(self.urlencode(query))"
        var path = "name"
        switch type {
        case .searchByName:
            path = "name"
        case .searchByScreenName:
            path = "screenName"
        case .searchByEmail:
            path = "email"
        }
        return self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "users/search/\(path)/\(order.rawValue)", withParameters: parameters, andAuthToken: auth_token, withRequestType: GET_REQUEST, andPost: nil)
    }

    public func searchGroups(withQueryString query: String, with sortOrder: EVCSearchSortOrder) -> JSON {
        var parameters: String = "query=" + self.urlencode(query)
        parameters = parameters + "&sort_order=" + "\(sortOrder)"
        return self.makeRequest(withBaseUrl: BASE_URL, withPath: "groups/search", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
    }
    
    

    public func writeMessage(_ message: String, inChatRoomWithID chatID: Int) -> Bool {
        let path = "messaging/rooms/\(chatID)/messages/new"
        var postDic = [String: JSON]()
        postDic["message_body"] = JSON(message)
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: path, withParameters: "", andAuthToken: auth_token, withRequestType: POST_REQUEST, andPost: postData)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        return false
    }

    public func createChatroomForUsers(withScreenName secondUser: String) -> MessageChatroom? {
        var postDic = [String: JSON]()
        postDic["other"] = JSON(secondUser)
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "messaging/rooms/new", withParameters: "", andAuthToken: auth_token, withRequestType: POST_REQUEST, andPost: postData)
        let m = MessageChatroom()
        if result["success"].boolValue {
            m.chatroomID = result["obj"]["id"].intValue
            return m
        }
        
        return nil
    }

    public func getChatrooms() -> [MessageChatroom] {
        var result = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "messaging/rooms/get", withParameters: "", andAuthToken: auth_token, withRequestType: GET_REQUEST, andPost: nil)
        var items: [JSON] = result.arrayValue
        var retItems = [MessageChatroom]()
        for i in 0..<items.count {
            let m = MessageChatroom()
            var item = items[i]
            m.chatroomID = item.intValue
            m.messages = self.getMessagesForChatroom(withID: m.chatroomID)
            retItems.append(m)
        }
        return retItems
    }
    
    public func getChatroomByID(_ ID: Int) -> MessageChatroom {
        let rooms = self.getChatrooms()
        for room in rooms {
            if room.chatroomID == ID {
                return room
            }
        }
        
        return MessageChatroom()
    }
    
    public func getMessagesForChatroom(withID ID: Int) -> [VerveMessage] {
        let path = "messaging/rooms/\(ID)/messages/get"
        var result = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: path, withParameters: "", andAuthToken: auth_token, withRequestType: GET_REQUEST, andPost: nil)
        var items: [JSON] = result.arrayValue
        var retItems = [VerveMessage]()
        for i in 0..<items.count {
            let m = VerveMessage()
            var item = items[i]
            m.screenName = self.getUserData(for: item["senderid"].intValue).screenName
            m.message = item["body"].stringValue
            m.date_created = item["date_created"].stringValue
            retItems.append(m)
        }
        return retItems
    }

    public func getFlingProfiles() -> [FlingProfile] {
        var resultDic = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "fling/match", withParameters: "", andAuthToken: auth_token, withRequestType: GET_REQUEST, andPost: nil)
        var items: [JSON] = resultDic.arrayValue
        var retItems = [FlingProfile]()
        for i in 0..<items.count {
            var item = items[i]
            let prof = FlingProfile()
            prof.screenName = item["screenName"].stringValue
            prof.aboutMe = item["aboutMe"] .stringValue
            retItems.append(prof)
        }
        return retItems
    }
    
    public func getRelationshipProfiles() -> [FlingProfile] {
        var resultDic = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "relationship/match", withParameters: "", andAuthToken: auth_token, withRequestType: GET_REQUEST, andPost: nil)
        var items: [JSON] = resultDic.arrayValue
        var retItems = [FlingProfile]()
        for i in 0..<items.count {
            var item = items[i]
            let prof = FlingProfile()
            prof.screenName = item["screenName"].stringValue
            prof.aboutMe = item["aboutMe"] .stringValue
            retItems.append(prof)
        }
        return retItems
    }
    

    public func getFlingFavorites() -> [FlingProfile] {
        var resultDic = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "fling/favorites/get", withParameters: "", andAuthToken: auth_token, withRequestType: GET_REQUEST, andPost: nil)
        var items: [JSON] = resultDic.arrayValue
        var retItems = [FlingProfile]()
        for i in 0..<items.count {
            var item = items[i]
            let prof = FlingProfile()
            prof.screenName = item["screenName"].stringValue
            prof.aboutMe = item["aboutMe"] .stringValue
            retItems.append(prof)
        }
        return retItems

    }
    
    public func getRelationshipFavorites() -> [FlingProfile] {
        var resultDic = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "relationship/favorites/get", withParameters: "", andAuthToken: auth_token, withRequestType: GET_REQUEST, andPost: nil)
        var items: [JSON] = resultDic.arrayValue
        var retItems = [FlingProfile]()
        for i in 0..<items.count {
            var item = items[i]
            let prof = FlingProfile()
            prof.screenName = item["screenName"].stringValue
            prof.aboutMe = item["aboutMe"] .stringValue
            retItems.append(prof)
        }
        return retItems
        
    }

    public func getFriends() -> [FlingProfile] {
        var resultDic = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "friends/get", withParameters: "", andAuthToken: auth_token, withRequestType: GET_REQUEST, andPost: nil)
        var items: [JSON] = resultDic.arrayValue
        var retItems = [FlingProfile]()
        for i in 0..<items.count {
            var item = items[i]
            let prof = FlingProfile()
            prof.screenName = item["screenName"].stringValue
            prof.aboutMe = item["aboutMe"] .stringValue
            retItems.append(prof)
        }
        return retItems

    }

    public func addToFlingFavorites(_ user1: VerveUser) -> Bool {
        var postDic = [String: JSON]()
        postDic["other"] = JSON(user1.screenName)
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "fling/favorites/add", withParameters: "", andAuthToken: auth_token, withRequestType: POST_REQUEST, andPost: postData)
        return result["success"].boolValue
    }
    
    public func addToRelationshipFavorites(_ user1: VerveUser) -> Bool {
        var postDic = [String: JSON]()
        postDic["other"] = JSON(user1.screenName)
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "relationship/favorites/add", withParameters: "", andAuthToken: auth_token, withRequestType: POST_REQUEST, andPost: postData)
        return result["success"].boolValue
    }

    public func addToFriends(_ user1: VerveUser) -> Bool {
        var postDic = [String: JSON]()
        postDic["other"] = JSON(user1.screenName)
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "friends/add", withParameters: "", andAuthToken: auth_token, withRequestType: POST_REQUEST, andPost: postData)
        return result["success"].boolValue
    }

    public func getFlingProfile(for user: VerveUser) -> FlingProfile {
        var resultDic = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "fling/profile/\(user.screenName)/get", withParameters: "", andAuthToken: auth_token, withRequestType: GET_REQUEST, andPost: nil)
        let prof = FlingProfile()
        prof.screenName = resultDic["screenName"].stringValue
        prof.aboutMe = resultDic["aboutMe"].stringValue
        return prof
    }
    
    public func getRelationshipProfile(for user: VerveUser) -> FlingProfile {
        var resultDic = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "relationship/profile/\(user.screenName)/get", withParameters: "", andAuthToken: auth_token, withRequestType: GET_REQUEST, andPost: nil)
        let prof = FlingProfile()
        prof.screenName = resultDic["screenName"].stringValue
        prof.aboutMe = resultDic["aboutMe"].stringValue
        return prof
    }
    
    public func getFriendsProfile(for user: VerveUser) -> FlingProfile {
        var resultDic = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "friends/profile/\(user.screenName)/get", withParameters: "", andAuthToken: auth_token, withRequestType: GET_REQUEST, andPost: nil)
        let prof = FlingProfile()
        prof.screenName = resultDic["screenName"].stringValue
        prof.aboutMe = resultDic["aboutMe"].stringValue
        return prof
    }

    public func saveFlingProfile(for user: VerveUser, andDescription about: String) -> Bool {
        var postDic = [String: JSON]()
        postDic["screenName"] = JSON(user.screenName)
        postDic["aboutMe"] = JSON(about)
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "fling/profile/save", withParameters: "", andAuthToken: auth_token, withRequestType: POST_REQUEST, andPost: postData)
        return result["success"].boolValue
    }
    
    public func saveRelationshipProfile(for user: VerveUser, andDescription about: String) -> Bool {
        var postDic = [String: JSON]()
        postDic["screenName"] = JSON(user.screenName)
        postDic["aboutMe"] = JSON(about)
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "relationship/profile/save", withParameters: "", andAuthToken: auth_token, withRequestType: POST_REQUEST, andPost: postData)
        return result["success"].boolValue
    }
    
    public func saveFriendsProfile(for user: VerveUser, andDescription about: String) -> Bool {
        var postDic = [String: JSON]()
        postDic["screenName"] = JSON(user.screenName)
        postDic["aboutMe"] = JSON(about)
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "friends/profile/save", withParameters: "", andAuthToken: auth_token, withRequestType: POST_REQUEST, andPost: postData)
        return result["success"].boolValue
    }

    public func getShoppingFavorites() -> JSON {
        return self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "shopping/url/favorites/get", withParameters: "", withRequestType: GET_REQUEST, andPost: nil)
    }

    public func addShoppingFavoriteURL(_ string: String) -> Bool {
        var postDic = [String: JSON]()
        postDic["url"] = JSON(string)
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "shopping/url/favorites/add", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        return false
    }

    public func getUsersForFeelingBlue() -> JSON {
        return self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: "feelingblue/anonymous/get", withParameters: "", andAuthToken: auth_token, withRequestType: GET_REQUEST, andPost: nil)
    }
    
    public func getJobs(onPage page: Int, inLocation loc: String, inRadius radius: String, andType type: String, andQuery query: String) -> JSON {
        let path = "jobs/get/\(loc)/\(type)/\(radius)/\(page)"
        return self.makeRequest(withBaseUrl: AUTH_BASE_URL, withPath: path, withParameters: "query=\(query)", andAuthToken: auth_token, withRequestType: GET_REQUEST, andPost: nil)
    }

    public func urlencode(_ input: String) -> String {
        return input.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    public func makeRequest(withBaseUrl baseUrl: String, withPath path: String, withParameters parameters: String, andAuthToken token: String? = nil, withRequestType reqType: String, andPost postData: JSON?) -> JSON {
        var json: JSON = JSON("")
        let semaphore = DispatchSemaphore(value: 0)
        var realPost: [String : Any] = [:]
        if let data = postData {
            let raw = data.dictionaryValue
            for key in raw.keys {
                let jsonVal = raw[key]
                realPost[key] = jsonVal?.object
            }
        }
        let headers: HTTPHeaders
        
        if let auth = token {
            headers = [
                "Accept": "application/json",
                "x-access-token": auth
            ]
        } else {
            headers = [
                "Accept": "application/json"
            ]
        }
        
        let method: HTTPMethod = HTTPMethod(rawValue: reqType)!
        _ = Alamofire.request("\(baseUrl)/\(path)?\(parameters)", method: method, parameters: realPost, encoding: URLEncoding.default, headers: headers).responseJSON(queue: DispatchQueue.global(), options: JSONSerialization.ReadingOptions.allowFragments, completionHandler: { (response) in
            if let realJSON = response.result.value as? [String: Any] {
                var temp = [String : JSON]()
                for key in realJSON.keys {
                    let value = realJSON[key]
                    temp[key] = JSON(value!)
                }
                json = JSON(temp)
            }
            semaphore.signal()
        })
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return json
    }

    public func fetchImage(atRemoteURL location: URL) -> Data {
        let semaphore = DispatchSemaphore(value: 0)
        var imageData: Data? = nil
        Alamofire.download(location).responseData { (response) in
            if let data = response.result.value {
                imageData = data
                semaphore.signal()
            }
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return imageData!
    }

    override init() {
        super.init()

        currentUser = nil
    
    }

    public func getMimeType(_ path: String) -> String {
        let pathNS = (path as NSString)
        let pathExtension: CFString = (pathNS.pathExtension as CFString)
        let type: CFString = (UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, nil)?.takeRetainedValue())!
            // The UTI can be converted to a mime type:
        let mimeType: String? = (UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType)?.takeRetainedValue() as? String)
        return mimeType!
    }
    /*
     * Returns the current saved user object.
     *
     * @return A VerveUser object that corresponds to the owner of the current session
     */
    /**
     * Makes an HTTP request for JSON-formatted data. Functions that
     * call this function should not be run on the UI thread.
     *
     * @param baseUrl The base of the URL to which the request will be made
     * @param path The path to append to the request URL
     * @param parameters Parameters separated by ampersands (&)
     * @param reqType The request type as a string (i.e. GET or POST)
     * @param postData The data to be given to MyDailyBeat as NSData
     * @return An object dump of a JSONObject or JSONArray representing the requested data
     */

    public func interestsJSON() -> [Any] {
        var arr = [Any]()
        arr.append("Arts/Culture")
        arr.append("Books")
        arr.append("Car Enthusiast")
        arr.append("Card Games")
        arr.append("Dancing")
        arr.append("Dining Out")
        arr.append("Fitness/Wellbeing")
        arr.append("Golf")
        arr.append("Ladies' Night Out")
        arr.append("Men's Night Out")
        arr.append("Movies")
        arr.append("Outdoor Activities")
        arr.append("Spiritual")
        arr.append("Baseball")
        arr.append("Football")
        arr.append("Hockey")
        arr.append("Car Racing")
        arr.append("Woodworking")
        return arr
    }
    
    public func getInt(_ param: Any) -> Int {
        let raw = (param as? String)
        return Int(raw!)!
    }
    
    public func getBool(_ param: Any) -> Bool {
        let intVal = self.getInt(param)
        return (intVal == 0) ? false : true
    }
    
    public func getInt64(_ param: Any) -> Int64 {
        let raw = (param as? String)
        return Int64(raw!)!
    }
}

public extension String {
    public func getCCharForSingleCharacterString() -> CChar {
        return self.utf8CString[0]
    }
}
