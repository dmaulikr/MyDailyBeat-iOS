//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  Stack.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 6/1/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import Foundation
class Stack: NSObject {

    var top: Int = 0
    var stack = [Any]()

    override init() {
        super.init()
        
        self.top = 0
        self.stack = [Any]()
    
    }

    func push(_ object: Any) {
        self.stack.append(object)
        self.top = self.top + 1
    }

    func pop() -> Any {
        let retval: Any? = self.stack[self.top]
        self.stack.remove(at: self.top)
        self.top = self.top - 1
        return retval!
    }
}
