
//
//  EVCFinanceViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/29/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//
import UIKit
import RESideMenu
class EVCFinanceViewController: EVCTabBarController, UITabBarControllerDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let dest = viewController as? EVCResourceLinksTableViewController {
            dest.module = "Finance"
        }
    }
    

    
}
