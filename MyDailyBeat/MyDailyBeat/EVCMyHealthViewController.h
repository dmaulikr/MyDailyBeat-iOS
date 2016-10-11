//
//  EVCMyHealthViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 5/30/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "RestAPI.h"
#import <PrescripProviderInfo.h>
#import "HealthInfo.h"

@interface EVCMyHealthViewController : UIViewController {
    IBOutlet UIImageView *prescripProviderLogoView, *healthPortalLogoView;
    IBOutlet UILabel *prescripLabel, *portalLabel;
    IBOutlet UITapGestureRecognizer *prescripTap, *healthTap;
}

@property (nonatomic, retain) PrescripProviderInfo *provider;
@property (nonatomic, retain) HealthInfo *portal;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPrescriptionProvider: (PrescripProviderInfo *) provider andHealthPortal: (HealthInfo *) portal;

- (IBAction)goToProvider:(id)sender;
- (IBAction)goToPortal:(id)sender;


@end
