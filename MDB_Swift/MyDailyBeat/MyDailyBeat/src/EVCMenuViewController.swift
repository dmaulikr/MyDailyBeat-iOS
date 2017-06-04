
//
//  EVCMenuViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/23/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import UIKit
import Toast_Swift
import API
class EVCMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var options = [String]()
    var imageNames = [String]()

    var groups = [Group]()
    var parentController: UIViewController!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var logoView: UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth]
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isOpaque = false
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.contentInset = UIEdgeInsetsMake(-1.0, 0.0, 0.0, 0.0)
        self.tableView.separatorStyle = .none
        self.tableView.bounces = false
        self.view.backgroundColor = UIColor.clear
        options = ["Check My Finances", "Reach Out ...\nI'm Feeling Blue", "Find a Job", "Go Shopping", "Have a Fling", "Start a Relationship", "Make Friends", "Manage My Health", "Travel", "Refer a Friend", "Volunteering"]
        imageNames = ["finance2", "phone2", "briefcase2", "cart2", "fling2", "hearts2", "peeps2", "health2", "plane2", "refer2", "hands2"]
        self.logoView.image = EVCCommonMethods.image(with: UIImage(named: "Logo.png")!, scaledTo: CGSize(width: CGFloat(120), height: CGFloat(120)))
        self.logoView.backgroundColor = UIColor.white
        self.logoView.layer.cornerRadius = 54
        self.logoView.clipsToBounds = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.sideMenuViewController.contentViewController.view.makeToastActivity(.center)
            })
            self.groups = RestAPI.getInstance().getGroupsForCurrentUser()
            DispatchQueue.main.async(execute: {() -> Void in
                self.sideMenuViewController.contentViewController.view.hideToastActivity()
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
            })
        })
        if let outerNav = self.sideMenuViewController.contentViewController as? UINavigationController, let root = outerNav.viewControllers[0] as? RootNavController, let innerNav = root.embedded {
            self.parentController = innerNav.viewControllers[0]
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? EVCFlingViewController {
            let mode = sender as! Int
            dest.mode = REL_MODE(rawValue: mode)!
        } else if let dest = segue.destination as? EVCGroupViewController {
            dest.group = sender as! Group
            dest.parentController = self.parentController
        }
    }
// MARK: -
// MARK: UITableView Delegate

    func tableView(_ tableView2: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView2.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
            case 0:
                switch indexPath.row {
                    case 0:
                        _ = self.self.parentController.navigationController?.popToViewController(self.parentController, animated: true)
                    default:
                        break
                }

            case 2:
                if indexPath.row == groups.count {
                        //create group here
                    var create = EVCGroupCreationTableViewController()
                    self.sideMenuViewController.hideViewController()
                    self.sideMenuViewController.contentViewController.present(UINavigationController(rootViewController: create), animated: true, completion: { _ in })
                }
                else {
                        //add group selection here
                    var g: Group = groups[indexPath.row]
                    self.performSegue(withIdentifier: "GroupSegue", sender: g)
                }
            case 1:
                switch indexPath.row {
                case 4:
                    self.performSegue(withIdentifier: "RelationshipSegue", sender: 1)
                case 5:
                    self.performSegue(withIdentifier: "RelationshipSegue", sender: 2)
                case 6:
                    self.performSegue(withIdentifier: "RelationshipSegue", sender: 0)
                case 3:
                    self.performSegue(withIdentifier: "ShoppingSegue", sender: nil)
                case 1:
                    self.performSegue(withIdentifier: "FeelingBlueSegue", sender: nil)
                case 0:
                    self.performSegue(withIdentifier: "FinanceSegue", sender: nil)
                case 8:
                    self.performSegue(withIdentifier: "TravelSegue", sender: nil)
                case 2:
                    self.performSegue(withIdentifier: "JobsSegue", sender: nil)
                case 7:
                    self.performSegue(withIdentifier: "HealthSegue", sender: nil)
                case 10:
                    self.performSegue(withIdentifier: "VolunteeringSegue", sender: nil)

                    case 9:
                        var alert = UIAlertController(title: "Refer a Friend", message: "Enter the name and email address of the person you wish to invite to join MyDailyBeat.", preferredStyle: .alert)
                        alert.addTextField(configurationHandler: { (nameField) in
                            nameField.placeholder = "Name"
                            nameField.autocapitalizationType = .none
                            nameField.autocorrectionType = .no
                        })
                        alert.addTextField(configurationHandler: { (emailField) in
                            emailField.placeholder = "E-mail Address"
                            emailField.autocapitalizationType = .none
                            emailField.autocorrectionType = .no
                            emailField.keyboardType = .emailAddress
                        })
                        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                            // do nothing here
                        })
                        let ok = UIAlertAction(title: "Invite", style: .default, handler: { (inviteAction) in
                            if let fields = alert.textFields {
                                var name = fields[0].text
                                var email = fields[1].text
                                DispatchQueue.global().async(execute: {() -> Void in
                                    DispatchQueue.main.async(execute: {() -> Void in
                                        self.sideMenuViewController.contentViewController.view.makeToastActivity(ToastPosition.center)
                                    })
                                    var result: Bool = RestAPI.getInstance().sendReferral(from: RestAPI.getInstance().getCurrentUser(), toPersonWithName: name!, andEmail: email!)
                                    DispatchQueue.main.async(execute: {() -> Void in
                                        self.view.hideToastActivity()
                                        if result {
                                            self.sideMenuViewController.contentViewController.view.makeToast("Referral sent successfully!", duration: 3.5, position: .bottom)
                                        }
                                        else {
                                            self.sideMenuViewController.contentViewController.view.makeToast("Could not send referral.", duration: 3.5, position: .bottom)
                                        }
                                    })
                                })
                            }
                        })
                        alert.addAction(action)
                        alert.addAction(ok)
                        self.sideMenuViewController.contentViewController.present(alert, animated: true, completion: nil)
                    default:
                        break
                }

            default:
                break
        }

        self.sideMenuViewController.hideViewController()
    }

    func createGroup(withName name: String) {
    }
// MARK: -
// MARK: UITableView Datasource

func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && (options[indexPath.row] == "Reach Out ...\nI'm Feeling Blue") {
            return 51
        }
        return 42
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        switch sectionIndex {
            case 0:
                return 1
            case 2:
                return groups.count + 1
            case 1:
                return options.count
            default:
                return 1
        }

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier: String = "Cell"
        var cell = EVCMenuTableViewCell(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(320), height: CGFloat(42)), andTag: cellIdentifier)
        if indexPath.section == 1 && (options[indexPath.row] == "Reach Out ...\nI'm Feeling Blue") {
            cell = EVCMenuTableViewCell(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(320), height: CGFloat(70)), andTag: "feelingBlue")
        }
        cell.backgroundColor = UIColor.clear
        cell.lbl.textColor = UIColor.white
        cell.lbl.font = UIFont(name: "HelveticaNeue", size: CGFloat(16))
        cell.lbl.highlightedTextColor = UIColor.lightGray
        cell.selectedBackgroundView = UIView()
        cell.lbl.textAlignment = .right
        cell.lbl.lineBreakMode = .byWordWrapping
        cell.lbl.numberOfLines = 0
        switch indexPath.section {
            case 0:
                cell.lbl.text = "Home"
                var icon = UIImage(named: "home2.png")
                cell.imgView.image = EVCCommonMethods.image(with: icon!, scaledTo: CGSize(width: CGFloat(30), height: CGFloat(30)))
            case 2:
                if indexPath.row == groups.count {
                    cell.lbl.text = CREATE_NEW_GROUP
                    var icon = UIImage(named: "newgroup2.png")
                    cell.imgView.image = EVCCommonMethods.image(with: icon!, scaledTo: CGSize(width: CGFloat(30), height: CGFloat(30)))
                }
                else {
                    cell.lbl.text = (groups[indexPath.row] as AnyObject).groupName
                    
                    DispatchQueue.global().async(execute: {() -> Void in
                        var imageURL: URL? = RestAPI.getInstance().retrieveGroupPicture(for: self.groups[indexPath.row])
                        if imageURL == nil {
                            DispatchQueue.main.async(execute: {() -> Void in
                                var icon = UIImage(named: "group2.png")
                                cell.imgView.image = EVCCommonMethods.image(with: icon!, scaledTo: CGSize(width: CGFloat(30), height: CGFloat(30)))
                            })
                        }
                        else {
                            var imageData: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imageURL!)
                            DispatchQueue.main.async(execute: {() -> Void in
                                var icon = UIImage(data: imageData!)
                                cell.imgView.image = EVCCommonMethods.image(with: icon!, scaledTo: CGSize(width: CGFloat(30), height: CGFloat(30)))
                            })
                        }
                    })
                }
            case 1:
                cell.lbl.text = options[indexPath.row]
                var icon = UIImage(named: imageNames[indexPath.row] as! String)
                cell.imgView.image = EVCCommonMethods.image(with: icon!, scaledTo: CGSize(width: CGFloat(30), height: CGFloat(30)))
            default:
                break
        }

        return cell
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        self.performEmbeddedSegue(withIdentifier: identifier, andSender: sender)
    }
}
