//
//  RegistrationViewController.swift
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 3/20/17.
//  Copyright © 2017 eVerveCorp. All rights reserved.
//

import UIKit
import API
import Toast_Swift

private var s_object = RegistrationObject()

class RegistrationObject: NSObject {
    var screenName: String = ""
    var password: String = ""
    var verifiedPass: String = ""
    var fname = ""
    var lname = ""
    var birthday: Date = Date()
    var email: String = ""
    var mobile: String = ""
    var zipcode: String = ""
    
    fileprivate override init() {
        
    }
    
    fileprivate init(other: RegistrationObject) {
        screenName = other.screenName
        password = other.password
        verifiedPass = other.verifiedPass
        fname = other.fname
        lname = other.lname
        birthday = other.birthday
        email = other.email
        mobile = other.mobile
        zipcode = other.zipcode
    }
    
    class func getInstance() -> RegistrationObject {
        return RegistrationObject(other: s_object)
    }
    
    class func updateInstance(modified: RegistrationObject) {
        s_object = RegistrationObject(other: modified)
    }
}

class RegistrationViewController: UIPageViewController {
    var goToNext: (() -> ()) = {
        
    }
    var seguePerformer: ((String, Any?) -> ())? = nil
    var presentationIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        let first = self.messageViewController(0)
        self.setViewControllers([first], direction: .forward, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func messageViewController(_ index: Int) -> EVCRegistrationMessageViewController {
        let message: String
        let image: UIImage
        if index == 0 {
            message = "You are about to join a vibrant community for older adults..."
            image = #imageLiteral(resourceName: "community-ico-screen-1")
        } else if index == 1 {
            message = "Let this be the place you come to everyday to help manage your life..."
            image = #imageLiteral(resourceName: "calendar-ico-screen-2")
        } else {
            message = "Keep yourself engaged, socialize, and stay connected!"
            image = #imageLiteral(resourceName: "messages-ico-screen-3")
        }
        let vc = EVCRegistrationMessageViewController()
        vc.message = message
        vc.index = index
        vc.image = image
        vc.nextPage = {
            self.presentationIndex = index + 1
            if index < 2 {
                let next = self.messageViewController(index + 1)
                self.setViewControllers([next], direction: .forward, animated: true, completion: nil)
            } else {
                let next = RegistrationScreenNameViewController()
                next.nextPage = {
                    let personalInfo = RegistrationPersonalInfoViewController()
                    personalInfo.nextPage = {
                        let contactInfo = RegistrationContactInfoViewController()
                        contactInfo.nextPage = {
                            self.register()
                        }
                        self.setViewControllers([contactInfo], direction: .forward, animated: true, completion: nil)
                    }
                    self.setViewControllers([personalInfo], direction: .forward, animated: true, completion: nil)
                }
                self.setViewControllers([next], direction: .forward, animated: true, completion: nil)
            }
        }
        return vc
    }
    
    func register() {
        DispatchQueue.global().async {
            DispatchQueue.main.sync {
                self.view.makeToastActivity(.center)
            }
            let user = RegistrationObject.getInstance()
            let success = RestAPI.getInstance().createUser(withFirstName: user.fname, andLastName: user.lname, andEmail: user.email, andMobile: user.mobile, andZip: user.zipcode, bornOn: user.birthday, with: user.screenName, and: user.password)
            DispatchQueue.main.sync {
                self.view.hideToastActivity()
            }
            if success {
                DispatchQueue.main.sync {
                    do {
                        let toast = try self.view.toastViewForMessage("User created successfully. Logging in...", title: nil, image: nil, style: ToastManager.shared.style)
                        self.view.showToast(toast, duration: 2, position: .bottom, completion: { (finished) in
                            self.view.makeToastActivity(.center)
                        })
                    } catch {
                        self.view.makeToastActivity(.center)
                    }
                }
                _ = RestAPI.getInstance().login(withScreenName: user.screenName, andPassword: user.password)
                UserDefaults.standard.set(user.screenName, forKey: KEY_SCREENNAME)
                UserDefaults.standard.set(user.password, forKey: KEY_PASSWORD)
                DispatchQueue.main.sync {
                    if let performer = self.seguePerformer {
                        performer("LoginSegue", nil)
                    }
                }
            } else {
                DispatchQueue.main.sync {
                    self.view.makeToast("Failed to create user.")
                }
            }
        }
    }

}

extension RegistrationViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
}
