//
//  EVCLoginViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/18/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVCTextFieldTableViewCell.h"
#import "EVCLabelTableViewCell.h"
#import "EVCRegistrationViewController.h"
#import "UIView+Toast.h"
#import "Constants.h"
#import "RESideMenu.h"
#import "EVCProfileViewController.h"

@interface EVCLoginViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UIImageView *header;
    IBOutlet UIButton *loginButton;
    IBOutlet UITableView *fields;
    IBOutlet UIButton *signUp;
    UITextField *userNameFeild;
    UITextField *passWordFeild;
}

@property(nonatomic, retain) UITextField *userNameFeild;
@property(nonatomic, retain) UITextField *passWordFeild;

- (IBAction)login:(id)sender;
- (IBAction)signup:(id)sender;

@end
