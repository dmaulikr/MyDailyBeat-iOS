
//
//  EVCChatroomCell.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/24/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import UIKit
import API
class EVCChatroomCell: UITableViewCell {
    @IBOutlet var first: UIImageView!
    @IBOutlet var second: UIImageView!
    @IBOutlet var third: UIImageView!
    @IBOutlet var chatroomNameLbl: UILabel!
    @IBOutlet var extraLbl: UILabel!
    var chatroom: MessageChatroom!

    func change(_ chatroom: MessageChatroom) -> EVCChatroomCell {
        self.chatroom = chatroom
        if chatroom.screenNames.count >= 3 {
            let firsts: String = chatroom.screenNames[0]
            let seconds: String = chatroom.screenNames[1]
            let thirds: String = chatroom.screenNames[2]
            self.chatroomNameLbl.text = "\(firsts), \(seconds), and \((chatroom.screenNames.count - 2)) others"
            let queue = DispatchQueue(label: "dispatch_queue_t_dialog")
            queue.async(execute: {() -> Void in
                let imageURL: URL? = RestAPI.getInstance().retrieveProfilePictureForUser(withScreenName: firsts)
                let imageData: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imageURL!)
                let imageURL2: URL? = RestAPI.getInstance().retrieveProfilePictureForUser(withScreenName: seconds)
                let imageData2: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imageURL2!)
                let imageURL3: URL? = RestAPI.getInstance().retrieveProfilePictureForUser(withScreenName: thirds)
                let imageData3: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imageURL3!)
                DispatchQueue.main.async(execute: {() -> Void in
                    // Update the UI
                    self.first.image = UIImage(data: imageData!)
                    self.second?.image = UIImage(data: imageData2!)
                    self.third.image = UIImage(data: imageData3!)
                })
            })
        }
        else if chatroom.screenNames.count == 2 {
            let firsts: String = chatroom.screenNames[0]
            let seconds: String = chatroom.screenNames[1]
            self.chatroomNameLbl.text = "\(firsts) and \(seconds)"
            let queue = DispatchQueue(label: "dispatch_queue_t_dialog")
            queue.async(execute: {() -> Void in
                let imageURL: URL? = RestAPI.getInstance().retrieveProfilePictureForUser(withScreenName: firsts)
                let imageData: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imageURL!)
                let imageURL2: URL? = RestAPI.getInstance().retrieveProfilePictureForUser(withScreenName: seconds)
                let imageData2: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imageURL2!)
                DispatchQueue.main.async(execute: {() -> Void in
                    // Update the UI
                    self.first.image = UIImage(data: imageData!)
                    self.second?.image = UIImage(data: imageData2!)
                })
            })
        }
        return self
    }
}
