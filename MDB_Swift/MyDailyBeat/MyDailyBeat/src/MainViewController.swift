//
//  MainViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 3/20/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import UIKit

enum LoginSignupMode {
    case login
    case signup
    
    var cells: [CellType] {
        if self == .login {
            return [.loginCell, .goToSignUp, .SignUpCell, .goToLogin]
        } else {
            return [.SignUpCell, .goToLogin, .loginCell, .goToSignUp]
        }
    }
    
    
}

enum AnimationStep {
    case none
    case deletedOne
    case deletedTwo
    case addedOne
    
    var rowCount: Int {
        switch self {
        case .none:
            return 4
        case .deletedOne, .addedOne:
            return 3
        case .deletedTwo:
            return 2
        }
    }
    
}

enum CellType {
    case loginCell
    case SignUpCell
    case goToLogin
    case goToSignUp
}

class MainViewController: UIViewController {
    @IBOutlet var table: UITableView!
    @IBOutlet var loginView: UIView!
    @IBOutlet var signUpView: UIView!
    var mode: LoginSignupMode = .signup
    var step: AnimationStep = .none
    
    var mainViewHeight: CGFloat {
        return (self.view.frame.height - 150)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "SwitchViewCell", bundle: Bundle.main)
        self.table.register(nib, forCellReuseIdentifier: "transitionCell")
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "mainViewCell")
        self.loginView.frame = CGRect(x: 0, y: 0, width: self.table.frame.width, height: self.mainViewHeight)
        self.signUpView.frame = CGRect(x: 0, y: 0, width: self.table.frame.width, height: self.mainViewHeight)
        self.table.delegate = self
        self.table.dataSource = self
        self.table.isScrollEnabled = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.clear
    }

    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let dest = segue.destination as? EVCLoginViewController {
            dest.seguePerformer = { (identifier, sender) in
                self.performSegue(withIdentifier: identifier, sender: sender)
            }
        } else if let dest = segue.destination as? RegistrationViewController {
            dest.seguePerformer = { (identifier, sender) in
                self.performSegue(withIdentifier: identifier, sender: sender)
            }
        }
    }
    
    func switchViews() {
        //self.table.scrollToRow(at: IndexPath(row: 3, section: 0), at: .bottom, animated: true)
        self.table.beginUpdates()
        self.table.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        self.step = .deletedOne
        self.table.endUpdates()
        self.table.beginUpdates()
        self.table.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        self.step = .deletedTwo
        self.table.endUpdates()
        self.mode = (self.mode == .signup) ? .login : .signup
        self.table.beginUpdates()
        self.table.insertRows(at: [IndexPath(row: 2, section: 0)], with: .none)
        self.step = .addedOne
        self.table.endUpdates()
        self.table.beginUpdates()
        self.table.insertRows(at: [IndexPath(row: 3, section: 0)], with: .none)
        self.step = .none
        self.table.endUpdates()
        //self.table.moveSection(0, toSection: 1)
        
        /**
        self.table.beginUpdates()
        self.step = .deleted
        self.table.deleteSections(IndexSet(integer: 0), with: .top)
        self.table.endUpdates()
        
        self.table.beginUpdates()
        self.step = .none
        self.table.insertSections(IndexSet(integer: 1), with: .none)
        self.table.endUpdates()*/
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func configureCell(_ type: CellType, _ path: IndexPath) -> UITableViewCell {
        if type == .goToLogin || type == .goToSignUp {
            let cell = self.table.dequeueReusableCell(withIdentifier: "transitionCell", for: path) as! SwitchViewCell
            let action: (() -> ()) = {
                self.switchViews()
            }
            let mainText: String
            let buttonText: String
            if type == .goToLogin {
                mainText = "Already have an account?"
                buttonText = "Login"
            } else {
                mainText = "Don't have an account yet?"
                buttonText = "Sign Up"
            }
            cell.update(mainText, buttonText, action)
            return cell
        } else {
            let cell = self.table.dequeueReusableCell(withIdentifier: "mainViewCell", for: path)
            cell.contentView.subviews.forEach({ (view) in
                view.removeFromSuperview()
            })
            let subview: UIView
            if type == .loginCell {
                subview = self.loginView
            } else {
                subview = self.signUpView
            }
            subview.frame = cell.contentView.bounds
            cell.contentView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            cell.contentView.addSubview(subview)
            cell.selectionStyle = .none
            cell.accessoryType = .none
            return cell
        }
    }


}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.step.rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType: CellType
        if self.step == .deletedOne {
            cellType = self.mode.cells[indexPath.row + 1]
        } else if self.step == .deletedTwo {
            cellType = self.mode.cells[indexPath.row + 2]
        } else {
            cellType = self.mode.cells[indexPath.row]
        }
        return self.configureCell(cellType, indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType: CellType
        if self.step == .deletedOne {
            cellType = self.mode.cells[indexPath.row + 1]
        } else if self.step == .deletedTwo {
            cellType = self.mode.cells[indexPath.row + 2]
        } else {
            cellType = self.mode.cells[indexPath.row]
        }
        if cellType == .goToLogin || cellType == .goToSignUp {
            return 150
        } else {
            return mainViewHeight
        }
    }
}

class SwitchViewCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var button: UIButton!
    var action: (() -> ()) = {
        
    }
    
    func update(_ text: String, _ buttonText: String, _ buttonAction: @escaping (() -> ())) {
        self.label.text = text
        self.button.setTitle(buttonText, for: .normal)
        self.action = buttonAction
        self.button.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        self.button.layer.borderWidth = 1
        self.button.layer.borderColor = UIColor.white.cgColor
        self.button.layer.cornerRadius = 8
        self.button.clipsToBounds = true
    }
    
    func onClick() {
        action()
    }
}

