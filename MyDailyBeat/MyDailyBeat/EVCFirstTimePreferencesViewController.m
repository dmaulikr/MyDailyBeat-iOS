//
//  EVCFirstTimePreferencesViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 7/12/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "EVCFirstTimePreferencesViewController.h"
#import "VervePreferences.h"
#import <RESideMenu.h>
#import "EVCViewController.h"

@interface EVCFirstTimePreferencesViewController ()

@end

@implementation EVCFirstTimePreferencesViewController

@synthesize api;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.formController = [[FXFormController alloc] init];
    self.formController.tableView = self.tableView;
    self.formController.delegate = self;
    self.formController.form = [[VervePreferences alloc] init];
    api = [RestAPI getInstance];
    
    [self retrievePrefs];
}

- (void) retrievePrefs {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        VervePreferences *prefs = [[VervePreferences alloc] init];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        prefs.userPreferences = [api getUserPreferencesForUser:[api getCurrentUser]];
        prefs.matchingPreferences = [api getMatchingPreferencesForUser:[api getCurrentUser]];
        prefs.hobbiesPreferences = [api getHobbiesPreferencesForUserWithScreenName:[api getCurrentUser].screenName];
        self.formController.form = prefs;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            [self.tableView reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) selectEthnicity:(UITableViewCell<FXFormFieldCell> *)cell {
    VervePreferences *prefs = cell.field.form;
    self.formController.form = prefs;
    NSLog(@"Hello World");
    [self.tableView reloadData];
}

- (void) selectBeliefs:(UITableViewCell<FXFormFieldCell> *)cell {
    VervePreferences *prefs = cell.field.form;
    self.formController.form = prefs;
    [self.tableView reloadData];
}

- (void)submit:(UITableViewCell<FXFormFieldCell> *)cell {
    VervePreferences *prefs = cell.field.form;
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        
        BOOL success = [api saveUserPreferences:prefs.userPreferences andMatchingPreferences:prefs.matchingPreferences forUser:[api getCurrentUser]];
        BOOL success2 = [api saveHobbiesPreferences:prefs.hobbiesPreferences forUserWithScreenName:[api getCurrentUser].screenName];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            if (success && success2) {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FirstTimeLogin"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else
                NSLog(@"Failed");
            
        });
    });
}

@end
