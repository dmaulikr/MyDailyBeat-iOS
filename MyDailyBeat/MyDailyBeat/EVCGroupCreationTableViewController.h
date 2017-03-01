//
//  EVCGroupCreationTableViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/31/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"

@import API;
@interface EVCGroupCreationTableViewController : UITableViewController <FXFormControllerDelegate>

@property (nonatomic, strong) FXFormController *formController;

@end
