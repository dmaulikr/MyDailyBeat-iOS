//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  EVCUserInviteViewController.swift
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 11/7/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import UIKit
import Toast_Swift
public class EVCUserInviteViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var messageTxtView: UITextView!
    @IBOutlet var methodChooser: UISegmentedControl!
    var sendingmethod: EVCUserInviteSendingMethod = .sendByEmail
    var sender: VerveUser!
    var recipient: VerveUser!
    var groupToInviteTo: Group!
    var inviteMessage: String = ""


    override public func viewDidLoad() {
        super.viewDidLoad()
        self.inviteMessage = "Hey, \(self.recipient.name), join my group on MyDailyBeat, \(self.groupToInviteTo.groupName)!"
        self.messageTxtView.text = self.inviteMessage
        self.messageTxtView.delegate = self
        self.nameLbl.text = "Recipient Screen Name: \(self.recipient.screenName)"
        let sendItem = UIBarButtonItem(title: "Send Invite", style: .done, target: self, action: #selector(self.sendInvite))
        self.navigationItem.rightBarButtonItem = sendItem
        self.navigationItem.title = "Write Invite"
    }

    @IBAction func changeSendingMethod(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                self.sendingmethod = .sendByEmail
            case 1:
                self.sendingmethod = .sendByMobile
            default: break
            
        }

    }

    public func textViewDidChange(_ textView: UITextView) {
        self.inviteMessage = textView.text
    }

    func sendInvite() {
        let queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
                
            })
            let success: Bool = RestAPI.getInstance().invite(self.recipient, toJoin: self.groupToInviteTo, by: self.sendingmethod, withMessage: self.inviteMessage)
            print("\(self.recipient)")
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                if success {
                    self.presentingViewController?.view.makeToast("Invite sent!", duration: 3.5, position: .bottom, title: nil, image: UIImage(named: "check.png"), style: nil, completion: nil)
                }
                else {
                    self.presentingViewController?.view.makeToast("Invite send failed!", duration: 3.5, position: .bottom, title: nil, image: UIImage(named: "error.png"), style: nil, completion: nil)
                    return
                }
                self.dismiss(animated: true, completion: nil)
            })
        })
    }
}
