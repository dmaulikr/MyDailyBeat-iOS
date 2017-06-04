//
//  EVCTabBarController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 3/2/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import UIKit

class EVCTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tab = self.tabBar
        if let items = tab.items {
            for item in items {
                if let image = item.image, let selected = item.selectedImage {
                    item.image = EVCCommonMethods.image(with: image, scaledTo: CGSize(width: 30, height: 30)).withRenderingMode(.automatic)
                    item.selectedImage = EVCCommonMethods.image(with: selected, scaledTo: CGSize(width: 30, height: 30)).withRenderingMode(.alwaysOriginal)
                }
            }
        }
        
        // Do any additional setup after loading the view.
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
