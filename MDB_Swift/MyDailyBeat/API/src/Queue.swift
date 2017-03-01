//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  Queue.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 6/1/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import Foundation
class Queue: NSObject {

    var queue = [Any]()

    override init() {
        super.init()
        
        self.queue = [Any]()
    
    }

    func push(_ object: Any) {
        self.queue.append(object)
    }

    func pop() -> Any {
        var retval: Any? = self.queue[0]
        self.queue.remove(at: 0)
        return retval!
    }
}