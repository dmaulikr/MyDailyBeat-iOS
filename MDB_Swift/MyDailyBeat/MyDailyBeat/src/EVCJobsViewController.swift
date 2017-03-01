
//
//  EVCJobsViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/22/15.
//  Copyright © 2015 eVerveCorp. All rights reserved.
//
import UIKit
import CoreLocation
import Toast_Swift
import RESideMenu
import FXBlurView
import API
import SwiftyJSON
class EVCJobsViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, EVCJobsFilterDelegate {
    var manager: CLLocationManager!
    var geocoder: CLGeocoder!
    var currentZip: String = ""
    var currentQuery: String = ""
    var currentPage: Int = 0
    var total: Int = 0
    var jobType: JobType = .all
    var searchRadius: JobSearchRadius = .twenty_FIVE_MILES
    var filterView: EVCJobsFilter!

    @IBOutlet var results: UITableView!
    var resultsDictionary = JSON("")
    var currentSet = [JSON]()


    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        currentQuery = ""
        currentPage = 0
        jobType = JobType(rawValue: UserDefaults.standard.integer(forKey: "JobTypeFilter"))!
        searchRadius = JobSearchRadius(rawValue: UserDefaults.standard.integer(forKey: "JobSearchRadiusFilter"))!
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        currentQuery = ""
        currentPage = 0
        jobType = JobType(rawValue: UserDefaults.standard.integer(forKey: "JobTypeFilter"))!
        searchRadius = JobSearchRadius(rawValue: UserDefaults.standard.integer(forKey: "JobSearchRadiusFilter"))!
    }

    func update(_ type: JobType, andRadius radius: JobSearchRadius) {
        jobType = type
        searchRadius = radius
        UserDefaults.standard.set(jobType, forKey: "JobTypeFilter")
        UserDefaults.standard.set(searchRadius, forKey: "JobSearchRadiusFilter")
        UserDefaults.standard.synchronize()
        currentPage = 0
        self.currentSet = [JSON]()
        let imgView: UIImageView? = (self.view.viewWithTag(BLUR_VIEW_TAG) as? UIImageView)
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            imgView?.alpha = 0
        }, completion: {(_ finished: Bool) -> Void in
            imgView?.removeFromSuperview()
            UIView.animate(withDuration: 0.2, animations: {() -> Void in
                self.filterView.alpha = 0
            }, completion: {(_ finished: Bool) -> Void in
                self.filterView.removeFromSuperview()
                self.run(self.currentQuery)
            })
        })
    }

    func hasMore() -> Bool {
        var pagecount = total / 25
        return (pagecount > currentPage)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.results.dataSource = self
        self.results.delegate = self
        self.currentSet = [JSON]()
        jobType = .all
        searchRadius = .twenty_FIVE_MILES
        currentZip = RestAPI.getInstance().getCurrentUser().zipcode
        self.run(currentQuery)
        // Do any additional setup after loading the view from its nib.
    }

    func run(_ query: String) {
        var baseUrl: String = "http://api.indeed.com"
        var path: String = "ads/apisearch"
        var parameters: String = "publisher=3873225971566005&q=" + query
        parameters = parameters + "&l="
        parameters = parameters + currentZip
        parameters = parameters + "&sort=&radius="
        switch searchRadius {
            case .twenty_FIVE_MILES:
                parameters = parameters + "25"
            case .fifty_MILES:
                parameters = parameters + "50"
            case .seventy_FIVE_MILES:
                parameters = parameters + "75"
            case .one_HUNDRED_MILES:
                parameters = parameters + "100"
            default:
                break
        }

        parameters = parameters + "&st=&jt="
        switch jobType {
            case .full_TIME:
                parameters = parameters + "fulltime"
            case .part_TIME:
                parameters = parameters + "parttime"
            default:
                break
        }

        var page: String = "&start=\(currentPage)"
        parameters = parameters + page
        parameters = parameters + "&limit=30000&fromage=&filter=1&latlong=1&co=&chnl=&userip=1.2.3.4&useragent=Mozilla/%2F4.0%28Firefox%29&v=2"
        var queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            self.resultsDictionary = RestAPI.getInstance().makeRequest(withBaseUrl: baseUrl, withPath: path, withParameters: parameters, withRequestType: GET_REQUEST, andPost: nil)
            var resultsDic = self.resultsDictionary["results"].dictionaryValue
            var temp: [JSON] = resultsDic["result"]!.arrayValue
            self.currentSet.append(contentsOf: temp)
            self.total = self.resultsDictionary["totalresults"].intValue
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.results.reloadData()
            })
        })
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifiter: String = "Cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: identifiter)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifiter)
        }
        if indexPath.row < self.currentSet.count {
            var result = self.currentSet[indexPath.row]
            cell?.textLabel?.text = result["jobtitle"].stringValue
            cell?.detailTextLabel?.text = result["company"].stringValue
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
            // TODO
        }
        else if indexPath.row == self.currentSet.count && self.hasMore() {
            currentPage += 1
            self.run(currentQuery)
        }
        else {

        }

    }

    func showFilter() {
        filterView = EVCJobsFilter(frame: CGRect(x: CGFloat(10), y: CGFloat((self.view.bounds.size.height - 245) / 2), width: CGFloat(300), height: CGFloat(245)))
        filterView.delegate = self
        var imgView: UIImageView? = (self.view.viewWithTag(BLUR_VIEW_TAG) as? UIImageView)
        if imgView == nil {
            imgView = UIImageView(frame: self.view.bounds)
            imgView?.tag = BLUR_VIEW_TAG
            var screenShot: UIImage? = EVCCommonMethods.image(with: UIColor(netHex: 0x0097a4), size: self.view.bounds.size)
            imgView?.image = screenShot?.blurredImage(withRadius: 40, iterations: 2, tintColor: UIColor.clear)
            imgView?.alpha = 0
            filterView.alpha = 0
            self.view.addSubview(imgView!)
            UIView.animate(withDuration: 0.2, animations: {() -> Void in
                imgView?.alpha = 1
            }, completion: { _ in })
        }
        self.view.addSubview(filterView)
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            self.filterView.alpha = 1
        }, completion: { _ in })
    }
}
