//
//  RootViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 2/20/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import UIKit
import RESideMenu
import API
import Chronos
class RootViewController: RESideMenu, RESideMenuDelegate {

    var timer: DispatchTimer?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let SEC_PER_DAY: TimeInterval = 3600 * 24
        timer = DispatchTimer(interval: SEC_PER_DAY, closure: { (timer, count) in
            var result = RestAPI.getInstance().validateToken()
            if !result {
                let alertController = UIAlertController(title: "Session Expired", message: "Your session has expired. For your security, please login to MyDailyBeat.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.navigationController?.present(alertController, animated: true, completion: { 
                    _ = self.navigationController?.popToRootViewController(animated: true)
                })
            }
        }, queue: DispatchQueue.global())
        timer?.start(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.cancel()
        timer = nil
    }
    
    func sideMenu(_ sideMenu: RESideMenu!, didShowMenuViewController menuViewController: UIViewController!) {
        menuViewController.viewDidAppear(true)
    }
    
    func sideMenu(_ sideMenu: RESideMenu!, didHideMenuViewController menuViewController: UIViewController!) {
        menuViewController.viewDidDisappear(true)
    }
    
    func sideMenu(_ sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {
        menuViewController.viewWillAppear(true)
    }
    
    func sideMenu(_ sideMenu: RESideMenu!, willHideMenuViewController menuViewController: UIViewController!) {
        menuViewController.viewWillDisappear(true)
    }

    
    
    override func awakeFromNib() {
        self.contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "contentViewController")
        self.leftMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "leftMenuViewController")
        self.rightMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "rightMenuViewController")
        self.backgroundImage = EVCCommonMethods.image(with: UIColor(netHex: 0x0097a4), size: self.view.frame.size)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController {
    
    func showModalViewController(_ vc: UIViewController, animated: Bool, completion: (() -> ())?) {
        if let outerNav = self.sideMenuViewController.contentViewController as? UINavigationController {
            outerNav.present(vc, animated: animated, completion: completion)
        }
    }
    
    func showModalSegue(withIdentifier identifier: String, andSender sender: Any?) {
        if let outerNav = self.sideMenuViewController.contentViewController as? UINavigationController, let root = outerNav.viewControllers[0] as? RootNavController{
            root.performSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
    func showAboutScreen() {
        self.sideMenuViewController.hideViewController()
        self.sideMenuViewController.contentViewController.performSegue(withIdentifier: "AboutSegue", sender: nil)
    }
    
    func performEmbeddedSegue(withIdentifier identifier: String, andSender sender: Any?) {
        if let outerNav = self.sideMenuViewController.contentViewController as? UINavigationController, let root = outerNav.viewControllers[0] as? RootNavController, let innerNav = root.embedded {
            self.sideMenuViewController.hideViewController()
            innerNav.popToRootViewController(animated: true)
            innerNav.visibleViewController?.performSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
    func setNavTitle(to title: String) {
        if let outerNav = self.sideMenuViewController.contentViewController as? UINavigationController, let root = outerNav.viewControllers[0] as? RootNavController {
            root.navigationItem.title = title
        }
    }
    
    func performRequestToNetwork(request: @escaping (() -> ()), andOnComplete: (() -> ())) {
        let semaphore = DispatchSemaphore(value: 0)
        self.view.makeToastActivity(.center)
        DispatchQueue.global().async {
            request()
            semaphore.signal()
        }
        
        semaphore.wait()
        andOnComplete()
        self.view.hideToastActivity()
    }
}
