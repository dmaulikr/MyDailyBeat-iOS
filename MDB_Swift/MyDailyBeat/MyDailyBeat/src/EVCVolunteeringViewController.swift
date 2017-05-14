
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
class EVCVolunteeringViewController: UITableViewController, CLLocationManagerDelegate {
    var manager: CLLocationManager!
    var geocoder: CLGeocoder!
    var currentZip: String = ""
    var currentQuery: String = ""
    var currentPage: Int = 0
    var total: Int = 0


    var resultsDictionary = JSON([:])
    var currentSet = [JSON]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private var numCells: Int {
        get {
            return Int(tableView.frame.size.height / CGFloat(44))
        }
    }

    func hasMore() -> Bool {
        let pagecount: Int = Int(total / numCells)
        return (pagecount > currentPage)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentSet = [JSON]()
        currentZip = RestAPI.getInstance().getCurrentUser().zipcode
        currentPage = 1
        self.run(currentQuery)
        // Do any additional setup after loading the view from its nib.
    }

    func run(_ query: String) {
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            self.resultsDictionary = RestAPI.getInstance().getOpportunitiesInLocation(self.currentZip, onPage: self.currentPage)
            let temp = self.resultsDictionary["opportunities"].arrayValue
            self.currentSet.append(contentsOf: temp)
            self.total = self.resultsDictionary["resultsSize"].intValue
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            })
        })
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifiter: String = "Cell"
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.hasMore() {
            return self.currentSet.count + 3
        }
        else {
            return self.currentSet.count + 2
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row < self.currentSet.count {
            let opp = self.currentSet[indexPath.row]
            self.performSegue(withIdentifier: "DetailsSegue", sender: opp)
        }
        else if indexPath.row == self.currentSet.count && self.hasMore() {
            currentPage += 1
            self.run(currentQuery)
        }
        else {

        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let dest = segue.destination as? EVCVolunteeringDetailsViewController, let opp = sender as? JSON {
            dest.opportunity = opp
        }
    }
    
}
