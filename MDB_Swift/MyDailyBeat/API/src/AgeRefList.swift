//
//  AgeRefList.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 5/27/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import UIKit

private var s_list: AgeRefList = AgeRefList()
public class AgeRefList: NSObject {
    open fileprivate(set) var list: [Int: (min: Int, max: Int)] = [Int: (min: Int, max: Int)]()
    fileprivate var loaded: Bool = false
    override fileprivate init() {
        super.init()
    }
    
    public class func getInstance() -> AgeRefList {
        if !s_list.loaded {
            s_list.load()
        }
        return s_list
    }
    
    public func load() {
        let json = RestAPI.getInstance().getAgeRefList()
        let arr = json.arrayValue
        for value in arr {
            let id = value["age_ref_id"].intValue
            let min = value["age_min"].intValue
            let max = value["age_max"].intValue
            list[id] = (min: min, max: max)
        }
        self.loaded = true
    }
}

public class AgeValueTransformer: ValueTransformer {
    override public class func transformedValueClass() -> AnyClass {
        return NSString.self
    }
    
    override public class func allowsReverseTransformation() -> Bool {
        return false
    }
    
    override public func transformedValue(_ value: Any?) -> Any? {
        let list = AgeRefList.getInstance().list
        let index = value as? Int ?? 0
        let values = list[index] ?? (min: 50, max: 54)
        guard values.max < 120 else {
            return "\(values.min)+"
        }
        return "\(values.min) - \(values.max)"
    }
    
    
}
