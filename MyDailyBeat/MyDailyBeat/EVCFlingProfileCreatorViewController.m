//
//  EVCFlingProfileCreatorViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 1/4/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import "EVCFlingProfileCreatorViewController.h"

@interface EVCFlingProfileCreatorViewController ()

@end

@implementation EVCFlingProfileCreatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mode = [[NSUserDefaults standardUserDefaults] integerForKey:@"REL_MODE"];
    [self navigationItem].title = @"Edit Fling Profile";
    self.aboutMeView.layer.borderWidth = 1.0f;
    self.aboutMeView.layer.borderColor =  [UIColorFromHex(0x0097A4) CGColor];
    self.aboutMeView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
}

- (IBAction)save:(id)sender {
    NSString *about = self.aboutMeView.text;
    
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        
        VerveUserPreferences* prefs = [[RestAPI getInstance] getUserPreferencesForUser:[[RestAPI getInstance] getCurrentUser]];
        int age = prefs.age;
        BOOL success = [[RestAPI getInstance] saveFlingProfileForUser:[[RestAPI getInstance] getCurrentUser] withAge:age andDescription:about andInterests:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            if (success) {
                [self.view makeToast:@"Upload successful!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"check.png"]];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self.view makeToast:@"Upload failed!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"error.png"]];
                return;
            }
        });
    });
}



@end
