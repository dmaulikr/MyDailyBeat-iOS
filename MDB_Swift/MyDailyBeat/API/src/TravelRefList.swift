//
//  TravelRefList.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 5/29/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import UIKit
private var s_list: TravelRefList = TravelRefList()
public class TravelRefList: NSObject {
    open fileprivate(set) var list: [Int: String] = [Int: String]()
    fileprivate var loaded: Bool = false
    override fileprivate init() {
        super.init()
    }
    
    public class func getInstance() -> TravelRefList {
        if !s_list.loaded {
            s_list.load()
        }
        return s_list
    }
    
    public func load() {
        let json = RestAPI.getInstance().getTravelRefList()
        let arr = json.arrayValue
        for value in arr {
            let id = value["trvl_ref_id"].intValue
            let desc = value["trvl_url"].stringValue
            list[id] = desc
        }
        self.loaded = true
    }
}
