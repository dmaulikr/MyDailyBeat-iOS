
//
//  EVCTextFieldTableViewCell.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/18/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import UIKit
class EVCTextFieldTableViewCell: UITableViewCell {
    @IBOutlet var textField: UITextField!
    var placeHolderText: String = ""


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
