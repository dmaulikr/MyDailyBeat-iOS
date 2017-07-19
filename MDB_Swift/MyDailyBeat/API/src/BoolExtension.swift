//
//  BoolExtension.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 2/20/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import Foundation

extension Bool {
    func toInt() -> Int {
        if self {
            return 1
        }
        return 0
    }
}

extension Int {
    func toBool() -> Bool {
        if self == 0 {
            return false
        }
        
        return true
    }
}
