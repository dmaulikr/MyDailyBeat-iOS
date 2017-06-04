//
//  AboutViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 3/23/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import UIKit
import RFAboutView_Swift
class AboutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var appNameLabel: UILabel!
    @IBOutlet var appCopyrightLabel: UILabel!
    @IBOutlet var websiteButton: UIButton!
    @IBOutlet var contactUsButton: UIButton!
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    private var acknowledgements = [[String:String]]()
    private var appName: String? = nil
    private var appVersion: String? = nil
    private var appBuild: String? = nil
    open var pubYear = 2016
    open var copyrightHolder: String = "eVerve Corporation"
    private let agreements: [String] = ["Terms of Service", "Privacy Policy", "Legal"]
    @IBAction func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showWebsite() {
        
    }
    
    @IBAction func showMailEditor() {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "MyDailyBeat"
        appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        appBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1.0"
        if let ackFile = Bundle.main.path(forResource: "Acknowledgements", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: ackFile) {
                acknowledgements = reformatAcknowledgementsDictionary(dict)
            }
        }
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CELL")
        self.appNameLabel.text = self.appName
        self.appCopyrightLabel.text = String(format: "Version %@ (%@)\n\u{A9} Copyright %d, %@", appVersion!, appBuild!, pubYear, copyrightHolder)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    /*!
     *  Gets the raw platform id (e.g. iPhone7,1)
     *  Mad props to http://stackoverflow.com/questions/25467082/using-sysctlbyname-from-swift
     */
    
    private func platformModelString() -> String? {
        if let key = "hw.machine".cString(using: String.Encoding.utf8) {
            var size: Int = 0
            sysctlbyname(key, nil, &size, nil, 0)
            var machine = [CChar](repeating: 0, count: Int(size))
            sysctlbyname(key, &machine, &size, nil, 0)
            return String(cString: machine)
        }
        return nil
    }
    
    private func reformatAcknowledgementsDictionary(_ originalDict: NSDictionary) -> [[String: String]] {
        var outputArray = [[String:String]]()
        
        if let tmp = originalDict.object(forKey: "PreferenceSpecifiers") as? NSMutableArray {
            
            if let mutableTmp = tmp.mutableCopy() as? NSMutableArray {
                mutableTmp.removeObject(at: 0)
                mutableTmp.removeLastObject()
                
                for innerDict in mutableTmp {
                    if let dictionary = innerDict as? NSDictionary, let tempTitle = dictionary.object(forKey: "Title") as? String, let tempContent = dictionary.object(forKey: "FooterText") as? String {
                        outputArray.append([tempTitle:tempContent])
                    }
                }
            }
        }
        return outputArray
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.agreements.count
        } else {
            return self.acknowledgements.count
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        let cellText: String
        if indexPath.section == 0 {
            cellText = self.agreements[indexPath.row]
        } else {
            cellText = self.acknowledgements[indexPath.row].keys.first!
        }
        cell.textLabel?.text = cellText
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        
        return String(format: "%@ makes use of the following third party libraries. Many thanks to the developers making them available!", self.appName!)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNonzeroMagnitude
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "AboutDetailsSegue", sender: indexPath)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let dest = segue.destination as? AboutDetailsViewController, let path = sender as? IndexPath {
            if path.section == 0 {
                
            } else {
                dest.text = self.acknowledgements[path.row].values.first ?? ""
            }
        }
    }
    

}
