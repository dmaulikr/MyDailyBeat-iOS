
//
//  EVCChatroomTableViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/24/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import UIKit
import API
import Toast_Swift
class EVCChatroomTableViewController: UITableViewController {
    var chatrooms = [MessageChatroom]()
    var addChatroom: UIBarButtonItem!
    var mode: REL_MODE = .friends_MODE


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "EVCChatroomCell", bundle: nil), forCellReuseIdentifier: CellIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadChatroomsAsync()
    }

    

    func loadChatroomsAsync() {
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            self.chatrooms = [MessageChatroom]()
            let temp = RestAPI.getInstance().getChatrooms() /* copyItems: true */
            if temp.count > 0 {
                self.chatrooms = temp
            }
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.tableView.reloadData()
            })
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? EVCFlingMessagingViewController {
            let chatroom = sender as! MessageChatroom
            dest.chatroom = chatroom
        }
    }
// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.chatrooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.chatrooms.count == 0 {
            var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: CellIdentifier2)
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: CellIdentifier2)
            }
            cell?.textLabel?.text = "No Chatrooms"
            cell?.accessoryType = .disclosureIndicator
            return cell!
        }
        else {
            var cell: EVCChatroomCell? = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! EVCChatroomCell?
            if cell == nil {
                cell = EVCChatroomCell(style: .default, reuseIdentifier: CellIdentifier)
            }
            cell = cell?.change(self.chatrooms[indexPath.row])
            return cell!
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.chatrooms.count == 0 {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
        else {
            if indexPath.row == self.chatrooms.count {
                return super.tableView(tableView, heightForRowAt: indexPath)
            }
            else {
                return 85
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if self.chatrooms.count == 0 {
            // do nothing
        }
        else {
            self.performSegue(withIdentifier: "ChatroomSegue", sender: self.chatrooms[indexPath.row])
        }
    }
}
var CellIdentifier: String = "CustomCellReuse"

var CellIdentifier2: String = "CustomCellReuse2"
