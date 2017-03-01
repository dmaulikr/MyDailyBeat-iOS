
//
//  EVCJobsDetailsViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/28/15.
//  Copyright © 2015 eVerveCorp. All rights reserved.
//
import UIKit
import API
import Toast_Swift
import SwiftyJSON
class EVCVolunteeringDetailsViewController: UIViewController {
    var opportunity: JSON
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var locLabel: UILabel!
    @IBOutlet var parentOrgLabel: UILabel!
    @IBOutlet var startLabel: UILabel!
    @IBOutlet var endLabel: UILabel!
    @IBOutlet var urlTextView: UITextView!
    @IBOutlet var descripTextView: UITextView!
    @IBOutlet var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        opportunity = JSON("")
        super.init(coder: aDecoder)
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLbl.text = self.opportunity["title"].stringValue
        self.locLabel.text = self.buildLocationString(self.opportunity["location"])
        var parentOrg = self.opportunity["parentOrg"]
        self.parentOrgLabel.text = parentOrg["name"].stringValue
        var availability = self.opportunity["availability"]
        let startDate: String? = availability["startDate"].string
        if startDate == nil {
            // flexible
            self.startLabel.text = "Flexible"
            self.endLabel.isHidden = true
        }
        else {
            let av = self.getAvailability(availability)
            self.startLabel.text = av[0]
            self.endLabel.text = av[1]
        }
        self.urlTextView.text = self.opportunity["vmUrl"].string
        self.descripTextView.text = self.opportunity["plaintextDescription"].string
        let imageURL: String? = self.opportunity["imageUrl"].string
        if imageURL != nil {
            self.fetchImage(imageURL!)
        }
        // Do any additional setup after loading the view from its nib.
    }

    func fetchImage(_ url: String) {
        let queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            let imgurl = URL(string: url)
            let data: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imgurl!)
            let img = UIImage(data: data!)
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.imageView.image = EVCCommonMethods.image(with: img!, scaledTo: CGSize(width: CGFloat(128), height: CGFloat(128)))
            })
        })
    }

    func getAvailability(_ availability: JSON) -> [String] {
        let startDate: String? = availability["startDate"].string
        let startTime: String? = availability["startTime"].string
        let endDate: String? = availability["endDate"].string
        let endTime: String? = availability["endTime"].string
        let start: String = "\(startDate) \(startTime)"
        let end: String = "\(endDate) \(endTime)"
        let arr: [String] = [start, end]
        return arr
    }

    func buildLocationString(_ locationDic: JSON) -> String {
        let city: String? = locationDic["city"].string
        let region: String? = locationDic["region"].string
        let zip: String? = locationDic["postalCode"].string
        let country: String? = locationDic["country"].string
        return "\(city), \(region) \(zip) \(country)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
