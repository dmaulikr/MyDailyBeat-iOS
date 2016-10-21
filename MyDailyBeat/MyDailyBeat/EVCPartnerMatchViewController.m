//
//  EVCPartnerMatchViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/21/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCPartnerMatchViewController.h"

@interface EVCPartnerMatchViewController ()

@end

@implementation EVCPartnerMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.partners = [[NSMutableArray alloc] init];
    self.mode = [[NSUserDefaults standardUserDefaults] integerForKey:@"REL_MODE"];
    UIBarButtonItem *menuItem = self.navigationItem.rightBarButtonItem;
    
    if (self.mode == FRIENDS_MODE) {
        UIImage* image3 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"search-icon-white"] scaledToSize:CGSizeMake(30, 30)];
        CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
        UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
        [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
        [someButton addTarget:self action:@selector(searchFriend)
             forControlEvents:UIControlEventTouchUpInside];
        [someButton setShowsTouchWhenHighlighted:YES];
        
        UIBarButtonItem *menuButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
        
        self.navigationItem.rightBarButtonItems = @[menuItem, menuButton];
    }

    [self retrievePartners];
}

- (void) searchFriend {
    DLAVAlertView *alert = [[DLAVAlertView alloc] initWithTitle:@"Add Friend" message:@"Fill in at least 1 of the following fields:" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [alert addTextFieldWithText:@"" placeholder:@"Screen Name"];
    [alert addTextFieldWithText:@"" placeholder:@"Name"];
    [alert addTextFieldWithText:@"" placeholder:@"E-mail Address"];
    [alert addTextFieldWithText:@"" placeholder:@"Mobile"];
    [alert setKeyboardType:UIKeyboardTypeEmailAddress ofTextFieldAtIndex:2];
    [alert setKeyboardType:UIKeyboardTypePhonePad ofTextFieldAtIndex:3];
    [alert setAutoCapitalizationType:UITextAutocapitalizationTypeNone ofTextFieldAtIndex:0];
    [alert setAutoCapitalizationType:UITextAutocapitalizationTypeNone ofTextFieldAtIndex:2];
    [alert setAutoCapitalizationType:UITextAutocapitalizationTypeNone ofTextFieldAtIndex:3];
    [alert setAutoCorrectionType:UITextAutocorrectionTypeNo ofTextFieldAtIndex:0];
    [alert setAutoCorrectionType:UITextAutocorrectionTypeNo ofTextFieldAtIndex:1];
    [alert setAutoCorrectionType:UITextAutocorrectionTypeNo ofTextFieldAtIndex:2];
    [alert setAutoCorrectionType:UITextAutocorrectionTypeNo ofTextFieldAtIndex:3];
    [alert showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 0:
                // do nothing
                break;
            case 1: {
                NSString *screenName = [alertView textFieldTextAtIndex:0];
                NSString *name = [alertView textFieldTextAtIndex:1];
                NSString *email = [alertView textFieldTextAtIndex:2];
                NSString *mobile = [alertView textFieldTextAtIndex:3];
                dispatch_queue_t queue = dispatch_queue_create(APP_ID_C_STRING, NULL);
                dispatch_async(queue, ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.view makeToastActivity];
                    });
                    
                    if (screenName !=  nil) {
                        // search by Screen Name
                        BOOL exists = [[RestAPI getInstance] doesUserExistWithScreenName:screenName];
                        if (exists) {
                            VerveUser *other = [[RestAPI getInstance] getUserDataForUserWithScreenName:screenName];
                            [[RestAPI getInstance] addUser:other ToFriendsOfUser:[[RestAPI getInstance] getCurrentUser]];
                        } else {
                            // a user with that screenName does not exist.
                            if (name != nil && email != nil) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.view hideToastActivity];
                                    [self refer:name andEmail:email];
                                });
                            } else {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.view hideToastActivity];
                                    [self referWithNoInformation];
                                });
                            }
                        }
                    } else {
                        // search by name, email, or mobile
                        BOOL existsName = (name != nil) ? [[RestAPI getInstance] doesUserExistWithName:name] : false;
                        BOOL existsEmail = (email != nil) ? [[RestAPI getInstance] doesUserExistWithEmail:email] : false;
                        BOOL existsMobile = (mobile != nil) ? [[RestAPI getInstance] doesUserExistWithMobile:mobile] : false;
                        BOOL exists = existsName || existsEmail || existsMobile;
                        if (exists) {
                            if (existsName) {
                                VerveUser *other = [[RestAPI getInstance] getUserDataForUserWithName:name];
                                [[RestAPI getInstance] addUser:other ToFriendsOfUser:[[RestAPI getInstance] getCurrentUser]];
                            } else if (existsEmail) {
                                VerveUser *other = [[RestAPI getInstance] getUserDataForUserWithEmail:email];
                                [[RestAPI getInstance] addUser:other ToFriendsOfUser:[[RestAPI getInstance] getCurrentUser]];
                            } else if (existsMobile) {
                                VerveUser *other = [[RestAPI getInstance] getUserDataForUserWithMobile:mobile];
                                [[RestAPI getInstance] addUser:other ToFriendsOfUser:[[RestAPI getInstance] getCurrentUser]];
                            }
                        } else {
                            if (name != nil && email != nil) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.view hideToastActivity];
                                    [self refer:name andEmail:email];
                                });
                            } else {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.view hideToastActivity];
                                    [self referWithNoInformation];
                                });
                            }
                        }
                    }
                });
            }
                break;
                
            default:
                break;
        }
    }];

}

- (void) referWithNoInformation {
    DLAVAlertView *alert = [[DLAVAlertView alloc] initWithTitle:@"Refer a Friend" message:@"No such user with that information exists. If you would like to invite this person to join MyDailyBeat, enter their name and email address." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Invite", nil];
    [alert addTextFieldWithText:@"" placeholder:@"Name"];
    [alert addTextFieldWithText:@"" placeholder:@"E-mail Address"];
    [alert setKeyboardType:UIKeyboardTypeEmailAddress ofTextFieldAtIndex:1];
    [alert setAutoCapitalizationType:UITextAutocapitalizationTypeNone ofTextFieldAtIndex:1];
    [alert setAutoCorrectionType:UITextAutocorrectionTypeNo ofTextFieldAtIndex:0];
    [alert setAutoCorrectionType:UITextAutocorrectionTypeNo ofTextFieldAtIndex:1];
    [alert showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 0:
                // do nothing
                break;
            case 1: {
                NSString *name = [alertView textFieldTextAtIndex:0];
                NSString *email = [alertView textFieldTextAtIndex:1];
                dispatch_queue_t queue = dispatch_queue_create(APP_ID_C_STRING, NULL);
                dispatch_async(queue, ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.view makeToastActivity];
                    });
                    BOOL result = [[RestAPI getInstance] sendReferralFromUser:[[RestAPI getInstance] getCurrentUser] toPersonWithName:name andEmail:email];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.view hideToastActivity];
                        if (result) {
                            [self.view makeToast:@"Referral sent successfully!" duration:3.5 position:@"bottom"];
                        } else {
                            [self.view makeToast:@"Could not send referral." duration:3.5 position:@"bottom"];
                        }
                        
                    });
                });
            }
                break;
                
            default:
                break;
        }
    }];
}

- (void) refer: (NSString *) name andEmail: (NSString *) email {
    DLAVAlertView *alert = [[DLAVAlertView alloc] initWithTitle:@"Refer a Friend" message:@"No user with that information exists. Would you like to refer them to join MyDailyBeat?" delegate:nil cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 0:
                // do nothing
                break;
            case 1: {
                dispatch_queue_t queue = dispatch_queue_create(APP_ID_C_STRING, NULL);
                dispatch_async(queue, ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.view makeToastActivity];
                    });
                    BOOL result = [[RestAPI getInstance] sendReferralFromUser:[[RestAPI getInstance] getCurrentUser] toPersonWithName:name andEmail:email];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.view hideToastActivity];
                        if (result) {
                            [self.view makeToast:@"Referral sent successfully!" duration:3.5 position:@"bottom"];
                        } else {
                            [self.view makeToast:@"Could not send referral." duration:3.5 position:@"bottom"];
                        }
                        
                    });
                });
            }
                break;
                
            default:
                break;
        }
    }];
}

- (void) retrievePartners {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        if (self.mode != FRIENDS_MODE) {
            self.partners = [[NSMutableArray alloc] initWithArray:[[RestAPI getInstance] getFlingProfilesBasedOnPrefsOfUser:[[RestAPI getInstance] getCurrentUser]]];
            if ([self.partners count] >= 1) {
                if ([((FlingProfile *)[self.partners objectAtIndex:0]).screenName isEqualToString:[[RestAPI getInstance] getCurrentUser].screenName]) {
                    [self.partners removeObjectAtIndex:0];
                }
            }
        } else {
            NSArray *hobbMatches = [[RestAPI getInstance] getHobbiesMatchesForUserWithScreenName:[[RestAPI getInstance] getCurrentUser].screenName];
            self.partners = [[NSMutableArray alloc] init];
            for (HobbiesMatchObject *obj in hobbMatches) {
                [self.partners addObject:[[RestAPI getInstance] getFlingProfileForUser:obj.userObj]];
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            [self.tableView reloadData];
        });
    });
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.partners count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
    }
    
    if ([self.partners count] == 0) {
        cell.textLabel.text = @"No Results Found";
    } else {
        cell.textLabel.text = ((FlingProfile *)[self.partners objectAtIndex:indexPath.row]).screenName;
        cell.imageView.image = [self loadPictureForUser:((FlingProfile *)[self.partners objectAtIndex:indexPath.row]).screenName];
    }
    
    return cell;
}

- (UIImage *) loadPictureForUser: (NSString *) screenName {
    __block UIImage *img;
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        NSURL *imageURL = [[RestAPI getInstance] retrieveProfilePictureForUserWithScreenName:screenName];
        NSData *imageData = [[RestAPI getInstance] fetchImageAtRemoteURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            img = [UIImage imageWithData:imageData];
            
        });
        
    });
    
    return img;
    
}



#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    EVCFlingProfileViewController *prof = [[EVCFlingProfileViewController alloc] initWithNibName:@"EVCFlingProfileViewController" bundle:nil andUser:[[RestAPI getInstance] getUserDataForUserWithScreenName:((FlingProfile *)[self.partners objectAtIndex:indexPath.row]).screenName]];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:prof animated:YES];
}

@end
