
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
    var favs = [Any]()
    var mode: REL_MODE = .friends_MODE


    override func viewDidLoad() {
        super.viewDidLoad()
        self.favs = [Any]()
        self.mode = REL_MODE(rawValue: UserDefaults.standard.integer(forKey: "REL_MODE"))!
        self.retrievePartners()
    }

    func retrievePartners() {
        let queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            if self.mode == .friends_MODE {
                self.favs = [Any](arrayLiteral: RestAPI.getInstance().getFriendsFor(RestAPI.getInstance().getCurrentUser()))
            }
            else {
                self.favs = [Any](arrayLiteral: RestAPI.getInstance().getFlingFavorites(for: RestAPI.getInstance().getCurrentUser()))
            }
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.tableView.reloadData()
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell?.textLabel?.text = (self.favs[indexPath.row] as? FlingProfile)?.screenName
        cell?.imageView?.image = self.loadPicture(forUser: ((self.favs[indexPath.row] as? FlingProfile)?.screenName)!)
        return cell!
    }

    func loadPicture(forUser screenName: String) -> UIImage {
        var img: UIImage?
        let queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
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
        
//        var prof = EVCFlingProfileViewController(nibName: "EVCFlingProfileViewController", bundle: nil, andUser: RestAPI.getInstance().getUserDataForUser(withScreenName: (self.favs[indexPath.row] as? FlingProfile)?.screenName))
//        // Pass the selected object to the new view controller.
//        // Push the view controller.
//        self.navigationController?.pushViewController(prof, animated: true)
    }
}
