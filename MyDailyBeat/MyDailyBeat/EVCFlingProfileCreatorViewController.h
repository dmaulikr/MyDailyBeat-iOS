//
//  EVCFlingProfileCreatorViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 1/4/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <API.h>
#import "EVCInterestsSelectorTableViewController.h"
#import "Constants.h"

@interface EVCFlingProfileCreatorViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextView *aboutMeView;
@property (nonatomic, retain) IBOutlet UIButton *okButton, *interestsButton;
@property (nonatomic, retain) NSMutableArray *interests;

@property (nonatomic) REL_MODE mode;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andMode:(REL_MODE) mode;

- (IBAction)save:(id)sender;

@end
