//
//  EVCRegistrationViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/18/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Constants.h>
#import <API.h>


@interface EVCRegistrationViewController : UIViewController {
    IBOutlet UIView *page1, *page2, *page3, *page4, *page5, *contentView;
    IBOutlet UITextField *first, *last, *uname, *pass, *pass_repeat, *emailaddr, *mobilephone;
    IBOutlet UIButton *page1b, *page2b, *page2p, *page3b, *page3p, *page4b, *page4p, *page5b, *page5p;
    IBOutlet UILabel *welcome1, *welcome2;
}

@property(strong, nonatomic) API *api;

@property(strong, nonatomic) NSString *firstName;
@property(strong, nonatomic) NSString *lastName;
@property(strong, nonatomic) NSString *birth_month;
@property(nonatomic) long birth_year;
@property(strong, nonatomic) NSString *zipcode;
@property(strong, nonatomic) NSString *screenName, *password;
@property(strong, nonatomic) NSString *email, *mobile;


@end
