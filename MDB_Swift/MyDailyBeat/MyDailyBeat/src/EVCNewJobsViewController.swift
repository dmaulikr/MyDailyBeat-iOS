//
//  EVCNewJobsViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 5/13/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import UIKit

class EVCNewJobsViewController: UIViewController {
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "http://retirementjobs.com")!
        let request = URLRequest(url: url)
        self.webView.loadRequest(request)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
