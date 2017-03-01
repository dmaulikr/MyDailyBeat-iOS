
//
//  EVCJobsViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/22/15.
//  Copyright © 2015 eVerveCorp. All rights reserved.
//
import UIKit
import CoreLocation
import Toast_Swift
import API
import SwiftyJSON
class EVCVolunteeringViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    var manager: CLLocationManager!
    var geocoder: CLGeocoder!
    var currentZip: String = ""
    var currentQuery: String = ""
    var currentPage: Int = 0
    var total: Int = 0

    @IBOutlet var results: UITableView!
    var resultsDictionary = JSON([:])
    var currentSet = [JSON]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func hasMore() -> Bool {
        let pagecount: Int = Int(Double(total) / 10)
        return (pagecount > currentPage)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.results.dataSource = self
        self.results.delegate = self
        self.currentSet = [JSON]()
        currentZip = RestAPI.getInstance().getCurrentUser().zipcode
        currentPage = 1
        self.run(currentQuery)
        // Do any additional setup after loading the view from its nib.
    }

    func run(_ query: String) {
        var queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            self.resultsDictionary = RestAPI.getInstance().getOpportunitiesInLocation(self.currentZip, onPage: self.currentPage)
            let temp = self.resultsDictionary["opportunities"].arrayValue
            self.currentSet.append(contentsOf: temp)
            self.total = self.resultsDictionary["resultsSize"].intValue
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.results.reloadData()
            })
        })
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifiter: String = "Cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifiter)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifiter)
        }
        if indexPath.row < self.currentSet.count {
            var result = self.currentSet[indexPath.row]
            cell?.textLabel?.text = result["title"].stringValue
            cell?.detailTextLabel?.text = result["plaintextDescription"].stringValue
        }
        else if self.hasMore() {
            if indexPath.row == self.currentSet.count {
                cell?.textLabel?.text = "More Results..."
                cell?.detailTextLabel?.text = ""
            }
            else {
                cell?.textLabel?.text = ""
                cell?.detailTextLabel?.text = ""
            }
        }
        else {
            cell?.textLabel?.text = ""
            cell?.detailTextLabel?.text = ""
        }

        return cell!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.hasMore() {
            return self.currentSet.count + 3
        }
        else {
            return self.currentSet.count + 2
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row < self.currentSet.count {
            var result = self.currentSet[indexPath.row]
            // todo: insert segue
        }
        else if indexPath.row == self.currentSet.count && self.hasMore() {
            currentPage += 1
            self.run(currentQuery)
        }
        else {

        }

    }

    
}
