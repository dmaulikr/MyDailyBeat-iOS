
//
//  EVCPostView.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/19/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import UIKit
import ASMediaFocusManager
import API
enum EVCPostType : Int {
    case hasPicture = 1
    case doesNotHavePicture = 0
}

class EVCPostView: UIView, ASMediasFocusDelegate {
    @IBOutlet var profilePicView: UIImageView!
    @IBOutlet var postPicView: UIImageView!
    var postType = EVCPostType(rawValue: 0)
    @IBOutlet var screenNameLbl: UILabel!
    @IBOutlet var whenLbl: UILabel!
    @IBOutlet var postTextLbl: UITextView!
    @IBOutlet var deleteButton: UIButton!
    var postObj: Post!
    var parentViewController: UIViewController!
    var mediaFocusManager: ASMediaFocusManager!

    init(frame: CGRect, andPost pObj: Post, with type: EVCPostType, andParent parent: UIViewController) {
        print("Loading a post...")
        super.init(frame: frame)
        if type == .hasPicture {
            let nib: [UIView] = Bundle.main.loadNibNamed("EVCPostView_WithPicture", owner: self, options: nil) as! [UIView]
            self.addSubview(nib.last!)
        }
        else {
            let nib: [UIView] = Bundle.main.loadNibNamed("EVCPostView_WithoutPicture", owner: self, options: nil) as! [UIView]
            self.addSubview(nib.last!)
        }
        postObj = pObj
        postType = type
        self.parentViewController = parent
        self.loadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBAction func deletePost(_ sender: Any) {
        (self.parentViewController as? EVCGroupViewController)?.delete(postObj)
    }

    func loadData() {
        print("Awoke from nib")
        if self.postType == .hasPicture {
            self.loadPicture()
        }
        self.loadProfilePicture()
        self.postTextLbl.text = postObj.postText
        let date = Date(timeIntervalSince1970: TimeInterval(postObj.dateTimeMillis / 1000))
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy hh:mm:ss"
        self.whenLbl.text = formatter.string(from: date)
    }

    func loadPicture() {
        
        DispatchQueue.global().async(execute: {() -> Void in
            if self.postObj.imageUrl != "" {
                let imageURL = URL(string: self.postObj.imageUrl)
                let imageData: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imageURL!)
                DispatchQueue.main.async(execute: {() -> Void in
                    // Update the UI
                    self.postPicView.image = UIImage(data: imageData!)
                    self.mediaFocusManager = ASMediaFocusManager()
                    self.mediaFocusManager.delegate = self
                    self.mediaFocusManager.install(on: self.postPicView)
                    self.mediaFocusManager.defocusOnVerticalSwipe = true
                })
            }
        })
    }

    func loadProfilePicture() {
        
        DispatchQueue.global().async(execute: {() -> Void in
            let screenName = ""
            let imageURL: URL? = RestAPI.getInstance().retrieveProfilePicture()
            let imageData: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imageURL!)
            DispatchQueue.main.async(execute: {() -> Void in
                // Update the UI
                self.profilePicView.image = UIImage(data: imageData!)
                self.screenNameLbl.text = screenName
            })
        })
    }
// MARK: - ASMediaFocusDelegate
    // Returns the view controller in which the focus controller is going to be added.
    // This can be any view controller, full screen or not.

    func parentViewController(for mediaFocusManager: ASMediaFocusManager) -> UIViewController {
        return self.parentViewController
    }
    // Returns the URL where the media (image or video) is stored. The URL may be local (file://) or distant (http://).

    func mediaFocusManager(_ mediaFocusManager: ASMediaFocusManager, mediaURLFor view: UIView) -> URL {
        let imageURL = URL(string: self.postObj.imageUrl)
        return imageURL!
    }
    // Returns the title for this media view. Return nil if you don't want any title to appear.

    func mediaFocusManager(_ mediaFocusManager: ASMediaFocusManager, titleFor view: UIView) -> String {
        return ""
    }

    func mediaFocusManagerWillAppear(_ mediaFocusManager: ASMediaFocusManager) {
        self.parentViewController.navigationController?.navigationBar.isHidden = true
    }

    func mediaFocusManagerWillDisappear(_ mediaFocusManager: ASMediaFocusManager) {
        self.parentViewController.navigationController?.navigationBar.isHidden = false
    }
}
