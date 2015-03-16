//
//  EVCFeelingBlueViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 1/9/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVCFeelingBlueTableViewController.h"
#import "EVCCommonMethods.h"
#import "RESideMenu.h"


@interface EVCFeelingBlueViewController : UIViewController

@property (nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic) IBOutlet UIButton *callSuicide, *callVeterans, *callAnonymous;

- (IBAction)callSuicideAction:(id)sender;
- (IBAction)callVeteransAction:(id)sender;
- (IBAction)callAnonymousAction:(id)sender;

@end
