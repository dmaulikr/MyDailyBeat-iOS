//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  EVCComposeViewController.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 10/25/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import UIKit
import IQKeyboardManagerSwift
typealias EVCComposeViewControllerCompletionHandler = (_ message: String, _ image: UIImage) -> Void
class EVCComposeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {
    var wasKeyboardManagerEnabled: Bool = false

    @IBOutlet var profilePicView: UIImageView!
    @IBOutlet var attachmentImageView: UIImageView!
    @IBOutlet var postTextView: UITextView!
    @IBOutlet var accessoryViewBar: UIToolbar!
    @IBOutlet var camera: UIBarButtonItem!
    @IBOutlet var gallery: UIBarButtonItem!
    var attachedImage: UIImage!
    var isHasAttachment: Bool = false
    var postText: String = ""
    var completionHandler: EVCComposeViewControllerCompletionHandler? = nil

    @IBAction func addPhoto(fromLibrary sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        if !self.isHasAttachment {
            self.present(picker, animated: true, completion: { _ in })
        }
        else {
            let myAlertView = UIAlertController(title: "", message: "This post already has an attachment!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                    // no need to do anything here
                })
            myAlertView.addAction(cancelAction)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    // no need to do anything here
                })
            myAlertView.addAction(okAction)
            self.present(myAlertView, animated: true, completion: { _ in })
        }
    }

    @IBAction func takePhoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .camera
        if !self.isHasAttachment {
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                let myAlertView = UIAlertController(title: "Error", message: "Device has no camera", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                        // no need to do anything here
                    })
                myAlertView.addAction(okAction)
                self.present(myAlertView, animated: true, completion: { _ in })
            }
            else {
                self.present(picker, animated: true, completion: { _ in })
            }
        }
        else {
            let myAlertView = UIAlertController(title: "", message: "This post already has an attachment!", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
                    // no need to do anything here
                })
            myAlertView.addAction(cancelAction)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    // no need to do anything here
                })
            myAlertView.addAction(okAction)
            self.present(myAlertView, animated: true, completion: { _ in })
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.wasKeyboardManagerEnabled = IQKeyboardManager.sharedManager().enable
        IQKeyboardManager.sharedManager().enable = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = self.wasKeyboardManagerEnabled
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadProfilePicture()
        self.postTextView.inputAccessoryView = self.accessoryViewBar
        self.postTextView.becomeFirstResponder()
        self.postTextView.delegate = self
        self.postTextView.frame = CGRect(x: CGFloat(75), y: CGFloat(65), width: CGFloat(248), height: CGFloat(151))
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelPost))
        self.navigationItem.leftBarButtonItem = cancelBarButton
        let postBarButton = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(self.writePost))
        self.navigationItem.rightBarButtonItem = postBarButton
    }

    func cancelPost() {
        self.dismiss(animated: true, completion: { _ in })
    }

    func writePost() {
        self.postText = self.postTextView.text
        if let handler = completionHandler {
            handler(self.postText, self.attachedImage)
        }
        
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count == 0 {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        else if textView.text.characters.count > 200 {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }

    }

    func loadProfilePicture() {
        let queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            let imageURL: URL? = RestAPI.getInstance().retrieveProfilePicture()
            if imageURL == nil {
                return
            }
            let imageData: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imageURL!)
            DispatchQueue.main.async(execute: {() -> Void in
                    // Update the UI
                let profilePic = UIImage(data: imageData!)
                self.profilePicView.image = profilePic
            })
        })
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: { _ in })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage: UIImage? = info[UIImagePickerControllerEditedImage] as! UIImage?
        self.attachedImage = chosenImage
        self.attachmentImageView.image = self.attachedImage
        self.isHasAttachment = true
        picker.dismiss(animated: true, completion: nil)
    }
}
