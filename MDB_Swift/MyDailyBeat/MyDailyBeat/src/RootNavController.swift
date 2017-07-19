//
//  RootNavController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 2/28/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import UIKit

class RootNavController: UIViewController {
    @IBOutlet var profileButton: UIBarButtonItem!
    @IBOutlet var menuButton: UIBarButtonItem!
    var embedded: UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        let image3 = EVCCommonMethods.image(with: UIImage(named: "hamburger-icon-white")!, scaledTo: CGSize(width: CGFloat(30), height: CGFloat(30)))
        self.menuButton.image = image3.withRenderingMode(.alwaysOriginal)
        self.menuButton.title = ""
        let image4 = EVCCommonMethods.image(with: UIImage(named: "profile-icon-white")!, scaledTo: CGSize(width: CGFloat(30), height: CGFloat(30)))
        self.profileButton.image = image4.withRenderingMode(.alwaysOriginal)
        self.profileButton.title = ""
        // Do any additional setup after loading the view.
    }

    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let dest = segue.destination as? UINavigationController {
            dest.setNavigationBarHidden(true, animated: false)
            self.embedded = dest
        }
    }
    
    @IBAction func modalUnwindSegue(segue: UIStoryboardSegue) {
        
    }
    

}
