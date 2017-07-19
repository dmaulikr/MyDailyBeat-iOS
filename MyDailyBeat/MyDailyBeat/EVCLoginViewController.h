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
#import "API.h"
#import "EVCProfileViewController.h"

@interface EVCLoginViewController : UIViewController{
    IBOutlet UIImageView *header;
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *signInButton;
    IBOutlet UITextField *userNameFeild;
    IBOutlet UITextField *passWordFeild;
}

@property(nonatomic, retain) IBOutlet UITextField *userNameFeild;
@property(nonatomic, retain) IBOutlet UITextField *passWordFeild;

- (IBAction)login:(id)sender;

@end
