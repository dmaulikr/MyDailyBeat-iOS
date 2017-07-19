
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
    var provider: PrescripProviderInfo?
    var portal: HealthInfo?

    @IBAction func go(toProvider sender: Any) {
        if let provider = self.provider {
            let trueU: String = "http://www." + provider.url
            self.openURLinBrowser(trueU)
        }
    }

    @IBAction func go(toPortal sender: Any) {
        if let portal = self.portal {
            self.openURLinBrowser(portal.url)
        }
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let data1: Data? = UserDefaults.standard.object(forKey: "myHealthPortal") as? Data
        if let portal = data1, let temp1 = NSKeyedUnarchiver.unarchiveObject(with: portal) as? HealthInfo {
            self.portal = temp1
        }
        let data2: Data? = UserDefaults.standard.object(forKey: "myPrescripProvider") as? Data
        if let provider = data2, let temp2 = NSKeyedUnarchiver.unarchiveObject(with: provider) as? PrescripProviderInfo {
            self.provider = temp2
        }
        self.setup()
    }

    

    func setup() {
        if let provider = self.provider {
            if provider.logoURL != "" {
                
                DispatchQueue.global().async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.makeToastActivity(ToastPosition.center)
                    })
                    if let imgurl = URL(string: provider.logoURL) {
                        let data = RestAPI.getInstance().fetchImage(atRemoteURL: imgurl)
                        let img = UIImage(data: data)
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.view.hideToastActivity()
                            self.prescripProviderLogoView.image = EVCCommonMethods.image(with: img!, scaledTo: CGSize(width: CGFloat(304), height: CGFloat(128)))
                        })
                    } else {
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.view.hideToastActivity()
                        })
                    }
                    
                })
            }
            prescripLabel.text = provider.url
        } else {
            prescripLabel.text = "Prescription Provider not set"
        }
        
        if let portal = self.portal {
            if portal.logoURL != "" {
                
                DispatchQueue.global().async(execute: {() -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.makeToastActivity(ToastPosition.center)
                    })
                    let imgurl = URL(string: portal.logoURL)
                    let data: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imgurl!)
                    let img = UIImage(data: data!)
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.hideToastActivity()
                        self.healthPortalLogoView.image = EVCCommonMethods.image(with: img!, scaledTo: CGSize(width: CGFloat(304), height: CGFloat(128)))
                    })
                })
            }
            
            portalLabel.text = portal.url
        } else {
            portalLabel.text = "Health Portal not set"
        }
    }

    func openURLinBrowser(_ url: String) {
        let fullURL: String
        if url.hasPrefix("http://") || url.hasPrefix("https://") {
            fullURL = "\(url)"
        } else {
            fullURL = "http://\(url)"
        }
        UIApplication.shared.open(URL(string: fullURL)!, options: [:], completionHandler: nil)
    }
}
