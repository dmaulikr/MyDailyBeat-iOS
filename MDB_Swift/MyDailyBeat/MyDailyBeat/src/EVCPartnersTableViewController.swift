
//
//  EVCPartnersTableViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/21/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import UIKit
import Toast_Swift
import API
class EVCPartnersTableViewController: UITableViewController {
    var favs = [FlingProfile]()
    var favUsers = [VerveUser]()
    var mode: REL_MODE = .friends_MODE


    override func viewDidLoad() {
        super.viewDidLoad()
        self.favs = [FlingProfile]()
        self.retrievePartners()
    }

    func retrievePartners() {
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            if self.mode == .friends_MODE {
                self.favs = RestAPI.getInstance().getFriends()
            }
            else {
                self.favs = RestAPI.getInstance().getFlingFavorites()
            }
            
            for fav in self.favs {
                let user = RestAPI.getInstance().getUserData(for: fav.id)
                self.favUsers.append(user)
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
        return self.favs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CellIdentifier")
        }
        cell?.textLabel?.text = self.favUsers[indexPath.row].screenName
        cell?.imageView?.image = self.loadPicture(forUser: self.favUsers[indexPath.row].screenName)
        return cell!
    }

    func loadPicture(forUser screenName: String) -> UIImage {
        var img: UIImage?
        
        DispatchQueue.global().async(execute: {() -> Void in
            let imageURL: URL? = RestAPI.getInstance().retrieveProfilePictureForUser(withScreenName: screenName)
            let imageData: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imageURL!)
            DispatchQueue.main.async(execute: {() -> Void in
                // Update the UI
                img = UIImage(data: imageData!)
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
