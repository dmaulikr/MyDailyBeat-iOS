
//
//  EVCJobsDetailsViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/28/15.
//  Copyright © 2015 eVerveCorp. All rights reserved.
//
import UIKit
import RESideMenu
import API
import SwiftyJSON
class EVCJobsDetailsViewController: UIViewController {
    var jobEntry = JSON("")
    @IBOutlet var jobtitleLabel: UILabel!
    @IBOutlet var companyLabel: UILabel!
    @IBOutlet var locLabel: UILabel!
    @IBOutlet var snippetLabel: UILabel!
    @IBOutlet var urlTextView: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        self.jobtitleLabel.text = self.jobEntry["jobtitle"].stringValue
        self.companyLabel.text = self.jobEntry["company"].stringValue
        self.locLabel.text = self.jobEntry["formattedLocationFull"].stringValue
        self.snippetLabel.text = self.jobEntry["snippet"].stringValue
        self.urlTextView.text = self.jobEntry["url"].stringValue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
import API
