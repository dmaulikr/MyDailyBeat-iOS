
//
//  EVCFeelingBlueViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 1/9/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//
import UIKit
import DLAlertView
import API
import Toast_Swift
class EVCFeelingBlueViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let TAG: String = "TAG"

        let cell = UITableViewCell(style: .default, reuseIdentifier: TAG)
        switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Call Suicide Hotline"
                var image = UIImage(named: "suicide.png")
                image = EVCCommonMethods.image(with: image!, scaledTo: CGSize(width: CGFloat(60), height: CGFloat(60)))
                cell.imageView?.image = image
            case 1:
                cell.textLabel?.text = "Call Veterans Hotline"
                var image = UIImage(named: "veterans.png")
                image = EVCCommonMethods.image(with: image!, scaledTo: CGSize(width: CGFloat(60), height: CGFloat(60)))
                cell.imageView?.image = image
            case 2:
                cell.textLabel?.text = "Call Anonymously"
                var image = UIImage(named: "anonymous.png")
                image = EVCCommonMethods.image(with: image!, scaledTo: CGSize(width: CGFloat(60), height: CGFloat(60)))
                cell.imageView?.image = image
            default:
                break
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
            case 0:
                self.makeCall("1-800-273-8255")
            case 1:
                self.makeCall("1-800-273-8255", withAccessCode: "1")
            case 2:
                self.performSegue(withIdentifier: "CallAnonymousSegue", sender: nil)
            default:
                break
        }

    }

    func makeCall(_ num: String, anonymous: Bool = false) {
        var dialstring: String = "tel:\(num)"
        if anonymous {
            dialstring = "tel:*67\(num)"
        }
        let url = URL(string: dialstring)
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: {(_ success: Bool) -> Void in
                if success {
                    self.save(toCallHistoryNumber: num, withAccessCode: "")
                }
            })
        }
        else {
            let alView = UIAlertController(title: "Calling not supported", message: "This device does not support phone calls.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alView.addAction(action)
            self.present(alView, animated: true, completion: nil)
        }
    }

    func makeCall(_ num: String, withAccessCode code: String, anonymous: Bool = false) {
        var dialstring: String = "tel:\(num),,\(code)#"
        if anonymous {
            dialstring = "tel:*67\(num),,\(code)#"
        }
        let url = URL(string: dialstring)
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: {(_ success: Bool) -> Void in
                if success {
                    self.save(toCallHistoryNumber: num, withAccessCode: code)
                }
            })
        }
        else {
            let alView = UIAlertController(title: "Calling not supported", message: "This device does not support phone calls.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alView.addAction(action)
            self.present(alView, animated: true, completion: nil)
        }
    }

    func save(toCallHistoryNumber num: String, withAccessCode code: String?) {
        if code == nil {
            if (num == "1-800-273-8255") {
                    // suicide
                var callHistory = UserDefaults.standard.stringArray(forKey: "callHistory") ?? [String]()
                callHistory.insert("Suicide Hotline", at: 0)
                UserDefaults.standard.set(callHistory, forKey: "callHistory")
            }
            else {
                    // save number
                var callHistory = UserDefaults.standard.stringArray(forKey: "callHistory") ?? [String]()
                callHistory.insert(num, at: 0)
                UserDefaults.standard.set(callHistory, forKey: "callHistory")
            }
        }
        else {
                // veterans
            var callHistory = UserDefaults.standard.stringArray(forKey: "callHistory") ?? [String]()
            callHistory.insert("Veterans' Hotline", at: 0)
            UserDefaults.standard.set(callHistory, forKey: "callHistory")
        }
        UserDefaults.standard.synchronize()
    }
}
