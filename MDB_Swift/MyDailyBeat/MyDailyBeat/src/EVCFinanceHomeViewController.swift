
//
//  EVCFinanceHomeViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/29/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//
import UIKit
import Toast_Swift
import API
import DLAlertView
class EVCFinanceHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var bankList = [BankInfo]()
    var iconList = [UIImage?]()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.bankList = [BankInfo]()
        self.iconList = [UIImage?]()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        let insets: UIEdgeInsets? = UIEdgeInsetsMake(0, 0, (self.tabBarController?.tabBar.frame.height)!, 0)
        self.tableView.contentInset = insets!
        self.tableView.scrollIndicatorInsets = insets!
        self.edgesForExtendedLayout = .all
        self.retrieveBanksData()
        // Do any additional setup after loading the view from its nib.
    }

    

    func retrieveBanksData() {
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            self.bankList = DataManager.getBanks()
            self.iconList = [UIImage?](repeating: nil, count: self.bankList.count)
            for i in 0..<self.bankList.count {
                let load: Bool = UserDefaults.standard.bool(forKey: "LOAD_BANK_IMAGES")
                if load {
                    let imgurl = URL(string: self.bankList[i].iconURL)
                    let data = RestAPI.getInstance().fetchImage(atRemoteURL: imgurl!)
                    if let img = UIImage(data: data) {
                        self.iconList[i] = img
                    }
                    
                }
                else {
                    UserDefaults.standard.set(true, forKey: "LOAD_BANK_IMAGES")
                }
            }
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.tableView.reloadData()
            })
        })
    }
// MARK: - Table view data source

func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return (self.bankList.count > 0) ? self.bankList.count + 1 : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CellIdentifier")
        }
        if self.bankList.count > 0 {
            if indexPath.row < self.bankList.count {
                cell?.textLabel?.text = self.bankList[indexPath.row].appName
                if let image = self.iconList[indexPath.row] {
                    cell?.imageView?.image = image
                } else {
                    cell?.imageView?.image = nil
                }
            } else {
                cell?.textLabel?.text = "Add Bank"
                cell?.imageView?.image = EVCCommonMethods.image(with: UIImage(named: "plus-512.png")!, scaledTo: CGSize(width: CGFloat(30), height: CGFloat(30)))
            }
        } else {
            cell?.textLabel?.text = "Add Bank"
            cell?.imageView?.image = EVCCommonMethods.image(with: UIImage(named: "plus-512.png")!, scaledTo: CGSize(width: CGFloat(30), height: CGFloat(30)))
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.bankList.count > 0 {
            if indexPath.row < self.bankList.count {
                self.popupActionMenu(indexPath.row)
            } else {
                // add new bank
                self.addBank()
            }
        } else {
            // add new bank
            self.addBank()
        }
    }

    func popupActionMenu(_ row: Int) {
        let sheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let browserAction = UIAlertAction(title: "Open App", style: .default) { (action) in
            let obj: BankInfo? = self.bankList[row]
            let appURL: String? = obj?.appURL
            UIApplication.shared.open(URL(string: appURL!)!, options: [:], completionHandler: nil)
        }
        let addAction = UIAlertAction(title: "Set as My Bank", style: .default) { (action) in
            let obj: BankInfo = self.bankList[row]
            let bankEncoded = NSKeyedArchiver.archivedData(withRootObject: obj)
            UserDefaults.standard.set(bankEncoded, forKey: "myBank")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(browserAction)
        sheet.addAction(addAction)
        sheet.addAction(cancelAction)
        self.present(sheet, animated: true, completion: nil)
    }

    func addBank() {
        let alert = UIAlertController(title: "Add new bank", message: "Enter the name of the bank you wish to add.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Bank name"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let text: String = alert.textFields![0].text!
            
            DispatchQueue.global().async(execute: {() -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.makeToastActivity(ToastPosition.center)
                })
                if RestAPI.getInstance().doesAppExist(withTerm: "\(text) bank", andCountry: "US") {
                    let bank: VerveBankObject? = RestAPI.getInstance().getBankInfoForBank(withName: "\(text) bank", inCountry: "US")
                    let info = BankInfo(uniqueId: 0, name: (bank?.appName)!, appURL: (bank?.appStoreListing)!, iconURL: (bank?.appIconURL)!)
                    DataManager.insertBank(info)
                }
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.hideToastActivity()
                    self.retrieveBanksData()
                })
            })
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    func isAppInstalled(_ name: String) -> Bool {
        let tempname = name.replacingOccurrences(of: " ", with: "-")
        return UIApplication.shared.canOpenURL(URL(string: tempname + "://")!)
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
}
