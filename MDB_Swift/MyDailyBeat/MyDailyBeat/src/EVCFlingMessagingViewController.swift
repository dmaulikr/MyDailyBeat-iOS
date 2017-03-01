
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
class EVCFlingMessagingViewController: SLKTextViewController {

    var messages = [String]()
    var messages2 = [VerveMessage]()
    var searchResult = [Any]()
    var chatroom: MessageChatroom!

    init(chatroom: MessageChatroom) {
        super.init(tableViewStyle: .plain)
        
        self.messages = [String]()
        self.messages2 = [VerveMessage]()
        self.searchResult = [Any]()
        self.chatroom = chatroom
        self.bounces = true
        self.shakeToClearEnabled = true
        self.isKeyboardPanningEnabled = true
        self.shouldScrollToBottomAfterKeyboardShows = false
        self.isInverted = true
        self.tableView?.separatorStyle = .none
        //self.tableView.registerClass(MessageTableViewCell.self, forCellReuseIdentifier: "MessengerCellIdentifier")
        self.textView.placeholder = NSLocalizedString("Message", comment: "")
        self.textView.placeholderColor = UIColor.lightGray
        self.textView.layer.borderColor = UIColor(red: CGFloat(217.0 / 255.0), green: CGFloat(217.0 / 255.0), blue: CGFloat(217.0 / 255.0), alpha: CGFloat(1.0)).cgColor
        self.textView.pastableMediaTypes = .all
        self.leftButton.setImage(UIImage(named: "icn_upload"), for: .normal)
        self.leftButton.tintColor = UIColor.gray
        self.rightButton.setTitle(NSLocalizedString("Send", comment: ""), for: .normal)
        self.textInputbar.editorTitle.textColor = UIColor.darkGray
        self.textInputbar.editorLeftButton.tintColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(122.0 / 255.0), blue: CGFloat(255.0 / 255.0), alpha: CGFloat(1.0))
        self.textInputbar.editorRightButton.tintColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(122.0 / 255.0), blue: CGFloat(255.0 / 255.0), alpha: CGFloat(1.0))
        self.textInputbar.autoHideRightButton = true
        self.textInputbar.maxCharCount = 140
        self.textInputbar.counterStyle = .split
        self.typingIndicatorView?.canResignByTouch = true
        //self.autoCompletionView.registerClass(MessageTableViewCell.self, forCellReuseIdentifier: AutoCompletionCellIdentifier)
        self.registerPrefixes(forAutoCompletion: ["@", "#", ":"])
    
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.getMessagesAsync()
    }

    func getMessagesAsync() {
        var queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            self.messages2 = RestAPI.getInstance().getMessagesForChatroom(withID: self.chatroom.chatroomID) /* copyIteself.searchResult.countms: true */
            self.messages = [String]()
            for m: VerveMessage in self.messages2 {
                self.messages.append(m.message)
            }
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.tableView?.reloadData()
            })
        })
    }

    func writeMessageAsync(_ message: String) {
        var queue = DispatchQueue(label: "dispatch_queue_t_dialog")
        queue.async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            var milliseconds = Int64(Date().timeIntervalSince1970 * 1000.0)
            _ = RestAPI.getInstance().writeMessage(message, as: RestAPI.getInstance().getCurrentUser(), inChatRoomWithID: self.chatroom.chatroomID, atTime: milliseconds)
            var m = VerveMessage()
            m.message = message
            m.screenName = RestAPI.getInstance().getCurrentUser().screenName
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.tableView?.beginUpdates()
                self.messages.insert(message, at: 0)
                self.messages2.insert(m, at: 0)
                self.tableView?.insertRows(at: [IndexPath(row: 0, section: 0)], with: .bottom)
                self.tableView?.endUpdates()
                self.tableView?.slk_scrollToTop(animated: true)
            })
        })
    }
// MARK: - Overriden Methods

    func didChange(_ status: SLKKeyboardStatus) {
        // Notifies the view controller that the keyboard changed status.
    }

    override func textWillUpdate() {
        // Notifies the view controller that the text will update.
        super.textWillUpdate()
    }

    override func textDidUpdate(_ animated: Bool) {
        // Notifies the view controller that the text did update.
        super.textDidUpdate(animated)
    }

    override func didPressLeftButton(_ sender: Any?) {
        // Notifies the view controller when the left button's action has been triggered, manually.
        super.didPressLeftButton(sender)
    }

    override func didPressRightButton(_ sender: Any?) {
        // Notifies the view controller when the right button's action has been triggered, manually or by using the keyboard return key.
        // This little trick validates any pending auto-correction or auto-spelling just after hitting the 'Send' button
        self.textView.refreshFirstResponder()
        let message: String = self.textView.text
        self.writeMessageAsync(message)
        super.didPressRightButton(sender)
    }

    override func keyForTextCaching() -> String {
        return Bundle.main.bundleIdentifier!
    }

    override func didPasteMediaContent(_ userInfo: [AnyHashable: Any]) {
        // Notifies the view controller when the user has pasted an image inside of the text view.
        print("\(#function) : \(userInfo)")
    }

    override func willRequestUndo() {
        // Notifies the view controller when a user did shake the device to undo the typed text
        super.willRequestUndo()
    }

    override func didCommitTextEditing(_ sender: Any) {
            // Notifies the view controller when tapped on the right "Accept" button for commiting the edited text
        var message: String = self.textView.text
        var m = VerveMessage()
        m.message = message
        m.screenName = RestAPI.getInstance().getCurrentUser().screenName
        self.messages.remove(at: 0)
        self.messages.insert(message, at: 0)
        self.messages2.remove(at: 0)
        self.messages2.insert(m, at: 0)
        self.tableView?.reloadData()
        super.didCommitTextEditing(sender)
    }

    override func didCancelTextEditing(_ sender: Any) {
        // Notifies the view controller when tapped on the left "Cancel" button
        super.didCancelTextEditing(sender)
    }

    override func canPressRightButton() -> Bool {
        return super.canPressRightButton()
    }

    func canShowAutoCompletion() -> Bool {
        return false
    }

    override func heightForAutoCompletionView() -> CGFloat {
        var cellHeight: CGFloat = self.autoCompletionView.delegate!.tableView!(self.autoCompletionView, heightForRowAt: IndexPath(row: 0, section: 0))
        return cellHeight * CGFloat(self.searchResult.count)
    }

override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell: MessageTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: MessengerCellIdentifier) as? MessageTableViewCell)
//        if cell == nil {
//            cell = MessageTableViewCell(style: .default, reuseIdentifier: MessengerCellIdentifier)
//        }
//        cell?.textLabel?.text = self.messages[indexPath.row]
//        cell?.indexPath = indexPath
//        cell?.usedForMessage = true
//        var m: VerveMessage? = self.messages2[indexPath.row]
//        var scale: CGFloat = UIScreen.main.scale
//        if UIScreen.main.responds(to: #selector(self.nativeScale)) {
//            scale = UIScreen.main.nativeScale
//        }
//        var imgSize = CGSize(width: CGFloat(kMessageTableViewCellAvatarHeight * scale), height: CGFloat(kMessageTableViewCellAvatarHeight * scale))
//        var queue = DispatchQueue(label: "dispatch_queue_t_dialog")
//        queue.async(execute: {() -> Void in
//            var imageURL: URL? = RestAPI.getInstance().retrieveProfilePictureForUser(with: m?.screenName)
//            var imageData: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: imageURL!)
//            DispatchQueue.main.async(execute: {() -> Void in
//                    // Update the UI
//                var img = UIImage(data: imageData!)
//                cell?.imageView?.image = EVCCommonMethods.image(with: img, scaledTo: imgSize)
//            })
//        })
//        // Cells must inherit the table view's transform
//        // This is very important, since the main table view may be inverted
        let cell = UITableViewCell()
        cell.transform = (self.tableView?.transform)!
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView.isEqual(self.tableView) {
//            var message: String = self.messages[indexPath.row] as! String
//            var paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.lineBreakMode = .byWordWrapping
//            paragraphStyle.alignment = .left
//            var attributes: [AnyHashable: Any] = [NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(16.0)), NSParagraphStyleAttributeName: paragraphStyle]
//            var width: CGFloat = tableView.frame.width - (kMessageTableViewCellAvatarHeight * 2.0 + 10)
//            var bounds: CGRect = message.boundingRect(with: CGSize(width: width, height: CGFloat(0.0)), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
//            if (message.characters.count ) == 0 {
//                return 0.0
//            }
//            var height: CGFloat = roundf(bounds.height + kMessageTableViewCellAvatarHeight)
//            if height < kMessageTableViewCellMinimumHeight {
//                height = kMessageTableViewCellMinimumHeight
//            }
//            return height
//        }
//        else {
//            return kMessageTableViewCellMinimumHeight
//        }
        return 44
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.isEqual(self.autoCompletionView) {
            let topView = UIView()
            topView.backgroundColor = self.autoCompletionView.separatorColor
            return topView
        }
        return nil
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.isEqual(self.autoCompletionView) {
            return 0.5
        }
        return 0.0
    }
// MARK: - UITableViewDelegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEqual(self.autoCompletionView) {
            var item: String = self.searchResult[indexPath.row] as! String
            if (self.foundPrefix == "@") || (self.foundPrefix == ":") {
                item += ":"
            }
            item += " "
            self.acceptAutoCompletion(with: item)
        }
    }
// MARK: - UIScrollViewDelegate Methods

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Since SLKTextViewController uses UIScrollViewDelegate to update a few things, it is important that if you ovveride this method, to call super.
        super.scrollViewDidScroll(scrollView)
    }
}
