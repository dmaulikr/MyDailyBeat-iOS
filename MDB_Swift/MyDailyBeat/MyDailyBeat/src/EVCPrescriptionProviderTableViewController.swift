
//
//  EVCPrescriptionProviderTableViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 3/26/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//
import UIKit
import API
class EVCPrescriptionProviderTableViewController: UITableViewController {
    var pharmacyProviders = [PrescripProviderInfo]()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.pharmacyProviders = DataManager.getPrescriptionProviders()
    }

    
// MARK: - Table view data source

override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pharmacyProviders.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "CELL")
        if indexPath.row == self.pharmacyProviders.count {
            cell.textLabel?.text = "Add Provider"
            cell.imageView?.image = EVCCommonMethods.image(with: UIImage(named: "plus-512.png")!, scaledTo: CGSize(width: CGFloat(30), height: CGFloat(30)))
        }
        else {
            cell.textLabel?.text = (self.pharmacyProviders[indexPath.row] as? PrescripProviderInfo)?.url
        }
        // Configure the cell...
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == self.pharmacyProviders.count {
            let alert = UIAlertController(title: "Enter new prescription provider", message: "Enter the link to the prescription provider you wish to add.", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = ""
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                let text: String = alert.textFields![0].text!
                let prov = PrescripProviderInfo(uniqueId: 0, url: text, logoURL: "")
                DataManager.insertPrescriptionProvider(prov)
                self.pharmacyProviders = DataManager.getPrescriptionProviders()
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
        let fullURL: String
        if url.hasPrefix("http://") || url.hasPrefix("https://") {
            fullURL = "\(url)"
        } else {
            fullURL = "http://\(url)"
        }
        UIApplication.shared.open(URL(string: fullURL)!, options: [:], completionHandler: nil)
    }

    func popupActionMenu(_ row: Int) {
        let sheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let browserAction = UIAlertAction(title: "Open Site", style: .default) { (action) in
            let obj: PrescripProviderInfo = self.pharmacyProviders[row]
            self.openURLinBrowser(obj.url)
        }
        let addAction = UIAlertAction(title: "Set as My Prescription Provider", style: .default) { (action) in
            let obj: PrescripProviderInfo = self.pharmacyProviders[row]
            let encoded = NSKeyedArchiver.archivedData(withRootObject: obj)
            UserDefaults.standard.set(encoded, forKey: "myPrescripProvider")
        }
        sheet.addAction(browserAction)
        sheet.addAction(addAction)
        self.present(sheet, animated: true, completion: nil)

    }
}
import API
