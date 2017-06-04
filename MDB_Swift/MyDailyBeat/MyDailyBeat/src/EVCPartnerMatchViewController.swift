
//
//  EVCPartnerMatchViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/21/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import UIKit
import Toast_Swift
import API
class EVCPartnerMatchViewController: UITableViewController {
    var partners = [FlingProfile]()
    var partnerUsers = [VerveUser]()
    var mode: REL_MODE = .friends_MODE


    override func viewDidLoad() {
        super.viewDidLoad()
        self.partners = [FlingProfile]()
        if self.mode == .friends_MODE {
            let image3 = EVCCommonMethods.image(with: UIImage(named: "search-icon-white")!, scaledTo: CGSize(width: CGFloat(30), height: CGFloat(30)))
            let frameimg = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(image3.size.width), height: CGFloat(image3.size.height))
            let someButton = UIButton(frame: frameimg)
            someButton.setBackgroundImage(image3, for: .normal)
            someButton.addTarget(self, action: #selector(self.searchFriend), for: .touchUpInside)
            someButton.showsTouchWhenHighlighted = true
            let menuButton = UIBarButtonItem(customView: someButton)
            self.navigationItem.rightBarButtonItem = menuButton
        }
        self.retrievePartners()
    }

    func searchFriend() {
        let alert = UIAlertController(title: "Add Friend", message: "Fill in at least 1 of the following fields:", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Screen Name"
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.autocorrectionType = .no
        }
        alert.addTextField { (textField) in
            textField.placeholder = "E-mail Address"
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.keyboardType = .emailAddress
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Mobile"
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.keyboardType = .phonePad
        }
        _ = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // do nothing
        }
        _ = UIAlertAction(title: "OK", style: .default) { (action) in
            let screenName: String = alert.textFields![0].text!
            let name: String = alert.textFields![1].text!
            let email: String = alert.textFields![2].text!
            let mobile: String = alert.textFields![3].text!
            let queue = DispatchQueue.global()
            DispatchQueue.global().async(execute: {() -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.makeToastActivity(ToastPosition.center)
                })
                if screenName != "" {
                    // search by Screen Name
                    let exists: Bool = RestAPI.getInstance().doesUserExist(withScreenName: screenName)
                    if exists {
//                        let other: VerveUser? = RestAPI.getInstance().getUserData(for: screenName)
                        //_ = RestAPI.getInstance().add(other!, toFriendsOf: RestAPI.getInstance().getCurrentUser())
                    }
                    else {
                        // a user with that screenName does not exist.
                        if name != "" && email != "" {
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.view.hideToastActivity()
                                self.refer(name, andEmail: email)
                            })
                        }
                        else {
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.view.hideToastActivity()
                                self.referWithNoInformation()
                            })
                        }
                    }
                }
                else {
                    // search by name, email, or mobile
                    let existsName: Bool = (name != "") ? RestAPI.getInstance().doesUserExist(withName: name) : false
                    let existsEmail: Bool = (email != "") ? RestAPI.getInstance().doesUserExist(withEmail: email) : false
                    let existsMobile: Bool = (mobile != "") ? RestAPI.getInstance().doesUserExist(withMobile: mobile) : false
                    let exists: Bool = existsName || existsEmail || existsMobile
                    if exists {
//                        if existsName {
//                            var other: VerveUser? = RestAPI.getInstance().getUserDataForUser(withName: name)
//                            RestAPI.getInstance().add(other!, toFriendsOf: RestAPI.getInstance().getCurrentUser())
//                        }
//                        else if existsEmail {
//                            var other: VerveUser? = RestAPI.getInstance().getUserDataForUser(withEmail: email)
//                            RestAPI.getInstance().add(other!, toFriendsOf: RestAPI.getInstance().getCurrentUser())
//                        }
//                        else if existsMobile {
//                            var other: VerveUser? = RestAPI.getInstance().getUserDataForUser(withMobile: mobile)
//                            RestAPI.getInstance().add(other!, toFriendsOf: RestAPI.getInstance().getCurrentUser())
//                        }
                    }
                    else {
                        if name != "" && email != "" {
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.view.hideToastActivity()
                                self.refer(name, andEmail: email)
                            })
                        }
                        else {
                            DispatchQueue.main.async(execute: {() -> Void in
                                self.view.hideToastActivity()
                                self.referWithNoInformation()
                            })
                        }
                    }
                }
            })

        }
    }

    func referWithNoInformation() {
        let alert = UIAlertController(title: "Refer a Friend", message: "No such user with that information exists. If you would like to invite this person to join MyDailyBeat, enter their name and email address.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.autocorrectionType = .no
        }
        alert.addTextField { (textField) in
            textField.placeholder = "E-mail Address"
            textField.autocapitalizationType = .none
            textField.autocorrectionType = .no
            textField.keyboardType = .emailAddress
        }
        _ = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // do nothing
        }
        _ = UIAlertAction(title: "Invite", style: .default) { (action) in
            let name: String = alert.textFields![0].text!
            let email: String = alert.textFields![1].text!
            let queue = DispatchQueue.global()
            DispatchQueue.global().async(execute: {() -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.makeToastActivity(ToastPosition.center)
                })
                let result: Bool = RestAPI.getInstance().sendReferral(from: RestAPI.getInstance().getCurrentUser(), toPersonWithName: name, andEmail: email)
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.hideToastActivity()
                    if result {
                        self.view.makeToast("Referral sent successfully!", duration: 3.5, position: .bottom)
                    }
                    else {
                        self.view.makeToast("Could not send referral.", duration: 3.5, position: .bottom)
                    }
                })
            })
        }
    }

    func refer(_ name: String, andEmail email: String) {
        _ = UIAlertController(title: "Refer a Friend", message: "No user with that information exists. Would you like to refer them to join MyDailyBeat?", preferredStyle: .alert)
        _ = UIAlertAction(title: "NO", style: .cancel) { (action) in
            // do nothing
        }
        _ = UIAlertAction(title: "Yes", style: .default) { (action) in
            let queue = DispatchQueue.global()
            DispatchQueue.global().async(execute: {() -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.makeToastActivity(ToastPosition.center)
                })
                let result: Bool = RestAPI.getInstance().sendReferral(from: RestAPI.getInstance().getCurrentUser(), toPersonWithName: name, andEmail: email)
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.hideToastActivity()
                    if result {
                        self.view.makeToast("Referral sent successfully!", duration: 3.5, position: .bottom)
                    }
                    else {
                        self.view.makeToast("Could not send referral.", duration: 3.5, position: .bottom)
                    }
                })
            })
        }
    }

    func retrievePartners() {
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            if self.mode != .friends_MODE {
                self.partners = RestAPI.getInstance().getFlingProfiles()
                if self.partners.count >= 1 {
                    if (self.partners[0].id == RestAPI.getInstance().getCurrentUser().id) {
                        self.partners.remove(at: 0)
                    }
                }
            }
            else {
                var hobbMatches = RestAPI.getInstance().getHobbiesMatchesForUser()
                self.partners = hobbMatches
            }
            for partner in self.partners {
                let user = RestAPI.getInstance().getUserData(for: partner.id)
                self.partnerUsers.append(user)
            }
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.tableView.reloadData()
            })
        })
    }
// MARK: - Table view data source

override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return (self.partners.count == 0) ? 1 : self.partners.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CellIdentifier")
        }
        if self.partners.count == 0 {
            cell?.textLabel?.text = "No Results Found"
        }
        else {
            cell?.textLabel?.text = self.partnerUsers[indexPath.row].screenName
            cell?.imageView?.image = self.loadPicture(forUser: self.partnerUsers[indexPath.row].screenName)
        }
        return cell!
    }

    func loadPicture(forUser screenName: String) -> UIImage {
        var img: UIImage?
        
        DispatchQueue.global().async(execute: {() -> Void in
            let imageURL: URL? = RestAPI.getInstance().retrieveProfilePictureForUser(withScreenName: screenName)
            let imageData: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imageURL!)
            DispatchQueue.main.async(execute: {() -> Void in
                // Update the UI
                if imageData != nil {
                    img = UIImage(data: imageData!)
                }
            })
        })
        return img!
    }
// MARK: - Table view delegate
    // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Navigation logic may go here, for example:
            // Create the next view controller.
        self.performSegue(withIdentifier: "ShowProfileSegue", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? EVCFlingProfileViewController {
            let userRow = sender as! Int
            let user = RestAPI.getInstance().getUserData(for: userRow)
            dest.currentViewedUser  = user
            dest.mode = self.mode
        }
    }
}
