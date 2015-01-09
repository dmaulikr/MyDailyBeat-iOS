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
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)save:(id)sender {
    NSString *about = self.aboutMeView.text;
    
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        
        int age = [[API getInstance] retrieveFlingPrefs].age;
        BOOL success = [[API getInstance] saveFlingProfileForUser:[[API getInstance] getCurrentUser] withAge:age andDescription:about];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            if (success) {
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    [self.view makeToast:@"Upload successful!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"VerveAPIBundle.bundle/check.png"]];
                }];
            } else {
                [self.view makeToast:@"Upload failed!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"VerveAPIBundle.bundle/error.png"]];
                return;
            }
        });
    });
}



@end
