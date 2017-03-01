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
public let GET_REQUEST = "GET"
let POST_REQUEST = "POST"
let PUT_REQUEST = "PUT"
let DELETE_REQUEST = "DELETE"
let NONE = ""
let BOUNDARY = "*****"
fileprivate var s_api: RestAPI? = nil
public class RestAPI: NSObject {
    open fileprivate(set) var currentUser: VerveUser!
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

    public func createUser(_ userData: VerveUser) -> Bool {
        let postData: JSON = userData.toJSON()
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "users/register", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        
        return false
    }

    public func edit(_ userData: VerveUser) -> Bool {
        let postData = userData.toJSON()
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "users/edit", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        
        return false
    }

    public func doesUserExist(withName name: String) -> Bool {
        let parameters: String = "name=" + self.urlencode(name)
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "users/exists/name", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        return false
    }

    public func doesUserExist(withScreenName screenName: String) -> Bool {
        let parameters: String = "screenName=" + self.urlencode(screenName)
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "users/exists/screenName", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        return false
    }

    public func doesUserExist(withEmail email: String) -> Bool {
        let parameters: String = "email=" + self.urlencode(email)
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "users/exists/email", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        return false
    }

    public func doesUserExist(withMobile mobile: String) -> Bool {
        let parameters: String = "mobile=" + self.urlencode(mobile)
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "users/exists/mobile", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
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
            currentUser = VerveUser()
            currentUser.name = result["name"].stringValue
            currentUser.email = result["email"].stringValue
            currentUser.screenName = screenName
            currentUser.password = password
            currentUser.mobile = result["mobile"].stringValue
            currentUser.zipcode = result["zipcode"].stringValue
            currentUser.birth_month = result["birth_month"].stringValue
            currentUser.birth_year = result["birth_year"].intValue
            currentUser.birth_date = result["birth_date"].intValue
            currentUser.auth_token = result["token"].stringValue
            return true
        }
        return false
    }

    public func refreshCurrentUserData() {
        let parameters = "screen_name=\(self.urlencode(currentUser.screenName))&password=\(self.urlencode(currentUser.password))"
        var resultDic = self.makeRequest(withBaseUrl: BASE_URL, withPath: "users/getInfo", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        if resultDic["screenName"].string != nil {
            currentUser.name = resultDic["name"].stringValue
            currentUser.email = resultDic["email"].stringValue
            currentUser.screenName = resultDic["screenName"].stringValue
            currentUser.password = resultDic["password"].stringValue
            currentUser.mobile = resultDic["mobile"].stringValue
            currentUser.zipcode = resultDic["zipcode"].stringValue
            currentUser.birth_month = resultDic["birth_month"].stringValue
            currentUser.birth_year = resultDic["birth_year"].intValue
            currentUser.birth_date = resultDic["birth_date"].intValue
        }
    }

    public func logout() -> Bool {
        currentUser.auth_token = ""
//        var postDic = [String: JSON]()
//        postDic["screenName"] = JSON(currentUser.screenName)
//        postDic["password"] = JSON(currentUser.password)
//        let postData = JSON(postDic)
//        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "users/logout", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
//        let response: String? = result["response"].string
//        if (response! == "Operation succeeded") {
//            return true
//        }
//        return false
        return true
    }

    public func sendReferral(from user: VerveUser, toPersonWithName name: String, andEmail email: String) -> Bool {
        var postDic = [String: JSON]()
        postDic["name"] = JSON(name)
        postDic["email"] = JSON(email)
        let postData = JSON(postDic)
        let result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "refer/send", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        return false
    }

    public func getOpportunitiesInLocation(_ zipcode: String, onPage page: Int) -> JSON{
        let params: String = "page=\(page)&zip=\(zipcode)"
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "volunteering/search", withParameters: params, withRequestType: GET_REQUEST, andPost: nil)
        var json = result["jonString"].stringValue
        json = json.removingPercentEncoding!
        json = json.replacingOccurrences(of: "\\", with: "")
        
        let range = json.range(of: "{")
        if !(range?.isEmpty)! {
            json = json.substring(from: (range?.lowerBound)!)
        } else {
            print("Error: Malformed Result: \(json)")
        }
        print("\(json)")
        return JSON.init(parseJSON: json)
    }

    public func uploadProfilePicture(_ profilePicture: Data, withName name: String) -> Bool {
            //start by getting upload url
        var returnVal: Bool = false
        var parsedJSONResponse: JSON = JSON("")
        var getURLResult = self.makeRequest(withBaseUrl: BASE_URL, withPath: "users/getuploadurl", withParameters: "", withRequestType: GET_REQUEST, andPost: nil)
        let uploadurl = getURLResult["response"].stringValue
        let semaphore = DispatchSemaphore(value: 0)
        Alamofire.upload(multipartFormData: { (formData) in
            formData.append(profilePicture, withName: "file", fileName: name, mimeType: self.getMimeType(name))
            formData.append((name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUserAllowed)?.data(using: String.Encoding.utf8))!, withName: "name")
        }, to: uploadurl) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseSwiftyJSON(completionHandler: { (response) in
                    returnVal = true
                    parsedJSONResponse = response.result.value!
                })
            case .failure(let encodingError):
                print(encodingError)
                returnVal = false
            }
            semaphore.signal()
            
        }

        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        let blobKey: String? = parsedJSONResponse["blobKey"].string
        let servingURL: String? = parsedJSONResponse["servingUrl"].string
        var postDic = [String: JSON]()
        postDic["blobKey"] = JSON(blobKey ?? "")
        postDic["servingURL"] = JSON(servingURL ?? "")
        postDic["screenName"] = JSON(currentUser.screenName)
        postDic["password"] = JSON(currentUser.password)
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "users/profile/blobkey/save", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            returnVal = true
        }
        else {
            returnVal = false
        }
        return returnVal
    }

    public func retrieveProfilePicture() -> URL? {
        return self.retrieveProfilePictureForUser(withScreenName: currentUser.screenName)
    }

    public func retrieveProfilePictureForUser(withScreenName screenName: String) -> URL? {
        let parameters: String = "screen_name=" + self.urlencode(screenName)
        var getServingURLResult = self.makeRequest(withBaseUrl: BASE_URL, withPath: "users/profile/blobkey/retrieve", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        let s: String? = getServingURLResult["servingURL"].string
        if s == nil {
            return nil
        }
        let url = URL(string: s!)
        return url
    }

    public func getUserPreferences(for user: VerveUser) -> VerveUserPreferences {
        let prefs = VerveUserPreferences()
        let parameters: String = "screenName=" + self.urlencode(user.screenName)
        var resultDic = self.makeRequest(withBaseUrl: BASE_URL, withPath: "preferences/user/get", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        prefs.gender = resultDic["gender"].intValue
        prefs.age = resultDic["age"].intValue
        prefs.status = resultDic["status"].intValue
        prefs.ethnicity = resultDic["ethnicity"].intValue
        prefs.beliefs = resultDic["beliefs"].intValue
        prefs.contact = resultDic["contact"].intValue
        prefs.drinker = resultDic["gender"].intValue
        prefs.isSmoker = resultDic["smoker"].boolValue
        prefs.isVeteran = resultDic["veteran"].boolValue
        prefs.isFeelingBlue = resultDic["feelingBlue"].boolValue
        prefs.otherEthnicity = resultDic["otherEthnicity"].stringValue
        prefs.otherBeliefs = resultDic["otherBeliefs"].stringValue
        return prefs
    }

    public func getMatchingPreferences(for user: VerveUser) -> VerveMatchingPreferences {
        let prefs = VerveMatchingPreferences()
        let parameters: String = "screenName=" + self.urlencode(user.screenName)
        var resultDic = self.makeRequest(withBaseUrl: BASE_URL, withPath: "preferences/matching/get", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
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

    public func save(_ preferences: VerveUserPreferences, andMatchingPreferences matchingPreferences: VerveMatchingPreferences, for user: VerveUser) -> Bool {
        var postDic = [String: JSON]()
        postDic["screenName"] = JSON(currentUser.screenName)
        postDic["password"] = JSON(currentUser.password)
        postDic["prefs"] = preferences.toJSON()
        postDic["matchingPrefs"] = matchingPreferences.toJSON()
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "preferences/save", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        return false
    }

    public func save(preferences prefs: VerveUserPreferences, for user: VerveUser) -> Bool {
        var postDic = [String: JSON]()
        postDic["screenName"] = JSON(currentUser.screenName)
        postDic["prefs"] = prefs.toJSON()
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "preferences/user/save", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        return false
    }

    public func save(matchingPreferences prefs: VerveMatchingPreferences, for user: VerveUser) -> Bool {
        var postDic = [String: JSON]()
        postDic["screenName"] = JSON(currentUser.screenName)
        postDic["matchingPrefs"] = prefs.toJSON()
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "preferences/matching/save", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        return false
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

    public func getHobbiesPreferencesForUser(withScreenName screenName: String) -> HobbiesPreferences {
        let parameters: String = "screenName=" + self.urlencode(screenName)
        var resultDic = self.makeRequest(withBaseUrl: BASE_URL, withPath: "prefs/hobbies/get", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        let list = resultDic["hobbyList"].arrayValue
        return HobbiesPreferences.fromJSON(list)
    }

    public func save(_ prefs: HobbiesPreferences, forUserWithScreenName screenName: String) -> Bool {
        let array: JSON = HobbiesPreferences.toJSON(prefs)
        var postDic = [String: JSON]()
        postDic["hobbyList"] = array
        postDic["screenName"] = JSON(screenName)
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "prefs/hobbies/save", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        return false
    }

    public func getHobbiesMatchesForUser(withScreenName screenName: String) -> [HobbiesMatchObject] {
        let parameters: String = "screenName=" + self.urlencode(screenName)
        var resultDic = self.makeRequest(withBaseUrl: BASE_URL, withPath: "hobbies/match", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        var items: [JSON] = resultDic["items"].arrayValue
        var retItems = [HobbiesMatchObject]()
        for i in 0..<items.count {
            let match = HobbiesMatchObject()
            let item = items[i]
            let prefs = item["prefs"]
            match.prefs = HobbiesPreferences.fromJSON(prefs["hobbyList"].arrayValue)
            var userDic = item["userObj"]
            let temp = VerveUser()
            temp.screenName = userDic["screenName"].stringValue
            match.userObj = temp
            retItems.append(match)
        }
        return retItems
    }

    public func getGroupsForCurrentUser() -> [Group] {
        return self.getGroupsFor(currentUser)
    }

    public func getGroupsFor(_ user: VerveUser) -> [Group] {
        var parameters: String = "screen_name=" + self.urlencode(user.screenName)
        parameters = parameters + "&password=" + self.urlencode(user.password)
        var resultDic = self.makeRequest(withBaseUrl: BASE_URL, withPath: "groups/get", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        var items = resultDic["items"].arrayValue
        var retItems = [Group]()
        for i in 0..<items.count {
            let g = Group.fromJSON(items[i])
            retItems.append(g)
        }
        return retItems
    }

    public func createGroup(withName groupName: String) -> Bool {
        var postDic = [String: JSON]()
        postDic["screenName"] = JSON(currentUser.screenName)
        postDic["password"] = JSON(currentUser.password)
        postDic["groupName"] = JSON(groupName)
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "groups/create", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        return false
    }

    public func joinGroup(withName groupName: String) -> Bool {
        var postDic = [String: JSON]()
        postDic["screenName"] = JSON(currentUser.screenName)
        postDic["password"] = JSON(currentUser.password)
        postDic["groupName"] = JSON(groupName)
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "users/groups/join", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        return false
    }

    public func uploadGroupPicture(_ groupPicture: Data, withName name: String, to group: Group) -> Bool {
        var returnVal: Bool = false
        var parsedJSONResponse: JSON? = nil
        let semaphore = DispatchSemaphore(value: 0)
            //start by getting upload url
        var getURLResult = self.makeRequest(withBaseUrl: BASE_URL, withPath: "users/getuploadurl", withParameters: "", withRequestType: GET_REQUEST, andPost: nil)
        let uploadurl: String = getURLResult["response"].stringValue
        Alamofire.upload(multipartFormData: { (formData) in
            formData.append(groupPicture, withName: "file", fileName: name, mimeType: self.getMimeType(name))
            formData.append((name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUserAllowed)?.data(using: String.Encoding.utf8))!, withName: "name")
        }, to: uploadurl) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseSwiftyJSON(completionHandler: { (response) in
                    debugPrint(response)
                    returnVal = true
                    parsedJSONResponse = response.result.value
                })
            case .failure(let encodingError):
                print(encodingError)
                returnVal = false
            }
            semaphore.signal()
        }
        
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        if let json = parsedJSONResponse {
            var postDic = [String: JSON]()
            postDic["blobKey"] = json["blobKey"]
            postDic["servingURL"] = json["servingUrl"]
            postDic["id"] = JSON(group.groupID)
            let postData = JSON(postDic)
            var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "groups/blobkey/save", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
            let response: String? = result["response"].string
            if (response! == "Operation succeeded") {
                returnVal = true
            }
            else {
                returnVal = false
            }
        }
        else {
            returnVal = false
        }
        return returnVal
    }

    public func retrieveGroupPicture(for group: Group) -> URL? {
        let parameters: String = "id=\(group.groupID)"
        var getServingURLResult = self.makeRequest(withBaseUrl: BASE_URL, withPath: "groups/blobkey/retrieve", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        let s: String? = getServingURLResult["servingURL"].string
        if s == nil {
            return nil
        }
        group.servingURL = getServingURLResult["servingURL"].stringValue
        group.blobKey = getServingURLResult["blobKey"].stringValue
        let url = URL(string: s!)
        return url
    }

    public func write(_ p: Post, withPictureData attachedPic: Data?, andPictureName picName: String, to g: Group) -> Bool {
        var returnVal: Bool = false
        if attachedPic != nil {
            var parsedJSONResponse: JSON? = nil
            let semaphore = DispatchSemaphore(value: 0)
            var getURLResult = self.makeRequest(withBaseUrl: BASE_URL, withPath: "users/getuploadurl", withParameters: "", withRequestType: GET_REQUEST, andPost: nil)
            let uploadurl: String = getURLResult["response"].stringValue
            Alamofire.upload(multipartFormData: { (formData) in
                formData.append(attachedPic!, withName: "file", fileName: picName, mimeType: self.getMimeType(picName))
                formData.append((picName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUserAllowed)?.data(using: String.Encoding.utf8))!, withName: "name")
            }, to: uploadurl, encodingCompletion: { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseSwiftyJSON(completionHandler: { (response) in
                        returnVal = true
                        parsedJSONResponse = response.result.value
                    })
                case .failure(let encodingError):
                    print(encodingError)
                    returnVal = false
                }
                semaphore.signal()
            })
            
            
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
            if let json = parsedJSONResponse {
                var postDic = [String: JSON]()
                postDic["blobKey"] = json["blobKey"]
                postDic["servingURL"] = json["servingUrl"]
                postDic["postText"] = JSON(p.postText)
                postDic["userScreenName"] = JSON(p.userScreenName)
                postDic["when"] = JSON(p.dateTimeMillis)
                postDic["id"] = JSON(g.groupID)
                let postData = JSON(postDic)
                var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "groups/post", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
                let response: String? = result["response"].string
                if (response! == "Operation succeeded") {
                    returnVal = true
                }
                else {
                    returnVal = false
                }
            }
            else {
                returnVal = false
            }
            return returnVal
        } else {
            var postDic = [String: JSON]()
            postDic["blobKey"] = JSON("")
            postDic["servingURL"] = JSON("")
            postDic["postText"] = JSON(p.postText)
            postDic["userScreenName"] = JSON(p.userScreenName)
            postDic["when"] = JSON(p.dateTimeMillis)
            postDic["id"] = JSON(g.groupID)
            let postData = JSON(postDic)
            var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "groups/post", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
            let response: String? = result["response"].string
            if (response! == "Operation succeeded") {
                return true
            }
            else {
                return false
            }
        }
    }

    public func getPostsFor(_ g: Group) -> [Post] {
        let path: String = "groups/\(g.groupID)/posts/get"
        var resultDic = self.makeRequest(withBaseUrl: BASE_URL, withPath: path, withParameters: "", withRequestType: GET_REQUEST, andPost: nil)
        var items: [JSON] = resultDic["items"].arrayValue
        var retItems = [Post]()
        for i in 0..<items.count {
            let p = Post()
            var post = items[i]
            p.postText = post["postText"].stringValue
            p.blobKey = post["blobKey"].stringValue
            p.servingURL = post["servingURL"].stringValue
            p.userScreenName = post["userScreenName"].stringValue
            p.post_id = post["id"].intValue
            p.dateTimeMillis = post["when"].int64Value
            retItems.append(p)
        }
        return retItems
    }

    public func setHobbiesforGroup(_ group: Group) -> Bool {
        var postDic = [String: JSON]()
        postDic["id"] = JSON(group.groupID)
        var bools: [JSON] = []
        for hobby in group.hobbies {
            bools.append(JSON(hobby))
        }
        postDic["hobbies"] = JSON(bools)
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "groups/edit", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        return false
    }

    public func delete(post p: Post) -> Bool {
        let parameters: String = "id=" + "\(p.post_id)"
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "groups/posts/delete", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
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
        switch method {
            case .sendByEmail:
                var postDic = [String: JSON]()
                postDic["senderemail"] = JSON(currentUser.email)
                postDic["recipientemail"] = JSON(invitee.email)
                postDic["inviteMessage"] = JSON(inviteMessage)
                postDic["groupID"] = JSON(groupOfChoice.groupID)
                let postData = JSON(postDic)
                var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "groups/invite/email", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
                let response: String? = result["response"].string
                if (response! == "Operation succeeded") {
                    return true
            }
            case .sendByMobile:
                //send by mobile
                print("Not implemented yet due to logistical issues")
        }

        return false
    }
    
    public func getUserData(forUserWithScreenName screenName: String) -> VerveUser {
        let parameters = "screen_name=\(self.urlencode(screenName))"
        var resultDic = self.makeRequest(withBaseUrl: BASE_URL, withPath: "users/getInfo2", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        let user = VerveUser()
        if (resultDic["screenName"].string) != nil {
            user.name = resultDic["name"].stringValue
            user.email = resultDic["email"].stringValue
            user.screenName = resultDic["screenName"].stringValue
            user.password = resultDic["password"].stringValue
            user.mobile = resultDic["mobile"].stringValue
            user.zipcode = resultDic["zipcode"].stringValue
            user.birth_month = resultDic["birth_month"].stringValue
            user.birth_year = resultDic["birth_year"].intValue
            user.birth_date = resultDic["birth_date"].intValue
        }
        return user
    }
    
    public func searchUsers(with query: String, andQueryType type: UserSearchType, withSortOrder order: EVCSearchSortOrder) -> JSON {
        let parameters = "query=\(self.urlencode(query))&sort_order=\(order.rawValue)"
        var path = "name"
        switch type {
        case .searchByName:
            path = "name"
        case .searchByScreenName:
            path = "screenName"
        case .searchByEmail:
            path = "email"
        }
        return self.makeRequest(withBaseUrl: BASE_URL, withPath: "users/search/\(path)", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
    }

    public func searchGroups(withQueryString query: String, with sortOrder: EVCSearchSortOrder) -> JSON {
        var parameters: String = "query=" + self.urlencode(query)
        parameters = parameters + "&sort_order=" + "\(sortOrder)"
        return self.makeRequest(withBaseUrl: BASE_URL, withPath: "groups/search", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
    }
    
    

    public func writeMessage(_ message: String, as user: VerveUser, inChatRoomWithID chatID: Int, atTime dateTimeMillis: Int64) -> Bool {
        var postDic = [String: JSON]()
        postDic["screenName"] = JSON(user.screenName)
        postDic["messageText"] = JSON(message)
        postDic["dateTimeMillis"] = JSON(dateTimeMillis)
        postDic["chatID"] = JSON(chatID)
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "fling/messaging/post", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        return false
    }

    public func createChatroomForUsers(withScreenName firstUser: String, andScreenName secondUser: String) -> MessageChatroom? {
        var postDic = [String: JSON]()
        postDic["screenName1"] = JSON(firstUser)
        postDic["screenName2"] = JSON(secondUser)
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "fling/messaging/newchatroom", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
        let m = MessageChatroom()
        if (result["screenNames"].string) != nil {
            m.chatroomID = result["CHATROOM_ID"].intValue
            let screenNameJSON = result["screenNames"].arrayValue
            var strArr: [String] = []
            for entry in screenNameJSON {
                strArr.append(entry.stringValue)
            }
            m.screenNames = strArr
            strArr = []
            let messageJSON = result["messages"].arrayValue
            for entry in messageJSON {
                strArr.append(entry.stringValue)
            }
            m.messages = strArr
            return m
        }
        
        return nil
    }

    public func getChatroomsFor(_ user: VerveUser) -> [MessageChatroom] {
        let parameters: String = "screenName=" + self.urlencode(user.screenName)
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "fling/messaging/getchatrooms", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        var items: [JSON] = result["items"].arrayValue
        var retItems = [MessageChatroom]()
        for i in 0..<items.count {
            let m = MessageChatroom()
            var item = items[i]
            m.chatroomID = item["CHATROOM_ID"].intValue
            let screenNameJSON = item["screenNames"].arrayValue
            var strArr: [String] = []
            for entry in screenNameJSON {
                strArr.append(entry.stringValue)
            }
            m.screenNames = strArr
            strArr = []
            let messageJSON = item["messages"].arrayValue
            for entry in messageJSON {
                strArr.append(entry.stringValue)
            }
            m.messages = strArr
            retItems.append(m)
        }
        return retItems
    }

    public func getFlingProfilesBased(onPrefsOf user: VerveUser) -> [FlingProfile] {
        var parameters: String = "screen_name=" + self.urlencode(user.screenName)
        parameters = parameters + "&password=" + self.urlencode(user.password)
        var resultDic = self.makeRequest(withBaseUrl: BASE_URL, withPath: "relationship/match", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        var items: [JSON] = resultDic["items"].arrayValue
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

    public func getFlingFavorites(for user: VerveUser) -> [FlingProfile] {
        let parameters: String = "screen_name=" + self.urlencode(user.screenName)
        var resultDic = self.makeRequest(withBaseUrl: BASE_URL, withPath: "fling/favorites/get", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        var items: [JSON] = resultDic["items"].arrayValue
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

    public func getFriendsFor(_ user: VerveUser) -> [FlingProfile] {
        let parameters: String = "screen_name=" + self.urlencode(user.screenName)
        var resultDic = self.makeRequest(withBaseUrl: BASE_URL, withPath: "friends/get", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        var items: [JSON] = resultDic["items"].arrayValue
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

    public func add(_ user1: VerveUser, toFlingFavoritesOf user2: VerveUser) -> Bool {
        var postDic = [String: JSON]()
        postDic["screenName"] = JSON(user2.screenName)
        postDic["other"] = self.getFlingProfile(for: user1).toJSON()
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "fling/favorites/add", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        return false
    }

    public func add(_ user1: VerveUser, toFriendsOf user2: VerveUser) -> Bool {
        var postDic = [String: JSON]()
        postDic["screenName"] = JSON(user2.screenName)
        postDic["other"] = self.getFlingProfile(for: user1).toJSON()
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "friends/add", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        return false
    }

    public func getFlingProfile(for user: VerveUser) -> FlingProfile {
        let parameters: String = "screenName=" + self.urlencode(user.screenName)
        var resultDic = self.makeRequest(withBaseUrl: BASE_URL, withPath: "fling/profile/get", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        let prof = FlingProfile()
        prof.screenName = resultDic["screenName"].stringValue
        prof.aboutMe = resultDic["aboutMe"].stringValue
        return prof
    }

    public func saveFlingProfile(for user: VerveUser, withAge age: Int, andDescription about: String) -> Bool {
        var postDic = [String: JSON]()
        postDic["screenName"] = JSON(user.screenName)
        postDic["aboutMe"] = JSON(about)
        postDic["age"] = JSON(age)
        let postData = JSON(postDic)
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "fling/profile/save", withParameters: "", withRequestType: POST_REQUEST, andPost: postData)
        let response: String? = result["response"].string
        if (response! == "Operation succeeded") {
            return true
        }
        return false
    }

    public func getChatroomByID(_ ID: Int) -> MessageChatroom {
        let parameters: String = "id=\(ID)"
        var resultDic = self.makeRequest(withBaseUrl: BASE_URL, withPath: "fling/messaging/getchatroomsbyid", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        let m = MessageChatroom()
        m.chatroomID = resultDic["CHATROOM_ID"].intValue
        let screenNameJSON = resultDic["screenNames"].arrayValue
        var strArr: [String] = []
        for entry in screenNameJSON {
            strArr.append(entry.stringValue)
        }
        m.screenNames = strArr
        strArr = []
        let messageJSON = resultDic["messages"].arrayValue
        for entry in messageJSON {
            strArr.append(entry.stringValue)
        }
        m.messages = strArr
        return m
    }

    public func getMessagesForChatroom(withID ID: Int) -> [VerveMessage] {
        let parameters: String = "id=\(ID)"
        var result = self.makeRequest(withBaseUrl: BASE_URL, withPath: "fling/messaging/getmessages", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
        var items: [JSON] = result["items"].arrayValue
        var retItems = [VerveMessage]()
        for i in 0..<items.count {
            let m = VerveMessage()
            var item = items[i]
            m.screenName = item["screenName"].stringValue
            m.message = item["messageText"].stringValue
            retItems.append(m)
        }
        return retItems
    }

    public func searchShoppingURLS(withQueryString query: String, with sortOrder: EVCSearchSortOrder) -> JSON {
        var parameters: String = "query=" + self.urlencode(query)
        parameters = parameters + "&sort_order=" + "\(sortOrder)"
        return self.makeRequest(withBaseUrl: BASE_URL, withPath: "shopping/url/search", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
    }

    public func getShoppingFavorites(for user: VerveUser, with sortOrder: EVCSearchSortOrder) -> JSON {
        let parameters: String = "screen_name=" + self.urlencode(user.screenName)
        return self.makeRequest(withBaseUrl: BASE_URL, withPath: "shopping/url/favorites/get", withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
    }

    public func addShoppingFavoriteURL(_ string: String, for user: VerveUser) -> Bool {
        var postDic = [String: JSON]()
        postDic["screenName"] = JSON(user.screenName)
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
        return self.makeRequest(withBaseUrl: BASE_URL, withPath: "feelingblue/anonymous/load", withParameters: "", withRequestType: GET_REQUEST, andPost: nil)
    }

    public func urlencode(_ input: String) -> String {
        var output = String()
        let source = input.utf8CString
        let sourceLen = source.count
        for i in 0..<sourceLen {
            let thisChar = source[i]
            if thisChar == " ".getCCharForSingleCharacterString() {
                output += "+"
            }
            else if thisChar == ".".getCCharForSingleCharacterString() || thisChar == "-".getCCharForSingleCharacterString() || thisChar == "_".getCCharForSingleCharacterString() || thisChar == "~".getCCharForSingleCharacterString() || (thisChar >= "a".getCCharForSingleCharacterString() && thisChar <= "z".getCCharForSingleCharacterString()) || (thisChar >= "A".getCCharForSingleCharacterString() && thisChar <= "Z".getCCharForSingleCharacterString()) || (thisChar >= "0".getCCharForSingleCharacterString() && thisChar <= "9".getCCharForSingleCharacterString()) {
                output += "\(thisChar)"
            }
            else {
                output += String(format: "%%%02X", thisChar)
            }
        }
        return output
    }

    public func makeRequest(withBaseUrl baseUrl: String, withPath path: String, withParameters parameters: String, withRequestType reqType: String, andPost postData: JSON?) -> JSON {
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
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        let method: HTTPMethod = HTTPMethod(rawValue: reqType)!
        let request = Alamofire.request("\(baseUrl)/\(path)?\(parameters)", method: method, parameters: realPost, encoding: JSONEncoding.default, headers: headers).responseJSON(queue: DispatchQueue.global(), options: JSONSerialization.ReadingOptions.allowFragments, completionHandler: { (response) in
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
        print(request)
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
        let pathExtension: CFString? = (pathNS.pathExtension as CFString)
        let type: CFString = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension!, nil) as! CFString
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
