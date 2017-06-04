
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
    @IBOutlet var aboutMeView: UILabel!
    var currentViewedUser: VerveUser!
    var prefs: VerveUserPreferences!
    var matching: VerveMatchingPreferences!
    var mode: REL_MODE = .friends_MODE
    var inRel = true

    @IBAction func fav(_ sender: Any) {
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            var favs: [FlingProfile] = []
            if self.mode == .friends_MODE {
                favs = RestAPI.getInstance().getFriends()
            }
            else if self.mode == .fling_MODE {
                favs = RestAPI.getInstance().getFlingFavorites()
            } else {
                favs = RestAPI.getInstance().getRelationshipFavorites()
            }
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                var loc = -1
                let user: FlingProfile
                if self.mode == .fling_MODE {
                    user = RestAPI.getInstance().getFlingProfile(for: self.currentViewedUser)
                } else if self.mode == .friends_MODE {
                    user = RestAPI.getInstance().getFriendsProfile(for: self.currentViewedUser)
                } else {
                    user = RestAPI.getInstance().getRelationshipProfile(for: self.currentViewedUser)
                }
                for i in 0..<favs.count {
                    if favs[i] == user {
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
                        _ = RestAPI.getInstance().addToFriends(self.currentViewedUser)
                    }
                    else if self.mode == .fling_MODE{
                        _ = RestAPI.getInstance().addToFlingFavorites(self.currentViewedUser)
                    } else {
                        _ = RestAPI.getInstance().addToRelationshipFavorites(self.currentViewedUser)
                    }
                }
            })
        })
    }

    @IBAction func message(_ sender: Any) {
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            var chatroom: MessageChatroom? = RestAPI.getInstance().createChatroomForUsers(withScreenName: self.currentViewedUser.screenName)
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.performSegue(withIdentifier: "SendMessageSegue", sender: chatroom)
            })
        })
    }

    func edit() {
        self.performSegue(withIdentifier: "EditProfileSegue", sender: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.aboutMeView.layer.borderWidth = 1.0
        self.aboutMeView.layer.borderColor = UIColor(netHex: 0x0097a4).cgColor
    }

    override func viewWillAppear(_ animated: Bool) {
        if self.currentViewedUser.id == RestAPI.getInstance().getCurrentUser().id {
            self.addFavsBtn.isHidden = true
            self.sendMessageBtn.isHidden = true
        }
        else {
            if !inRel {
                self.addFavsBtn.isHidden = true
                self.sendMessageBtn.isHidden = true
            }
        }
        self.retrievePrefs()
        self.nameLbl.text = self.currentViewedUser.screenName
        self.distanceLbl.text = ""
        self.loadProfile()
        self.loadPicture()
        
        if !inRel {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Call", style: .done, target: self, action: #selector(call))
        } else {
            if self.currentViewedUser.id == RestAPI.getInstance().getCurrentUser().id {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(edit))
            }
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func call() {
        let dialstring: String = currentViewedUser.mobile
        self.makeCall(dialstring)
    }
    
    func makeCall(_ num: String) {
        let dialstring: String = "tel:*67\(num)"
        let url = URL(string: dialstring)
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: {(_ success: Bool) -> Void in
                if success {
                    self.save(toCallHistoryNumber: num, withAccessCode: "")
                }
            })
        }
        else {
            let alView = UIAlertController(title: "Calling not supported", message: "This device does not support phone calls.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alView.addAction(action)
            self.present(alView, animated: true, completion: nil)
            
        }
    }
    
    func save(toCallHistoryNumber num: String, withAccessCode code: String) {
        if code == "" {
            if (num == "1-800-273-8255") {
                // suicide
                var callHistory = UserDefaults.standard.stringArray(forKey: "callHistory") ?? [String]()
                callHistory.insert("Suicide Hotline", at: 0)
                UserDefaults.standard.set(callHistory, forKey: "callHistory")
            }
            else {
                // save number
                var callHistory = UserDefaults.standard.stringArray(forKey: "callHistory") ?? [String]()
                callHistory.insert(num, at: 0)
                UserDefaults.standard.set(callHistory, forKey: "callHistory")
            }
        }
        else {
            // veterans
            var callHistory = UserDefaults.standard.stringArray(forKey: "callHistory") ?? [String]()
            callHistory.insert("Veterans' Hotline", at: 0)
            UserDefaults.standard.set(callHistory, forKey: "callHistory")
        }
        UserDefaults.standard.synchronize()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? EVCFlingMessagingViewController {
            let chatroom = sender as! MessageChatroom
            dest.chatroom = chatroom
        } else if let dest = segue.destination as? EVCFlingProfileCreatorViewController {
            dest.mode = self.mode
        }
    }

    func loadPicture() {
        
        DispatchQueue.global().async(execute: {() -> Void in
            var imageURL: URL? = RestAPI.getInstance().retrieveProfilePictureForUser(withScreenName: self.currentViewedUser.screenName)
            var imageData: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imageURL!)
            DispatchQueue.main.async(execute: {() -> Void in
                // Update the UI
                self.profilePicView.image = UIImage(data: imageData!)
            })
        })
    }

    func loadProfile() {
        
        DispatchQueue.global().async(execute: {() -> Void in
            let prof: FlingProfile
            if self.mode == .fling_MODE {
                prof = RestAPI.getInstance().getFlingProfile(for: self.currentViewedUser)
            } else if self.mode == .friends_MODE {
                prof = RestAPI.getInstance().getFriendsProfile(for: self.currentViewedUser)
            } else {
                prof = RestAPI.getInstance().getRelationshipProfile(for: self.currentViewedUser)
            }
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
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            self.prefs = RestAPI.getInstance().getUserPreferences()
            self.matching = RestAPI.getInstance().getMatchingPreferences()
            var favs: [FlingProfile] = []
            if self.mode == .friends_MODE {
                favs = RestAPI.getInstance().getFriends()
            }
            else if self.mode == .fling_MODE {
                favs = RestAPI.getInstance().getFlingFavorites()
            } else {
                favs = RestAPI.getInstance().getRelationshipFavorites()
            }
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                if favs.index(of: RestAPI.getInstance().getFlingProfile(for: self.currentViewedUser)) != NSNotFound {
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
                default:
                    self.distanceLbl.text = ""
                }

            })
        })
    }
}
