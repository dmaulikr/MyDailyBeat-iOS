//
//  EVCFirstTimeSetupViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 7/12/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewPagerController.h"
#import "Constants.h"
#import <API.h>
#import "VervePreferences.h"

@interface EVCFirstTimeSetupViewController : UIViewController

@property (strong, nonatomic) API *api;
@property (strong, nonatomic) IBOutlet UILabel *message;
@property (strong, nonatomic) IBOutlet UIButton *next;

- (IBAction)next:(id)sender;



@end
