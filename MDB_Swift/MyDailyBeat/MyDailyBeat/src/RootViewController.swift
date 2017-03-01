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
class RootViewController: RESideMenu {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    func performEmbeddedSegue(withIdentifier identifier: String, andSender sender: Any?) {
        if let outerNav = self.sideMenuViewController.contentViewController as? UINavigationController, let root = outerNav.viewControllers[0] as? RootNavController, let innerNav = root.embedded {
            self.sideMenuViewController.hideViewController()
            innerNav.popToRootViewController(animated: true)
            innerNav.visibleViewController?.performSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
    func returnToEmbeddedHome() {
        if let outerNav = self.sideMenuViewController.contentViewController as? UINavigationController, let root = outerNav.viewControllers[0] as? RootNavController, let innerNav = root.embedded {
            self.sideMenuViewController.hideViewController()
            innerNav.popToRootViewController(animated: true)
        }
    }
}
