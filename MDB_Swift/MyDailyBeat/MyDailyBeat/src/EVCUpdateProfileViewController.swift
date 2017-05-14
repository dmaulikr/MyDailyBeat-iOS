
//
//  EVCUpdateProfileViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/21/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//
import UIKit
import Toast_Swift
import API
import DLAlertView
class EVCUpdateProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var mTableView: UITableView!
    var name: String = ""
    var email: String = ""
    var mobile: String = ""
    var zipcode: String = ""
    var picker: UIDatePicker!
    var dob = Date()
    var imgPicker: UIImagePickerController!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.mTableView.delegate = self
        self.mTableView.dataSource = self
        self.mTableView.isOpaque = false
        self.mTableView.backgroundColor = UIColor.clear
        self.mTableView.separatorStyle = .none
        self.mTableView.bounces = false
        self.view.backgroundColor = UIColor.clear
        self.mTableView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth]
        self.name = RestAPI.getInstance().getCurrentUser().name
        self.email = RestAPI.getInstance().getCurrentUser().email
        self.mobile = RestAPI.getInstance().getCurrentUser().mobile
        self.zipcode = RestAPI.getInstance().getCurrentUser().zipcode
        self.dob = RestAPI.getInstance().getCurrentUser().dob
        self.imgPicker = UIImagePickerController()
        self.imgPicker.delegate = self
        self.picker = UIDatePicker()
        self.picker.date = self.dob
        self.picker.minimumDate = Date(timeInterval: START_INTERVAL, since: Calendar.current.startOfDay(for: Date()))
        self.picker.maximumDate = Date(timeInterval: END_INTERVAL, since: Calendar.current.startOfDay(for: Date()))
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var img: UIImage? = (info[UIImagePickerControllerOriginalImage] as? UIImage)
        img = UIImage(cgImage: (img?.cgImage)!, scale: (img?.scale)!, orientation: .up)
        
        DispatchQueue.global().async(execute: {() -> Void in
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.makeToastActivity(ToastPosition.center)
            })
            let imgData: Data? = UIImageJPEGRepresentation(img!, 0.1)
            let url = info[UIImagePickerControllerReferenceURL] as? NSURL
            let fileName: String = url?.lastPathComponent ?? ASSET_FILENAME
            let success: Bool = RestAPI.getInstance().uploadProfilePicture(imgData!, withName: fileName)
            DispatchQueue.main.async(execute: {() -> Void in
                self.view.hideToastActivity()
                if success {
                    self.view.makeToast("Upload successful!", duration: 3.5, position: .bottom, title: nil, image: UIImage(named: "check.png"), style: nil, completion: nil)
                }
                else {
                    self.view.makeToast("Upload failed!", duration: 3.5, position: .bottom, title: nil, image: UIImage(named: "error.png"), style: nil, completion: nil)
                    return
                }
            })
        })
        self.dismiss(animated: true, completion: { _ in })
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            self.present(self.imgPicker, animated: true, completion: { _ in })
        }
        else if indexPath.section == 1 {
            switch indexPath.row {
                case 0:
                    let nameAlert = UIAlertController(title: "Enter New Name", message: "Enter your updated name.", preferredStyle: .alert)
                    nameAlert.addTextField(configurationHandler: { (textField) in
                        textField.autocapitalizationType = .words
                        textField.autocorrectionType = .no
                        textField.placeholder = "Name"
                        textField.text = RestAPI.getInstance().getCurrentUser().name
                    })
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (cancelAction) in
                        // do nothing here
                    })
                    nameAlert.addAction(cancel)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (okAction) in
                        self.name = (nameAlert.textFields?[0].text!)!
                    })
                    nameAlert.addAction(ok)
                    self.present(nameAlert, animated: true, completion: nil)
                case 1:
                    let emailAlert = UIAlertController(title: "Enter New Email", message: "Enter your new email address.", preferredStyle: .alert)
                    emailAlert.addTextField(configurationHandler: { (textField) in
                        textField.autocapitalizationType = .words
                        textField.autocorrectionType = .no
                        textField.placeholder = "Email"
                        textField.keyboardType = .emailAddress
                        textField.text = RestAPI.getInstance().getCurrentUser().email
                    })
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (cancelAction) in
                        // do nothing here
                    })
                    emailAlert.addAction(cancel)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (okAction) in
                        self.email = (emailAlert.textFields?[0].text!)!
                    })
                    emailAlert.addAction(ok)
                    self.present(emailAlert, animated: true, completion: nil)
                case 2:
                    //mobile
                    let mobileAlert = UIAlertController(title: "Enter New Mobile Phone #", message: "Enter your new mobile phone number.", preferredStyle: .alert)
                    mobileAlert.addTextField(configurationHandler: { (textField) in
                        textField.autocapitalizationType = .words
                        textField.autocorrectionType = .no
                        textField.placeholder = "Phone #"
                        textField.keyboardType = .namePhonePad
                        textField.text = RestAPI.getInstance().getCurrentUser().mobile
                    })
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (cancelAction) in
                        // do nothing here
                    })
                    mobileAlert.addAction(cancel)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (okAction) in
                        self.mobile = (mobileAlert.textFields?[0].text!)!
                    })
                    mobileAlert.addAction(ok)
                    self.present(mobileAlert, animated: true, completion: nil)
                case 3:
                    //dob
                    let dobAlert = DLAVAlertView(title: "Enter New Date of Birth", message: "Enter your date of birth.", delegate: nil, cancelButtonTitle: "Cancel")
                    dobAlert?.contentView = self.picker
                    dobAlert?.show(completion: { (alert, buttonIndex) in
                        switch buttonIndex {
                        case 1:
                            self.dob = self.picker.date
                        default:
                            break
                        }
                    })
                case 4:
                    //zipcode
                    let zipAlert = UIAlertController(title: "Enter New Zip Code", message: "Enter your zip code.", preferredStyle: .alert)
                    zipAlert.addTextField(configurationHandler: { (textField) in
                        textField.autocapitalizationType = .words
                        textField.autocorrectionType = .no
                        textField.placeholder = "Zip Code"
                        textField.keyboardType = .numberPad
                        textField.text = RestAPI.getInstance().getCurrentUser().zipcode
                    })
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (cancelAction) in
                        // do nothing here
                    })
                    zipAlert.addAction(cancel)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: { (okAction) in
                        self.zipcode = (zipAlert.textFields?[0].text!)!
                    })
                    zipAlert.addAction(ok)
                    self.present(zipAlert, animated: true, completion: nil)
                default:
                    break
            }
        }
        else {
                //save
            let current: VerveUser = RestAPI.getInstance().getCurrentUser()
            current.name = self.name
            current.email = self.email
            current.mobile = self.mobile
            current.dob = self.dob
            current.zipcode = self.zipcode
            DispatchQueue.global().async(execute: {() -> Void in
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.makeToastActivity(ToastPosition.center)
                })
                let result: Bool = RestAPI.getInstance().edit(current)
                DispatchQueue.main.async(execute: {() -> Void in
                    self.view.hideToastActivity()
                    if result {
                        self.view.makeToast("User edit successful!", duration: 3.5, position: .bottom, title: nil, image: UIImage(named: "check.png"), style: nil, completion: nil)
                    }
                    else {
                        self.view.makeToast("User edit failed!", duration: 3.5, position: .bottom, title: nil, image: UIImage(named: "error.png"), style: nil, completion: nil)
                        return
                    }
                    _ = self.navigationController?.popViewController(animated: true)
                })
            })
        }

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 5
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "CellIdentifier"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell?.backgroundColor = UIColor.clear
        cell?.textLabel?.font = UIFont(name: "HelveticaNeue", size: CGFloat(16))
        cell?.textLabel?.textColor = UIColor.black
        cell?.textLabel?.highlightedTextColor = UIColor.lightGray
        cell?.detailTextLabel?.font = UIFont(name: "HelveticaNeue", size: CGFloat(10))
        cell?.detailTextLabel?.textColor = UIColor.black
        cell?.detailTextLabel?.highlightedTextColor = UIColor.lightGray
        cell?.selectedBackgroundView = UIView()
        if indexPath.section == 0 {
            cell?.textLabel?.text = "Change Profile Picture"
        }
        else if indexPath.section == 1 {
            switch indexPath.row {
                case 0:
                    cell?.textLabel?.text = "Name"
                case 1:
                    cell?.textLabel?.text = "Email"
                case 2:
                    cell?.textLabel?.text = "Mobile"
                case 3:
                    cell?.textLabel?.text = "DOB"
                case 4:
                    cell?.textLabel?.text = "Zip Code"
                default:
                    cell?.detailTextLabel?.text = ""
            }
        }
        else {
            cell?.textLabel?.text = "Save"
        }

        return cell!
    }
    
}
