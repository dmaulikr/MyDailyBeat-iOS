//
//  EthnicityRefList.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 5/28/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import UIKit

private var s_list: EthnicityRefList = EthnicityRefList()
public class EthnicityRefList: NSObject {
    open fileprivate(set) var list: [Int: String] = [Int: String]()
    fileprivate var loaded: Bool = false
    override fileprivate init() {
        super.init()
    }
    
    public class func getInstance() -> EthnicityRefList {
        if !s_list.loaded {
            s_list.load()
        }
        return s_list
    }
    
    public func load() {
        let json = RestAPI.getInstance().getEthnicityRefList()
        let arr = json.arrayValue
        for value in arr {
            let id = value["ethnct_ref_id"].intValue
            let desc = value["ethnct_dsc"].stringValue
            list[id] = desc
        }
        self.loaded = true
    }
}

public class EthnicityValueTransformer: ValueTransformer {
    override public class func transformedValueClass() -> AnyClass {
        return NSString.self
    }
    
    override public class func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override public func transformedValue(_ value: Any?) -> Any? {
        let list = EthnicityRefList.getInstance().list
        let index = value as? Int ?? 0
        return list[index]
    }
    
    
}
