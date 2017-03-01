
//
//  EVCFlingProfileViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/21/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import UIKit
import Toast_Swift
import API
class EVCFlingProfileViewController: UIViewController {
    @IBOutlet var profilePicView: UIImageView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var ageLbl: UILabel!
    @IBOutlet var genderLbl: UILabel!
    @IBOutlet var distanceLbl: UILabel!
    @IBOutlet var orientationlbl: UILabel!
    @IBOutlet var addFavsBtn: UIButton!
    @IBOutlet var sendMessageBtn: UIButton!
    @IBOutlet var editBtn: UIButton!
    @IBOutlet var aboutMeView: UILabel!
    var currentViewedUser: VerveUser!
    var prefs: VerveUserPreferences!
    var matching: VerveMatchingPreferences!
    var mode: REL_MODE = .friends_MODE

    @IBAction func fav(_ sender: Any) {
        var queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            var favs: [FlingProfile]? = nil
            if self.mode == .friends_MODE {
                favs = RestAPI.getInstance().getFriendsFor(RestAPI.getInstance().getCurrentUser())
            }
            else {
                favs = RestAPI.getInstance().getFlingFavorites(for: RestAPI.getInstance().getCurrentUser())
            }
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                var loc = -1
                let user = RestAPI.getInstance().getFlingProfile(for: self.currentViewedUser)
                for i in 0..<(favs?.count)! {
                    if favs?[i] == user {
                        loc = i
                        break
                    }
                }
                if loc == -1 {
                    self.addFavsBtn.setTitle("Add Favorite", for: .normal)
                    // remove favorite
                } else {
                    self.addFavsBtn.setTitle("Remove Favorite", for: .normal)
                    if self.mode == .friends_MODE {
                        _ = RestAPI.getInstance().add(self.currentViewedUser, toFriendsOf: RestAPI.getInstance().getCurrentUser())
                    }
                    else {
                        _ = RestAPI.getInstance().add(self.currentViewedUser, toFlingFavoritesOf: RestAPI.getInstance().getCurrentUser())
                    }
                }
            })
        })
    }

    @IBAction func message(_ sender: Any) {
        var queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            var chatroom: MessageChatroom? = RestAPI.getInstance().createChatroomForUsers(withScreenName: RestAPI.getInstance().getCurrentUser().screenName, andScreenName: self.currentViewedUser.screenName)
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
//                var message = EVCFlingMessagingViewController(chatroom)
//                self.navigationController?.pushViewController(message, animated: true)
            })
        })
    }

    @IBAction func edit(_ sender: Any) {
        let edit = EVCFlingProfileCreatorViewController(nibName: "EVCFlingProfileCreatorViewController", bundle: nil)
        self.navigationController?.pushViewController(edit, animated: true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.aboutMeView.layer.borderWidth = 1.0
        self.aboutMeView.layer.borderColor = UIColor(netHex: 0x0097a4).cgColor
    }

    override func viewWillAppear(_ animated: Bool) {
        if self.currentViewedUser.isEqual(RestAPI.getInstance().getCurrentUser()) {
            self.addFavsBtn.isHidden = true
            self.sendMessageBtn.isHidden = true
            self.editBtn.isHidden = false
        }
        else {
            self.editBtn.isHidden = true
        }
        self.retrievePrefs()
        self.nameLbl.text = self.currentViewedUser.screenName
        self.distanceLbl.text = ""
        self.loadProfile()
        self.loadPicture()
    }

    func loadPicture() {
        var queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            var imageURL: URL? = RestAPI.getInstance().retrieveProfilePictureForUser(withScreenName: self.currentViewedUser.screenName)
            var imageData: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imageURL!)
            DispatchQueue.main.async(execute: {() -> Void in
                // Update the UI
                self.profilePicView.image = UIImage(data: imageData!)
            })
        })
    }

    func loadProfile() {
        let queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            let prof = RestAPI.getInstance().getFlingProfile(for: self.currentViewedUser)
            DispatchQueue.main.async(execute: {() -> Void in
                    // Update the UI
                let style: NSMutableParagraphStyle? = NSMutableParagraphStyle()
                style?.alignment = .justified
                style?.firstLineHeadIndent = 10.0
                style?.headIndent = 10.0
                style?.tailIndent = -10.0
                var attrText = NSAttributedString(string: prof.aboutMe, attributes: [NSParagraphStyleAttributeName: style!])
                self.aboutMeView.attributedText = attrText
                self.aboutMeView.numberOfLines = 0
            })
        })
    }

    func retrievePrefs() {
        var queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            self.prefs = RestAPI.getInstance().getUserPreferences(for: RestAPI.getInstance().getCurrentUser())
            self.matching = RestAPI.getInstance().getMatchingPreferences(for: RestAPI.getInstance().getCurrentUser())
            var favs = [Any](arrayLiteral: RestAPI.getInstance().getFlingFavorites(for: RestAPI.getInstance().getCurrentUser()))
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                if (favs as NSArray).index(of: RestAPI.getInstance().getFlingProfile(for: self.currentViewedUser)) != NSNotFound {
                    self.addFavsBtn.setTitle("Remove Favorite", for: .normal)
                }
                if self.prefs == nil {
                    self.prefs = VerveUserPreferences()
                }
                switch self.prefs.age {
                    case 0:
                        self.ageLbl.text = "50-54"
                    case 1:
                        self.ageLbl.text = "55-59"
                    case 2:
                        self.ageLbl.text = "60-64"
                    case 3:
                        self.ageLbl.text = "65-69"
                    case 4:
                        self.ageLbl.text = "70-74"
                    case 5:
                        self.ageLbl.text = "75-79"
                    case 6:
                        self.ageLbl.text = "80-84"
                    case 7:
                        self.ageLbl.text = "85-89"
                    case 8:
                        self.ageLbl.text = "90-94"
                    case 9:
                        self.ageLbl.text = "95-99"
                    case 10:
                        self.ageLbl.text = "100+"
                default:
                    self.ageLbl.text = ""
                }

                switch self.prefs.gender {
                    case 0:
                        self.genderLbl.text = "Male"
                    case 1:
                        self.genderLbl.text = "Female"
                    case 2:
                        self.genderLbl.text = "Transgender Male"
                    case 3:
                        self.genderLbl.text = "Transgender Female"
                default:
                    self.genderLbl.text = ""
                }

                var orientation: String = ""
                switch self.matching.gender {
                    case 0:
                        orientation = "Male"
                    case 1:
                        orientation = "Female"
                    case 2:
                        orientation = "Transgender Male"
                    case 3:
                        orientation = "Transgender Female"
                default:
                    orientation = ""
                }

                orientation = "Looking for a\n" + orientation
                self.orientationlbl.text = orientation
                switch self.prefs.ethnicity {
                    case 0:
                        self.distanceLbl.text = "White/Caucasian"
                    case 1:
                        self.distanceLbl.text = "Black/African-American"
                    case 2:
                        self.distanceLbl.text = "Asian"
                    case 3:
                        self.distanceLbl.text = "Native American Indian/Native Alaskan"
                    case 4:
                        self.distanceLbl.text = "Latino/Hispanic"
                    case 5:
                        self.distanceLbl.text = self.prefs.otherEthnicity
                default:
                    self.distanceLbl.text = ""
                }

            })
        })
    }
}
