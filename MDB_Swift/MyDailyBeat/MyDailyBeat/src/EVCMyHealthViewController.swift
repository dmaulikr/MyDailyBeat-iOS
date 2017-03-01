
//
//  EVCMyHealthViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 5/30/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import UIKit
import Toast_Swift
import API
class EVCMyHealthViewController: UIViewController {

    @IBOutlet var prescripProviderLogoView: UIImageView!
    @IBOutlet var healthPortalLogoView: UIImageView!
    @IBOutlet var prescripLabel: UILabel!
    @IBOutlet var portalLabel: UILabel!
    @IBOutlet var prescripTap: UITapGestureRecognizer!
    @IBOutlet var healthTap: UITapGestureRecognizer!
    var provider: PrescripProviderInfo!
    var portal: HealthInfo!

    @IBAction func go(toProvider sender: Any) {
        if self.provider != nil {
            let trueU: String = "http://www." + self.provider.url
            self.openURLinBrowser(trueU)
        }
    }

    @IBAction func go(toPortal sender: Any) {
        if self.portal != nil {
            self.openURLinBrowser(self.portal.url)
        }
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let data1: Data? = UserDefaults.standard.object(forKey: "myHealthPortal") as! Data?
        let temp1: HealthInfo? = NSKeyedUnarchiver.unarchiveObject(with: data1!) as? HealthInfo
        if temp1 != nil {
            self.portal = temp1
        }
        let data2: Data? = UserDefaults.standard.object(forKey: "myPrescripProvider") as! Data?
        let temp2: PrescripProviderInfo? = NSKeyedUnarchiver.unarchiveObject(with: data2!) as? PrescripProviderInfo
        if temp2 != nil {
            self.provider = temp2
        }
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setup() {
        if self.provider != nil && self.portal != nil {
            if !(self.portal.logoURL == "") {
                let queue = DispatchQueue(label: "dispatch_queue_t_dialog")
                queue.async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.makeToastActivity(ToastPosition.center)
                    })
                    let imgurl = URL(string: self.portal.logoURL)
                    let data: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imgurl!)
                    let img = UIImage(data: data!)
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.hideToastActivity()
                        self.healthPortalLogoView.image = EVCCommonMethods.image(with: img!, scaledTo: CGSize(width: CGFloat(304), height: CGFloat(128)))
                    })
                })
            }
            else {
                let img = UIImage(named: "404-logo")
                healthPortalLogoView.image = EVCCommonMethods.image(with: img!, scaledTo: CGSize(width: CGFloat(304), height: CGFloat(128)))
            }
            if !(self.provider.logoURL == "") {
                let queue = DispatchQueue(label: "dispatch_queue_t_dialog")
                queue.async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.makeToastActivity(ToastPosition.center)
                    })
                    let imgurl = URL(string: self.provider.logoURL)
                    let data: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imgurl!)
                    let img = UIImage(data: data!)
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.hideToastActivity()
                        self.prescripProviderLogoView.image = EVCCommonMethods.image(with: img!, scaledTo: CGSize(width: CGFloat(304), height: CGFloat(128)))
                    })
                })
            }
            else {
                let img = UIImage(named: "404-logo")
                prescripProviderLogoView.image = EVCCommonMethods.image(with: img!, scaledTo: CGSize(width: CGFloat(304), height: CGFloat(128)))
            }
            prescripLabel.text = self.provider.url
            portalLabel.text = self.portal.url
        }
        else {
            prescripLabel.text = "Prescription Provider not set"
            portalLabel.text = "Health Portal not set"
        }
    }

    func openURLinBrowser(_ url: String) {
        let fullURL: String = "\(url)"
        UIApplication.shared.openURL(URL(string: fullURL)!)
    }
}
