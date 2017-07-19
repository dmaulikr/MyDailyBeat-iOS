//
//  EVCGroupCreationTableViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/31/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "EVCGroupCreationTableViewController.h"

@interface EVCGroupCreationTableViewController ()

@end

@implementation EVCGroupCreationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.formController = [[FXFormController alloc] init];
    self.formController.tableView = self.tableView;
    self.formController.delegate = self;
    self.formController.form = [[GroupCreationForm alloc] init];
    self.navigationItem.title = @"New Group";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)createGroup:(UITableViewCell<FXFormFieldCell> *)cell {
    GroupCreationForm *frm = cell.field.form;
    NSString *name = frm.groupName;
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.sideMenuViewController.contentViewController.view makeToastActivity];
        });
        BOOL success = [[RestAPI getInstance] createGroupWithName:name];
        if (frm.hobbies != nil && [frm.hobbies count] > 0) {
            NSMutableArray *groups = [[RestAPI getInstance] getGroupsForCurrentUser];
            for (int i = 0 ; i < [groups count] ; i++) {
                Group *g = [groups objectAtIndex:i];
                if ([g.groupName isEqualToString:name]) {
                    g.hobbies =  [[NSMutableArray alloc] initWithArray:frm.hobbies];
                    success = [[RestAPI getInstance] setHobbiesforGroup:g];
                    break;
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.sideMenuViewController.contentViewController.view hideToastActivity];
            if (success)
                [self.sideMenuViewController.contentViewController.view makeToast:@"Group creation successful!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"check.png"]];
            else {
                [self.sideMenuViewController.contentViewController.view makeToast:@"Group creation failed!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"error.png"]];
                return;
            }
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        });
    });
}

@end
