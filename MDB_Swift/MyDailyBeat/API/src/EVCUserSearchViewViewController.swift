//  Converted with Swiftify v1.0.6242 - https://objectivec2swift.com/
//
//  EVCSearchViewViewController.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 11/2/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import UIKit
import Toast_Swift
protocol EVCUserSearchViewDelegate: NSObjectProtocol {
    func dismissUserSearch(_ controller: EVCUserSearchViewViewController)
}
public class EVCUserSearchViewViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var mTableView: UITableView!
    @IBOutlet var mSearchBar: UISearchBar!
    public var cancel: UIBarButtonItem!
    public var isFiltered: Bool = false
    public var type: UserSearchType = .searchByScreenName
    public var currentSearch: EVCSearchEngine!
    public var data = [VerveUser]()
    public var groupToInviteTo: Group!
    weak var delegate: EVCUserSearchViewDelegate?


    public init() {
        super.init(nibName: "EVCUserSearchViewViewController_iPhone", bundle: Bundle(for: EVCUserSearchViewViewController.self))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        mSearchBar.delegate = self
        mTableView.delegate = self
        mTableView.dataSource = self
        cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelInvite))
        self.navigationItem.leftBarButtonItem = cancel
        self.navigationItem.leftItemsSupplementBackButton = true
        isFiltered = false
        mTableView.tableHeaderView = mSearchBar
        mSearchBar.showsScopeBar = true
        mSearchBar.setShowsCancelButton(false, animated: true)
        mSearchBar.sizeToFit()
        mSearchBar.autocorrectionType = .no
        mSearchBar.autocapitalizationType = .none
        self.navigationItem.title = "Search for Users"
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = self.data[indexPath.row]
        let inviteWriter = EVCUserInviteViewController()
        inviteWriter.groupToInviteTo = self.groupToInviteTo
        inviteWriter.recipient = user
        inviteWriter.sender = RestAPI.getInstance().getCurrentUser()
        self.navigationController?.pushViewController(inviteWriter, animated: true)
    }

    func cancelInvite() {
        self.dismiss(animated: true, completion: { _ in })
    }

    public func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
            case 0:
                type = .searchByScreenName
            case 1:
                type = .searchByName
            case 2:
                type = .searchByEmail
        default: break
        }

        let text: String = searchBar.text!
        self.updateSearch(text)
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.characters.count ) == 0 && isFiltered {
            isFiltered = false
            mTableView.reloadData()
        }
    }

    func updateSearch(_ text: String) {
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            switch self.type {
                case .searchByScreenName:
                    self.data = self.currentSearch.getUsers(withScreenName: text, withSortOrder: .ascending)
                case .searchByName:
                    self.data = self.currentSearch.getUsers(withName: text, withSortOrder: .ascending)
                case .searchByEmail:
                    self.data = self.currentSearch.getUsers(withEmail: text, withSortOrder: .ascending)
            }

            self.removeUsersAlreadyInGroupFromSearchResults()
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                self.mTableView.reloadData()
            })
        })
    }

    func removeUsersAlreadyInGroupFromSearchResults() {
        let temp: [VerveUser] = self.data
        self.data = [VerveUser]()
        for obj in temp {
            let user = obj
            let groupsForUser: [Group] = RestAPI.getInstance().getGroupsFor(user)
            var member: Bool = false
            let t = groupsForUser.map({ (group) -> Int in
                return group.groupID
            }).filter({ (id) -> Bool in
                return id == self.groupToInviteTo.groupID
            })
            if t.isEmpty {
                self.data.append(user)
            }
        }
    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        var text: String = searchBar.text!
        if (text.characters.count ) == 0 {
            isFiltered = false
        }
        else {
            isFiltered = true
            self.data = [VerveUser]()
            currentSearch = EVCSearchEngine()
            self.updateSearch(text)
        }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount: Int
        if isFiltered {
            rowCount = Int(self.data.count)
        }
        else {
            rowCount = 1
        }
        return rowCount
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier: String = "Cell"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: CellIdentifier)
        }
        if self.data.count == 0 {
            cell?.textLabel?.text = "No Results Found"
            cell?.imageView?.image = nil
            cell?.accessoryType = .none
            return cell!
        }
        if isFiltered {
            let user: VerveUser = self.data[indexPath.row]
            cell?.textLabel?.text = user.screenName
            
            DispatchQueue.global().async(execute: {() -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.makeToastActivity(ToastPosition.center)
                })
                let url: URL? = RestAPI.getInstance().retrieveProfilePictureForUser(withScreenName: (user.screenName))
                if url != nil {
                    let imageData: Data? = RestAPI.getInstance().fetchImage(atRemoteURL: url!)
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.hideToastActivity()
                        cell?.imageView?.image = UIImage(data: imageData!)
                    })
                }
                else {
                    DispatchQueue.main.async(execute: {() -> Void in
                        self.view.hideToastActivity()
                        cell?.imageView?.image = UIImage(named: "default-avatar.png")
                    })
                }
            })
            cell?.accessoryType = .disclosureIndicator
        }
        else {
            cell?.textLabel?.text = "No Results Found"
            cell?.imageView?.image = nil
            cell?.accessoryType = .none
        }
        return cell!
    }
}
