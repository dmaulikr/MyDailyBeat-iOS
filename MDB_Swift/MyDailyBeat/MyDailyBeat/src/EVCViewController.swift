
//
//  EVCViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/17/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import UIKit
import Toast_Swift
import API
import DLAlertView
import RESideMenu
import GBVersionTracking
class EVCViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var options = [String]()
    var imageNames = [String]()

    @IBOutlet var mTableView: UITableView!
    var api: RestAPI!


    override func viewDidLoad() {
        super.viewDidLoad()
        options = ["Check My Finances", "Reach Out ...\nI'm Feeling Blue", "Find a Job", "Go Shopping", "Have a Fling", "Start a Relationship", "Make Friends", "Manage My Health", "Travel", "Refer a Friend", "Volunteering"]
        imageNames = ["finance", "phone", "briefcase", "cart", "fling", "hearts", "peeps", "health", "plane", "refer", "hands"]
        self.mTableView.dataSource = self
        self.mTableView.delegate = self
        self.mTableView.separatorStyle = .none
        api = RestAPI.getInstance()
        let name: String = api.getCurrentUser().name
        var fields = name.components(separatedBy: " ")
        self.navigationItem.title = "Welcome \(fields[0])!"
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .selected)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        let arr = DataManager.getBanks()
        let arr2 = DataManager.getHealthPortals()
        let arr3 = DataManager.getPrescriptionProviders()
        if arr.isEmpty || arr2.isEmpty || arr3.isEmpty {
            DispatchQueue.global().async(execute: {() -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.makeToast("Fine Tuning Your Experience...", duration: 3.5, position: .bottom)
                    self.view.makeToastActivity(ToastPosition.center)
                })
                    // initialize db
                if arr.isEmpty {
                    var temp = TOP_TEN_BANKS
                    for i in 0..<temp.count {
                        let tempString: String = temp[i]
                        if RestAPI.getInstance().doesAppExist(withTerm: tempString, andCountry: "US") {
                            let bank: VerveBankObject = RestAPI.getInstance().getBankInfoForBank(withName: tempString, inCountry: "US")
                            let info = BankInfo(uniqueId: bank.uniqueID, name: bank.appName, appURL: bank.appStoreListing, iconURL: bank.appIconURL)
                            DataManager.insertBank(info)
                        }
                    }
                }
                
                if arr2.isEmpty {
                    var temp = HEALTH_PORTALS
                    for i in 0..<temp.count {
                        let tempString: String = temp[i]
                        let logoURL = HEALTH_PORTAL_LOGO_URLS[i]
                        let info = HealthInfo(uniqueId: i, url: tempString, logoURL: logoURL)
                        DataManager.insertHealthPortal(info)
                    }
                }
                
                if arr3.isEmpty {
                    var temp = PRESCRIP_PROVIDERS
                    for i in 0..<temp.count {
                        let tempString: String = temp[i]
                        let logoURL = PRESCRIP_PROVIDER_LOGO_URLS[i]
                        let info = PrescripProviderInfo(uniqueId: i, url: tempString, logoURL: logoURL)
                        DataManager.insertPrescriptionProvider(info)
                    }
                }
                
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.hideToastActivity()
                    UserDefaults.standard.set(false, forKey: "LOAD_BANK_IMAGES")
                    self.view.makeToast("Fine Tuning Complete", duration: 3.5, position: .bottom)
                    if GBVersionTracking.isFirstLaunchEver() {
                        self.showModalSegue(withIdentifier: "FirstTimeSetupSegue", andSender: self)
                    }
                })
            })
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? EVCFlingViewController {
            let mode = sender as! Int
            dest.mode = REL_MODE(rawValue: mode)!
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
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
                        let alert = UIAlertController(title: "Refer a Friend", message: "Enter the name and email address of the person you wish to invite to join MyDailyBeat.", preferredStyle: .alert)
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
                                let name = fields[0].text
                                let email = fields[1].text
                                DispatchQueue.global().async(execute: {() -> Void in
                                    DispatchQueue.main.async(execute: {() -> Void in
                                        self.view.makeToastActivity(ToastPosition.center)
                                    })
                                    let result: Bool = RestAPI.getInstance().sendReferral(from: RestAPI.getInstance().getCurrentUser(), toPersonWithName: name!, andEmail: email!)
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
                        })
                        alert.addAction(action)
                        alert.addAction(ok)
                        self.present(alert, animated: true, completion: nil)
                    default:
                        break
                }

            default:
                break
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier: String = "Celler"
        let cell = UITableViewCell(style: .default, reuseIdentifier: CellIdentifier)
        switch indexPath.section {
            case 0:
                let textLabel = UILabel(frame: cell.contentView.bounds)
                textLabel.text = "What would you like to do?"
                textLabel.textAlignment = .center
                textLabel.font = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(18))
                textLabel.lineBreakMode = .byWordWrapping
                textLabel.numberOfLines = 0
                cell.addSubview(textLabel)
                cell.selectionStyle = .none
            case 1:
                cell.textLabel?.lineBreakMode = .byWordWrapping
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.text = options[indexPath.row]
                cell.textLabel?.textAlignment = .left
                cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: CGFloat(18))
                let icon = UIImage(named: imageNames[indexPath.row])
                cell.imageView?.image = EVCCommonMethods.image(with: icon!, scaledTo: CGSize(width: CGFloat(30), height: CGFloat(30)))
        default:
            break
        }

        //cell.contentView.backgroundColor = UIColor(netHex: 0xEEE2BE);
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
            case 0:
                return 35
            case 1:
                if options[indexPath.row] == "Reach Out ...\nI'm Feeling Blue" {
                    return 43
                } else {
                    return 42
                }
        default:
            break
        }

        return 35
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1
            case 1:
                return options.count
            default:
                return 1
        }

    }
}
