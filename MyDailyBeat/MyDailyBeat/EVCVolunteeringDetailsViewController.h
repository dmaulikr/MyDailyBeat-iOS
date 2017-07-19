//
//  EVCJobsDetailsViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/28/15.
//  Copyright © 2015 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"

@import API;
@interface EVCVolunteeringDetailsViewController : UIViewController

@property (nonatomic, retain) NSDictionary *opportunity;
@property (nonatomic, retain) IBOutlet UILabel *titleLbl, *locLabel, *parentOrgLabel, *startLabel, *endLabel;
@property (nonatomic, retain) IBOutlet UITextView *urlTextView, *descripTextView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOpportunity:(NSDictionary *) opportunity;

@end
