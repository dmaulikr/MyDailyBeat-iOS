
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

    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reloadData()
    }

    func refreshUserData() {
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            RestAPI.getInstance().refreshCurrentUserData()
            DispatchQueue.main.async {
                self.view.hideToastActivity()
            }
        })
    }

    func loadProfilePicture() {
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            let imageURL: URL? = RestAPI.getInstance().retrieveProfilePicture()
            if imageURL == nil {
                DispatchQueue.main.async {
                    self.view.hideToastActivity()
                }
                return
            }
            let imageData: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imageURL!)
            DispatchQueue.main.async(execute: {() -> Void in
                // Update the UI
                self.profilePic = UIImage(data: imageData!)
                self.profilePic = EVCCommonMethods.image(with: self.profilePic, scaledTo: CGSize(width: CGFloat(100), height: CGFloat(100)))
                self.profilePicView.image = self.profilePic
                self.view.hideToastActivity()
            })
        })
    }

    func logout() {
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            _ = RestAPI.getInstance().logout()
            UserDefaults.standard.removeObject(forKey: KEY_SCREENNAME)
            UserDefaults.standard.removeObject(forKey: KEY_PASSWORD)
            DispatchQueue.main.async {
                self.view.hideToastActivity()
                _ = self.sideMenuViewController.navigationController?.popToRootViewController(animated: true)
            }
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
                    self.performEmbeddedSegue(withIdentifier: "PrefsSegue", andSender: self)
                case 2:
                    let mailto: String = "mailto:legal@mydailybeat.com?subject=\(RestAPI.getInstance().urlencode("Report a Violation"))"
                    UIApplication.shared.open(URL(string: mailto)!, options: [:], completionHandler: nil)
                case 4:
                    self.logout()
                case 3:
                    self.showAboutScreen()
                    
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
        if section == 0 {
            return 6
        } else {
            return 5
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "CellIdentifier"
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
                    cell?.textLabel?.text = "First Name"
                    cell?.detailTextLabel?.text = RestAPI.getInstance().getCurrentUser().firstName
                case 1:
                    cell?.textLabel?.text = "Last Name"
                    cell?.detailTextLabel?.text = RestAPI.getInstance().getCurrentUser().lastName
                case 2:
                    cell?.textLabel?.text = "Email"
                    cell?.detailTextLabel?.text = RestAPI.getInstance().getCurrentUser().email
                case 3:
                    cell?.textLabel?.text = "Mobile"
                    var mobile: String = RestAPI.getInstance().getCurrentUser().mobile
                    let kit = PhoneNumberKit()
                    do {
                        let phonenumber = try kit.parse(mobile)
                        mobile = kit.format(phonenumber, toType: .national)
                    } catch {
                        
                        
                    }
                case 4:
                    cell?.textLabel?.text = "DOB"
                    let formatter = DateFormatter()
                    formatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d, yyyy")
                    cell?.detailTextLabel?.text = formatter.string(from: RestAPI.getInstance().getCurrentUser().dob)
                case 5:
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
            else if indexPath.row == 4 {
                cell?.textLabel?.text = "Logout"
            } else {
                cell?.textLabel?.text = "About"
            }
        }
        return cell!
    }
}
