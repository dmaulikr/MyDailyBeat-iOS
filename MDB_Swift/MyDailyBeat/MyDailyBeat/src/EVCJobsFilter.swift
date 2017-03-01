
//
//  EVCJobsFilter.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/1/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import UIKit
enum JobType : Int {
    case all = 0
    case full_TIME = 1
    case part_TIME = 2
}

enum JobSearchRadius : Int {
    case twenty_FIVE_MILES = 0
    case fifty_MILES = 1
    case seventy_FIVE_MILES = 2
    case one_HUNDRED_MILES = 3
}

protocol EVCJobsFilterDelegate: NSObjectProtocol {
    func update(_ type: JobType, andRadius radius: JobSearchRadius)
}
class EVCJobsFilter: UIView {

    @IBOutlet var jobType: UISegmentedControl!
    @IBOutlet var searchRadius: UISegmentedControl!
    @IBOutlet var filterButton: UIButton!
    weak var delegate: EVCJobsFilterDelegate?
    var currentQuery: String = ""
    var jType = JobType(rawValue: 0)
    var sRadius = JobSearchRadius(rawValue: 0)

    @IBAction func filter(_ sender: Any) {
        self.delegate?.update(self.jType!, andRadius: self.sRadius!)
    }

    @IBAction func jobTypeChanged(_ sender: Any) {
        switch jobType.selectedSegmentIndex {
            case 0:
                self.jType = .all
            case 1:
                self.jType = .full_TIME
            case 2:
                self.jType = .part_TIME
            default:
                break
        }

    }

    @IBAction func searchRadiusChanged(_ sender: Any) {
        switch searchRadius.selectedSegmentIndex {
            case 0:
                self.sRadius = .twenty_FIVE_MILES
            case 1:
                self.sRadius = .fifty_MILES
            case 2:
                self.sRadius = .seventy_FIVE_MILES
            case 3:
                self.sRadius = .one_HUNDRED_MILES
            default:
                break
        }

    }

}
