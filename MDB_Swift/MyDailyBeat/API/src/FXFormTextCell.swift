//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  FXFormTextCell.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 9/18/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import UIKit
import FXForms
class FXFormTextCell: FXFormDefaultCell {


    override func setUp() {
        self.textLabel?.text = self.field.value as! String?
        self.textLabel?.lineBreakMode = .byWordWrapping
        self.textLabel?.font = UIFont(name: "Helvetica", size: CGFloat(12))
        self.textLabel?.numberOfLines = 0
        self.accessoryType = .none
        self.selectionStyle = .none
    }

    override func update() {
        self.textLabel?.text = self.field.value as! String?
        self.textLabel?.font = UIFont(name: "Helvetica", size: CGFloat(12))
        self.textLabel?.lineBreakMode = .byWordWrapping
        self.textLabel?.numberOfLines = 0
        self.accessoryType = .none
        self.selectionStyle = .none
    }
}
