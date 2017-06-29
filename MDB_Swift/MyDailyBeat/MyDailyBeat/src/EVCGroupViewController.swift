
//
//  EVCGroupViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/25/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import UIKit
import QuartzCore
import Toast_Swift
import API
class EVCGroupViewController: UIViewController {
    var max_post_height: Int = 0

    @IBOutlet var scroll: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    var composeButton: UIBarButtonItem!
    var settingsButton: UIBarButtonItem!
    var inviteButton: UIBarButtonItem!
    var group: Group!
    @IBOutlet var groupBar: UIToolbar!
    var parentController: UIViewController!

    convenience init(group g: Group, andParent parent: UIViewController) {
        self.init(nibName: "EVCGroupViewController_iPhone", bundle: nil)
        
        self.group = g
        self.parentController = parent
    
    }
    
    override var nibName: String? {
        return "EVCGroupViewController_iPhone"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scroll.backgroundColor = UIColor.groupTableViewBackground
        if self.scroll.bounds.size.height >= CGFloat(max_post_height) {
            self.scroll.contentSize = self.scroll.bounds.size
        }
        else {
            self.scroll.contentSize = CGSize(width: CGFloat(self.scroll.bounds.size.width), height: CGFloat(max_post_height + 10))
        }
        self.scroll.alwaysBounceVertical = true
        self.imageView?.layer.shadowColor = UIColor.purple.cgColor
        self.imageView?.layer.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(1))
        self.imageView?.layer.shadowOpacity = 1
        self.imageView?.layer.shadowRadius = 1.0
        self.imageView?.clipsToBounds = true
        self.composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.writePost))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.inviteButton = UIBarButtonItem(image: UIImage(named: "add_user-25.png"), style: .plain, target: self, action: #selector(self.invite))
        self.settingsButton = UIBarButtonItem(image: UIImage(named: "settings-25.png"), style: .plain, target: self, action: #selector(self.groupSettings))
        let items = [self.composeButton!, space, self.inviteButton!, self.settingsButton!]
        self.groupBar.setItems(items, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setNavTitle(to: self.group.groupName)
        
        if (RestAPI.getInstance().getCurrentUser().id == self.group.adminID) {
            self.settingsButton.isEnabled = true
            self.inviteButton.isEnabled = true
        } else {
            self.settingsButton.isEnabled = false
            self.inviteButton.isEnabled = false
        }
        self.refreshGroupData()
        self.loadPicture()
        self.loadPosts()
    }

    func writePost() {
        let completionHandler: (_ message: String, _ image: UIImage?) -> Void = { (message, image) in
            let attachedImage: UIImage? = image
            let postText: String = message
            let millis: Int64 = Int64(Date().timeIntervalSince1970)
            let written = Post()
            written.postText = postText
            written.dateTimeMillis = millis
            written.userid = RestAPI.getInstance().getCurrentUser().id
            
            DispatchQueue.global().async(execute: {() -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.makeToastActivity(ToastPosition.center)
                })
                let imgData: Data?
                if let attachment = attachedImage {
                    imgData = UIImagePNGRepresentation(attachment)
                } else {
                    imgData = nil
                }
                let fileName: String = ASSET_FILENAME
                let success: Bool = RestAPI.getInstance().write(written, withPictureData: imgData, andPictureName: fileName, to: self.group)
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.hideToastActivity()
                    if success {
                        self.view.makeToast("Upload successful!", duration: 3.5, position: .bottom)
                    }
                    else {
                        self.view.makeToast("Upload failed!", duration: 3.5, position: .bottom)
                        return
                    }
                    self.refreshGroupData()
                    self.loadPosts()
                })
            })
            self.dismiss(animated: true, completion: nil)
        }
        let composeNewPost = EVCComposeViewController()
        composeNewPost.completionHandler = completionHandler
        composeNewPost.title = "New Post"
        self.modalPresentationStyle = .fullScreen
        self.present(UINavigationController(rootViewController: composeNewPost), animated: true, completion: nil)
    }

    func groupSettings() {
        self.performSegue(withIdentifier: "EditGroupSegue", sender: nil)
    }

    func deletePost(_ p: Post) {
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            let success: Bool = RestAPI.getInstance().delete(post: p)
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                if success {
                    self.view.makeToast("Delete successful!", duration: 3.5, position: .bottom)
                }
                else {
                    self.view.makeToast("Delete failed!", duration: 3.5, position: .bottom)
                    return
                }
                self.refreshGroupData()
                self.loadPosts()
            })
        })
    }

    func refreshGroupData() {
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
                self.group.posts = RestAPI.getInstance().getPostsFor(self.group)
                self.view.hideToastActivity()
            })
        })
    }

    func invite() {
        let searchController = EVCUserSearchViewViewController()
        searchController.groupToInviteTo = self.group
        self.present(UINavigationController(rootViewController: searchController), animated: true, completion: { _ in })
    }

    func loadPicture() {
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            let imageURL: URL? = RestAPI.getInstance().retrieveGroupPicture(for: self.group)
            if imageURL == nil {
                return
            }
            let imageData: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imageURL!)
            DispatchQueue.main.async(execute: {() -> Void in
                // Update the UI
                self.view.hideToastActivity()
                self.imageView.image = UIImage(data: imageData!)
            })
        })
    }

    func loadPosts() {
        let viewsToRemove: [UIView] = self.scroll.subviews
        for v: UIView in viewsToRemove {
            v.removeFromSuperview()
        }
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            self.refreshGroupData()
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.group.posts.sort(by: {(_ obj1: Post, _ obj2: Post) -> Bool in
                    let id1: Int = obj1.post_id
                    let id2: Int = obj2.post_id
                    return id1 > id2
                })
                self.max_post_height = 10
                let count = Int(self.group.posts.count)
                var i = count - 1
                while i >= 0 {
                    self.scroll.addSubview(self.createView(for: self.group.posts[i])!)
                    i -= 1
                }
                self.scroll.contentSize = CGSize(width: CGFloat(self.scroll.bounds.size.width), height: CGFloat(self.max_post_height + 10))
            })
        })
    }

    func createView(for inputPost: Post) -> UIView? {
        let postView: UIView?
        if inputPost.imageUrl != "" {
            let post = EVCPostView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(300), height: CGFloat(400)), andPost: inputPost, with: EVCPostType.hasPicture, andParent: self)
            postView = UIView(frame: CGRect(x: CGFloat(10), y: CGFloat(max_post_height), width: CGFloat(300), height: CGFloat(400)))
            postView?.addSubview(post)
            max_post_height += 430
        }
        else {
            let post = EVCPostView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(300), height: CGFloat(178)), andPost: inputPost, with: EVCPostType.doesNotHavePicture, andParent: self)
            postView = UIView(frame: CGRect(x: CGFloat(10), y: CGFloat(max_post_height), width: CGFloat(300), height: CGFloat(178)))
            postView?.addSubview(post)
            max_post_height += 208
        }
        postView?.backgroundColor = UIColor.white
        // drop shadow
        postView?.layer.shadowColor = UIColor.black.cgColor
        postView?.layer.shadowOpacity = 0.8
        postView?.layer.shadowRadius = 3.0
        postView?.layer.shadowOffset = CGSize(width: CGFloat(2.0), height: CGFloat(2.0))
        return postView!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? EVCGroupSettingsViewController {
            dest.group = self.group
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

    
}
