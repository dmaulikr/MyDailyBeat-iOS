//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  GroupPrefs.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/17/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//
import Foundation
public class GroupPrefs: NSObject {
    public var groupPicture: UIImage!
    public var hobbies: [Int: Bool] = [Int: Bool]()

    public init(servingURL: String = "") {
        super.init()
        //self.loadPicture(withServingURL: servingURL)
    
    }


    func loadPicture(withServingURL servingURL: String) {
        
        DispatchQueue.global().async(execute: {() -> Void in
            let imageURL = URL(string: servingURL)
            let imageData: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imageURL!)
            DispatchQueue.main.async(execute: {() -> Void in
                // Update the UI
                self.groupPicture = UIImage(data: imageData!)
            })
        })
    }
    
    public func toggle(key: Int, value: Bool) {
        let values: [Bool] = hobbies.values.filter({ (val) -> Bool in
            return val
        })
        if value && values.count < 3 {
            self.hobbies[key] = value
        } else if !value {
            self.hobbies[key] = value
        }
    }
    
}
