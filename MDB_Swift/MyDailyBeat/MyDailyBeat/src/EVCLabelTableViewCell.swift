
//
//  EVCLabelTableViewCell.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/18/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import UIKit
class EVCLabelTableViewCell: UITableViewCell {
    @IBOutlet var messageLbl: UILabel!
    var message: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        self.messageLbl.text = self.message
    }
}
