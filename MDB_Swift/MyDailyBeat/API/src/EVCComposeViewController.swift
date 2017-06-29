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
public class EVCComposeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {
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
    open var completionHandler: ((_ message: String, _ image: UIImage?) -> Void)? = nil
    
    public override var nibName: String? {
        return "EVCComposeViewController_iPhone"
    }
    
    public override var nibBundle: Bundle? {
        return Bundle.init(for: EVCComposeViewController.self)
    }

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

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadProfilePicture()
        self.postTextView.inputAccessoryView = self.accessoryViewBar
        self.postTextView.becomeFirstResponder()
        self.postTextView.delegate = self
        self.postTextView.frame = CGRect(x: CGFloat(75), y: CGFloat(65), width: CGFloat(248), height: CGFloat(151))
        self.wasKeyboardManagerEnabled = IQKeyboardManager.sharedManager().enable
        IQKeyboardManager.sharedManager().enable = false
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = self.wasKeyboardManagerEnabled
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
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

    public func textViewDidChange(_ textView: UITextView) {
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
        
        DispatchQueue.global().async(execute: {() -> Void in
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

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: { _ in })
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        let smallest = min(chosenImage.size.width, chosenImage.size.height);
        let largest = max(chosenImage.size.width, chosenImage.size.height);
        
        let ratio = largest/smallest;
        
        let maximumRatioForNonePanorama = CGFloat(4) / CGFloat(3);
        guard ratio <= maximumRatioForNonePanorama else {
            // it is probably a panorama
            self.isHasAttachment = false
            picker.dismiss(animated: true, completion: nil)
            return
            
        }
        self.attachedImage = chosenImage
        self.attachmentImageView.image = self.attachedImage
        self.isHasAttachment = true
        picker.dismiss(animated: true, completion: nil)
    }
}
