//
//  HobbiesRefList.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 5/24/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import UIKit

private var s_list: HobbiesRefList = HobbiesRefList()
public class HobbiesRefList: NSObject {
    open fileprivate(set) var list: [Int: String] = [Int: String]()
    fileprivate var loaded: Bool = false
    override fileprivate init() {
        super.init()
    }
    
    public class func getInstance() -> HobbiesRefList {
        if !s_list.loaded {
            s_list.load()
        }
        return s_list
    }
    
    public func load() {
        let json = RestAPI.getInstance().getHobbiesRefList()
        let arr = json.arrayValue
        for value in arr {
            let id = value["hby_ref_id"].intValue
            let desc = value["hby_dsc"].stringValue
            self.list[id] = desc
        }
        self.loaded = true
    }
}
