//
//  AboutDetailsWebViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 6/22/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import UIKit

class AboutDetailsWebViewController: UIViewController {
    @IBOutlet var webView: UIWebView!
    var url: String!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let request = URLRequest(url: URL(string: self.url)!)
        self.webView.loadRequest(request)
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
