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

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andMode:(REL_MODE) mode {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mode = mode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationItem].title = @"Edit Fling Profile";
    if (self.mode == FRIENDS_MODE) {
        [self.interestsButton setHidden:NO];
    } else {
        [self.interestsButton setHidden:YES];
    }
    
}

- (IBAction)selectInterests:(id)sender {
    EVCInterestsSelectorTableViewController *selector = [[EVCInterestsSelectorTableViewController alloc] init];
    [self.navigationController pushViewController:selector animated:YES];
}

- (IBAction)save:(id)sender {
    NSString *about = self.aboutMeView.text;
    
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        
        VerveUserPreferences* prefs = [[API getInstance] getUserPreferencesForUser:[[API getInstance] getCurrentUser]];
        int age = prefs.age;
        BOOL success = [[API getInstance] saveFlingProfileForUser:[[API getInstance] getCurrentUser] withAge:age andDescription:about andInterests:self.interests];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            if (success) {
                [self.view makeToast:@"Upload successful!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"VerveAPIBundle.bundle/check.png"]];
                [self.navigationController popToViewController:self.parentViewController animated:YES];
            } else {
                [self.view makeToast:@"Upload failed!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"VerveAPIBundle.bundle/error.png"]];
                return;
            }
        });
    });
}



@end
