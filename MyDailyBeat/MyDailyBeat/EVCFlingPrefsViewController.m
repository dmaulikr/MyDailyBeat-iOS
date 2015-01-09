//
//  EVCFlingPrefsViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/24/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCFlingPrefsViewController.h"

@interface EVCFlingPrefsViewController ()

@end

@implementation EVCFlingPrefsViewController

@synthesize tableView, api, formController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.formController = [[FXFormController alloc] init];
    self.formController.tableView = self.tableView;
    self.formController.delegate = self;
    self.formController.form = [[RelationshipPrefs alloc] init];
    api = [API getInstance];
    
    [self retrievePrefs];
    
        
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //reload the table
    
}

- (void) viewDidAppear:(BOOL)animated {
    
}

- (void) retrievePrefs {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        
        self.formController.form = [api retrieveFlingPrefs];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            if (self.formController.form == nil)
                self.formController.form = [[RelationshipPrefs alloc] init];
            [self.tableView reloadData];
            
        });
    });
    
}

- (void)submit:(UITableViewCell<FXFormFieldCell> *)cell {
    RelationshipPrefs *prefs = cell.field.form;
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });

        BOOL success = [api uploadFlingPrefs:prefs];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            if (success)
                [self.navigationController popViewControllerAnimated:YES];
            else
                NSLog(@"Failed");
            
        });
    });
}

- (void)itemSelected {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
