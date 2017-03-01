
//
//  EVCRegistrationMessageViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/19/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import UIKit
import API
class EVCRegistrationMessageViewController: UIViewController {

    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var nextButton: UIButton!
    var message: String = ""
    var key: Int = 0

    @IBAction func next(_ sender: Any) {
        if self.key == 1 {
            self.message1()
        }
        else {
            self.message2()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = self.message
        self.navigationController?.navigationBar.tintColor = UIColor(netHex: 0x0097a4)
    }

    func message1() {
//        var message2 = EVCRegistrationMessageViewController(coder: 2)
//        self.navigationController?.pushViewController(message2, animated: true)
    }

    func message2() {
//        let controller = EVCRegistrationViewController()
//        self.navigationController?.pushViewController(controller, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
