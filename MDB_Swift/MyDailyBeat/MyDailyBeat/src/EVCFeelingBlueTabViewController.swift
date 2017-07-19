
//
//  EVCFeelingBlueTabViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 6/1/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import UIKit
import RESideMenu
class EVCFeelingBlueTabViewController: EVCTabBarController, UITabBarControllerDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let dest = viewController as? EVCResourceLinksTableViewController {
            dest.module = "FeelingBlue"
        }
    }

    

}
