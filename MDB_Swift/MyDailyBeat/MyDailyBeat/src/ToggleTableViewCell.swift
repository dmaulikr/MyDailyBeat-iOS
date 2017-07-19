//
//  ToggleTableViewCell.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 5/29/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import UIKit

class ToggleTableViewCell: UITableViewCell {
    var toggleSwitch: UISwitch!
    var onToggle: (() -> ()) = {
        
    }
    
    func update() {
        self.toggleSwitch = UISwitch()
        self.toggleSwitch.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        self.accessoryView = self.toggleSwitch
    }
    
    func valueChanged() {
        self.onToggle()
    }

}
