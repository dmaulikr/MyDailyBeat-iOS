//
//  EVCFlingProfileViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/21/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VerveUser.h>
#import <API.h>
#import "EVCFlingMessagingViewController.h"
#import "EVCFlingProfileCreatorViewController.h"

@interface EVCFlingProfileViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *profilePicView;
@property (nonatomic, retain) IBOutlet UILabel *nameLbl, *ageLbl, *genderLbl, *distanceLbl, *orientationlbl;
@property (nonatomic, retain) IBOutlet UIButton *addFavsBtn, *sendMessageBtn, *editBtn;
@property (nonatomic, retain) IBOutlet UITextView *aboutMeView;
@property (nonatomic, retain) VerveUser *currentViewedUser;
@property (nonatomic, retain) VerveUserPreferences *prefs;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andUser: (VerveUser *) user;

- (IBAction)fav:(id)sender;
- (IBAction)message:(id)sender;
- (IBAction)edit:(id)sender;

@end
