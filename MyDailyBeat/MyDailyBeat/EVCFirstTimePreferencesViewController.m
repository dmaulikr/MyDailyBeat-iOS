//
//  EVCFirstTimePreferencesViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 7/12/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "EVCFirstTimePreferencesViewController.h"

@interface EVCFirstTimePreferencesViewController ()

@end

@implementation EVCFirstTimePreferencesViewController

@synthesize api;

- (id) initWithPrefs: (id<FXForm>) prefs {
    self = [super initWithNibName:@"EVCFirstTimePreferencesViewController" bundle:nil];
    if (self) {
        self.prefs = prefs;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.formController = [[FXFormController alloc] init];
    self.formController.tableView = self.tableView;
    self.formController.form = self.prefs;
    self.formController.delegate = self;
    self.api = [API getInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit:(id)sender {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        
        BOOL success;
        if ([self.formController.form isKindOfClass:[VerveUserPreferences class]]) {
            success = [api saveUserPreferences:(VerveUserPreferences *) self.formController.form forUser:[api getCurrentUser]];
        } else if ([self.formController.form isKindOfClass:[VerveMatchingPreferences class]]) {
            success = [api saveMatchingPreferences:(VerveMatchingPreferences *) self.formController.form forUser:[api getCurrentUser]];
        } else {
            success = [api saveHobbiesPreferences:(HobbiesPreferences *)self.formController.form forUserWithScreenName:[api getCurrentUser].screenName];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            
        });
    });
}

@end
