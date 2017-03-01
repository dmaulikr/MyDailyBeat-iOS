
//
//  EVCProfileViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/21/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import UIKit
import QuartzCore
import Toast_Swift
import API
import PhoneNumberKit
class EVCProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var profilePicView: UIImageView!
    var profilePic: UIImage!
    @IBOutlet var mTableView: UITableView!
    @IBOutlet var mScreenNameLabel: UILabel!

    func reloadData() {
        self.refreshUserData()
        self.mTableView.reloadData()
        self.loadProfilePicture()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.mTableView.delegate = self
        self.mTableView.dataSource = self
        self.mTableView.isOpaque = false
        self.mTableView.backgroundColor = UIColor.clear
        self.mTableView.separatorStyle = .none
        self.mTableView.bounces = false
        self.view.backgroundColor = UIColor.clear
        self.mTableView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth]
        self.mScreenNameLabel.text = RestAPI.getInstance().getCurrentUser().screenName
        self.mScreenNameLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(16))
        self.mScreenNameLabel.textColor = UIColor.white
        self.profilePicView.layer.cornerRadius = 50
        self.profilePicView.clipsToBounds = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadData()
    }

    func refreshUserData() {
        let queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
                RestAPI.getInstance().refreshCurrentUserData()
                self.view.hideToastActivity()
            })
        })
    }

    func loadProfilePicture() {
        let queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            let imageURL: URL? = RestAPI.getInstance().retrieveProfilePicture()
            if imageURL == nil {
                return
            }
            let imageData: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imageURL!)
            DispatchQueue.main.async(execute: {() -> Void in
                // Update the UI
                self.profilePic = UIImage(data: imageData!)
                self.profilePic = EVCCommonMethods.image(with: self.profilePic, scaledTo: CGSize(width: CGFloat(100), height: CGFloat(100)))
                self.profilePicView.image = self.profilePic
            })
        })
    }

    func logout() {
        var queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
                _ = RestAPI.getInstance().logout()
                self.view.hideToastActivity()
                var login = EVCLoginViewController(nibName: "EVCLoginViewController_iPhone", bundle: nil)
                self.sideMenuViewController.contentViewController.view.window?.rootViewController = UINavigationController(rootViewController: login)
                UserDefaults.standard.removeObject(forKey: KEY_SCREENNAME)
                UserDefaults.standard.removeObject(forKey: KEY_PASSWORD)
                _ = self.sideMenuViewController.contentViewController.navigationController?.popToRootViewController(animated: true)
            })
        })
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            self.sideMenuViewController.hideViewController()
            return
        }
        else {
            switch indexPath.row {
                case 0:
                    self.performSegue(withIdentifier: "UpdateProfileSegue", sender: nil)
                case 1:
                    self.sideMenuViewController.hideViewController()
                    self.sideMenuViewController.contentViewController.performSegue(withIdentifier: "PrefsSegue", sender: nil)
                case 2:
                    var mailto: String = "mailto:legal@evervecorp.com?subject=\(RestAPI.getInstance().urlencode("Report a Violation"))"
                    print("Opening mailto")
                    UIApplication.shared.openURL(URL(string: mailto)!)
                case 3:
                    self.logout()
                default:
                    break
            }
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }

func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 5
            case 1:
                return 4
            default:
                return 1
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier: String = "CellIdentifier"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        cell?.backgroundColor = UIColor.clear
        cell?.textLabel?.font = UIFont(name: "HelveticaNeue", size: CGFloat(16))
        cell?.textLabel?.textColor = UIColor.white
        cell?.textLabel?.highlightedTextColor = UIColor.lightGray
        cell?.detailTextLabel?.font = UIFont(name: "HelveticaNeue", size: CGFloat(10))
        cell?.detailTextLabel?.textColor = UIColor.white
        cell?.detailTextLabel?.highlightedTextColor = UIColor.lightGray
        cell?.selectedBackgroundView = UIView()
        if indexPath.section == 0 {
            switch indexPath.row {
                case 0:
                    cell?.textLabel?.text = "Name"
                    cell?.detailTextLabel?.text = RestAPI.getInstance().getCurrentUser().name
                case 1:
                    cell?.textLabel?.text = "Email"
                    cell?.detailTextLabel?.text = RestAPI.getInstance().getCurrentUser().email
                case 2:
                    cell?.textLabel?.text = "Mobile"
                    var mobile: String = RestAPI.getInstance().getCurrentUser().mobile
                    let kit = PhoneNumberKit()
                    do {
                        let phonenumber = try kit.parse(mobile)
                        mobile = kit.format(phonenumber, toType: .national)
                    } catch {
                        
                        
                    }
                case 3:
                    cell?.textLabel?.text = "DOB"
                    var dob: String = RestAPI.getInstance().getCurrentUser().birth_month
                    cell?.detailTextLabel?.text = "\(dob) \(RestAPI.getInstance().getCurrentUser().birth_year)"
                case 4:
                    cell?.textLabel?.text = "Zip Code"
                    cell?.detailTextLabel?.text = RestAPI.getInstance().getCurrentUser().zipcode
                default:
                    cell?.detailTextLabel?.text = ""
            }
        }
        else {
            if indexPath.row == 0 {
                cell?.textLabel?.text = "Edit Profile"
            }
            else if indexPath.row == 1 {
                cell?.textLabel?.text = "Preferences"
            }
            else if indexPath.row == 2 {
                cell?.textLabel?.text = "Report Violations"
            }
            else {
                cell?.textLabel?.text = "Logout"
            }
        }
        return cell!
    }
}
