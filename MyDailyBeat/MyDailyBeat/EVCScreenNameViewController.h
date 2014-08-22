//
//  EVCScreenNameViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/19/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EVCRegistrationViewController;

@interface EVCScreenNameViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITextField *screenNameField, *passField, *verifyPassField;
@property (nonatomic, retain) EVCRegistrationViewController *parentController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andParent:(EVCRegistrationViewController *) parent;

@end
