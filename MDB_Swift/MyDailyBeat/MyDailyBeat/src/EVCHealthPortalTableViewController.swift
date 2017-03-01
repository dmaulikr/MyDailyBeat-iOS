
//
//  EVCHealthPortalTableViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 3/26/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import UIKit
import API
class EVCHealthPortalTableViewController: UITableViewController {
    var healthPortals = [HealthInfo]()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.healthPortals = HealthDatabase.database.healthPortals()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
// MARK: - Table view data source

override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.healthPortals.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CELL")
        if indexPath.row == self.healthPortals.count {
            cell.textLabel?.text = "Add Portal"
            cell.imageView?.image = EVCCommonMethods.image(with: UIImage(named: "plus-512.png")!, scaledTo: CGSize(width: CGFloat(30), height: CGFloat(30)))
        }
        else {
            cell.textLabel?.text = self.healthPortals[indexPath.row].url
            cell.imageView?.image = nil
        }
        // Configure the cell...
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == self.healthPortals.count {
            let alert = UIAlertController(title: "Enter new health portal.", message: "Enter the link to the health portal you wish to add.", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.text = ""
                textField.placeholder = ""
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                let text: String = alert.textFields![0].text!
                let portal = HealthInfo(uniqueId: 0, url: text, logoURL: "")
                HealthDatabase.database.insert(intoDatabase: portal, orPrescriptionProvider: nil)
                self.healthPortals = HealthDatabase.database.healthPortals()
                self.tableView.reloadData()
            })
            alert.addAction(cancel)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.popupActionMenu(indexPath.row)
        }
    }

    func openURLinBrowser(_ url: String) {
        let fullURL: String = "\(url)"
        UIApplication.shared.openURL(URL(string: fullURL)!)
    }

    func popupActionMenu(_ row: Int) {
        let sheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let browserAction = UIAlertAction(title: "Open App", style: .default) { (action) in
            let obj: HealthInfo? = self.healthPortals[row]
            self.openURLinBrowser((obj?.url)!)
        }
        let addAction = UIAlertAction(title: "Set as My Health Portal", style: .default) { (action) in
            let obj: HealthInfo = self.healthPortals[row]
            let encoded = NSKeyedArchiver.archivedData(withRootObject: obj)
            UserDefaults.standard.set(encoded, forKey: "myHealthPortal")
        }
        sheet.addAction(browserAction)
        sheet.addAction(addAction)
        self.present(sheet, animated: true, completion: nil)
    }
}
