
//
//  EVCFlingMessagingViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/22/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import API
import Toast_Swift
import SlackTextViewController
import JSQMessagesViewController
class EVCFlingMessagingViewController: JSQMessagesViewController {

    var messages = [VerveMessage]()
    var chatroom: MessageChatroom!
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.getMessagesAsync()
    }

    func getMessagesAsync() {
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            self.messages = RestAPI.getInstance().getMessagesForChatroom(withID: self.chatroom.chatroomID)
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.collectionView.reloadData()
            })
        })
    }
    

    func writeMessageAsync(_ message: String) {
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            _ = RestAPI.getInstance().writeMessage(message, inChatRoomWithID: self.chatroom.chatroomID)
            let m = VerveMessage()
            m.message = message
            m.screenName = self.senderId
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.messages.insert(m, at: 0)
                self.collectionView.reloadData()
            })
        })
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        self.writeMessageAsync(text)
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.screenName == RestAPI.getInstance().getCurrentUser().screenName { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }

}
