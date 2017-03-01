
//
//  EVCMenuTableViewCell.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/21/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//
import UIKit
class EVCMenuTableViewCell: UITableViewCell {
    var imgView: UIImageView!
    var lbl: UILabel!

    convenience init(frame: CGRect, andTag tag: String) {
        self.init(frame: frame)
        
        if (tag == "feelingBlue") {
            self.lbl = UILabel(frame: CGRect(x: CGFloat(8), y: CGFloat(8), width: CGFloat(260), height: CGFloat(43)))
            self.imgView = UIImageView(frame: CGRect(x: CGFloat(275), y: CGFloat(15), width: CGFloat(30), height: CGFloat(30)))
            var placeholder = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(51), width: CGFloat(320), height: CGFloat(8)))
            self.contentView.addSubview(placeholder)
        }
        else {
            self.lbl = UILabel(frame: CGRect(x: CGFloat(8), y: CGFloat(8), width: CGFloat(260), height: CGFloat(29)))
            self.imgView = UIImageView(frame: CGRect(x: CGFloat(277), y: CGFloat(6), width: CGFloat(30), height: CGFloat(30)))
        }
        lbl.textAlignment = .right
        self.contentView.addSubview(lbl)
        self.contentView.addSubview(imgView)
    
    }


    override func awakeFromNib() {
        // Initialization code
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
