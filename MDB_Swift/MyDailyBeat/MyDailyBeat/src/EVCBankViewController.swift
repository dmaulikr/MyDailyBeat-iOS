
//
//  EVCBankViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 5/28/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import UIKit
import Toast_Swift
import API
class EVCBankViewController: UIViewController {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var btn: UIButton!
    @IBOutlet var bankNameLbl: UILabel!
    @IBOutlet var nilLabel: UILabel!
    var bank: BankInfo!

    @IBAction func gotoBank(_ sender: Any) {
        let appURL: String = self.bank.appURL
        UIApplication.shared.open(URL(string: appURL)!, options: [:], completionHandler: nil)
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        self.retrieveBankData()
    }

    override func viewDidAppear(_ animated: Bool) {
        var data: Data? = UserDefaults.standard.object(forKey: "myBank") as! Data?
        if let bankData = data, let temp =  NSKeyedUnarchiver.unarchiveObject(with: bankData) as? BankInfo {
            self.bank = temp
            self.retrieveBankData()
        }
    }

    

    func isAppInstalled(_ name: String) -> Bool {
        var realname = name.replacingOccurrences(of: " ", with: "-")
        return UIApplication.shared.canOpenURL(URL(string: realname + "://")!)
    }

    func doesAppExist(_ name: String) -> Bool {
        var val: Bool = false
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            val = RestAPI.getInstance().doesAppExist(withTerm: name, andCountry: "US")
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
            })
        })
        return val
    }

    func retrieveBankData() {
        if self.bank != nil {
            nilLabel.isHidden = true
            imgView.isHidden = false
            btn.isHidden = false
            bankNameLbl.isHidden = false
            
            DispatchQueue.global().async(execute: {() -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.makeToastActivity(ToastPosition.center)
                })
                var imgurl = URL(string: self.bank.iconURL)
                var data: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imgurl!)
                var img = UIImage(data: data!)
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.hideToastActivity()
                    self.imgView.image = EVCCommonMethods.image(with: img!, scaledTo: CGSize(width: CGFloat(120), height: CGFloat(120)))
                    self.bankNameLbl.text = self.bank.appName
                })
            })
        }
        else {
            nilLabel.isHidden = false
            imgView.isHidden = true
            btn.isHidden = true
            bankNameLbl.isHidden = true
            nilLabel.text = "My Bank not Set"
        }
    }
}
