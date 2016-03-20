//
//  EVCJobsDetailsViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/28/15.
//  Copyright © 2015 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVCJobsDetailsViewController : UIViewController

@property (nonatomic, retain) NSDictionary *jobEntry;
@property (nonatomic, retain) IBOutlet UILabel *jobtitleLabel, *companyLabel, *locLabel, *snippetLabel, *urlLabel;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andJob:(NSDictionary *) job;

@end
