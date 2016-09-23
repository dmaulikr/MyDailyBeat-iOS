//
//  EVCRegistrationViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/18/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXForms.h"

@interface EVCRegistrationViewController : UITableViewController <FXFormControllerDelegate>

@property (nonatomic, strong) FXFormController *formController;

@end
