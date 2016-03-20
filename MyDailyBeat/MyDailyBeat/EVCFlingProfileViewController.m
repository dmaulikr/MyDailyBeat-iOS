//
//  EVCFlingProfileViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/21/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCFlingProfileViewController.h"

@interface EVCFlingProfileViewController ()

@end

@implementation EVCFlingProfileViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andUser: (VerveUser *) user andMode:(NSNumber *)friendsMode {
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentViewedUser = user;
        self.friendsMode = friendsMode;
        NSLog(@"The value of bool2 is = %@", (self.friendsMode ? @"YES" : @"NO"));
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void) viewDidAppear:(BOOL)animated {
    if ([self.currentViewedUser isEqual:[[API getInstance] getCurrentUser]]) {
        [self.addFavsBtn setHidden:YES];
        [self.sendMessageBtn setHidden:YES];
        [self.editBtn setHidden:NO];
    } else {
        [self.editBtn setHidden:YES];
    }
    [self retrievePrefs];
    self.nameLbl.text = self.currentViewedUser.screenName;
    self.distanceLbl.text = @"";
    [self loadProfile];
    [self loadPicture];
}

- (IBAction)edit:(id)sender {
    EVCFlingProfileCreatorViewController *edit = [[EVCFlingProfileCreatorViewController alloc] initWithNibName:@"EVCFlingProfileCreatorViewController" bundle:nil andMode:self.friendsMode];
    [self.navigationController pushViewController:edit animated:YES];
}

- (void) loadProfile {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        NSURL *imageURL = [[API getInstance] retrieveProfilePictureForUserWithScreenName:self.currentViewedUser.screenName];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [self.profilePicView setImage:[UIImage imageWithData:imageData]];
            
        });
        
    });
    
}

- (void) loadPicture {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        FlingProfile *prof = [[API getInstance] getFlingProfileForUser:self.currentViewedUser];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            self.aboutMeView.text = prof.aboutMe;
        });
        
    });
    
}

- (void) retrievePrefs {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        
        self.prefs = [[API getInstance] getUserPreferencesForUser: [[API getInstance] getCurrentUser]];
        self.matching = [[API getInstance] getMatchingPreferencesForUser:[[API getInstance] getCurrentUser]];
        NSMutableArray *favs = [[NSMutableArray alloc] initWithArray:[[API getInstance] getFlingFavoritesForUser:[[API getInstance] getCurrentUser]]];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            if ([favs indexOfObject:[[API getInstance] getFlingProfileForUser:self.currentViewedUser]] != NSNotFound) {
                [self.addFavsBtn setTitle:@"Remove Favorite" forState:UIControlStateNormal];
            }
            if (self.prefs == nil)
                self.prefs = [[VerveUserPreferences alloc] init];
            switch (self.prefs.age) {
                case 0:
                    self.ageLbl.text = @"50-54";
                    break;
                case 1:
                    self.ageLbl.text = @"55-59";
                    break;
                case 2:
                    self.ageLbl.text = @"60-64";
                    break;
                case 3:
                    self.ageLbl.text = @"65-69";
                    break;
                case 4:
                    self.ageLbl.text = @"70-74";
                    break;
                case 5:
                    self.ageLbl.text = @"75-79";
                    break;
                case 6:
                    self.ageLbl.text = @"80-84";
                    break;
                case 7:
                    self.ageLbl.text = @"85-89";
                    break;
                case 8:
                    self.ageLbl.text = @"90-94";
                    break;
                case 9:
                    self.ageLbl.text = @"95-99";
                    break;
                case 10:
                    self.ageLbl.text = @"100+";
                    break;
            }
            self.aboutMeView.text = [[API getInstance] getFlingProfileForUser:self.currentViewedUser].aboutMe;
            switch (self.prefs.gender) {
                case 0:
                    self.genderLbl.text = @"Male";
                    break;
                case 1:
                    self.genderLbl.text = @"Female";
                    break;
                case 2:
                    self.genderLbl.text = @"Transgender Male";
                    break;
                case 3:
                    self.genderLbl.text = @"Transgender Female";
                    break;
            }
            NSString *orientation = @"";
            switch (self.matching.gender) {
                case 0:
                    orientation = @"Male";
                    break;
                case 1:
                    orientation = @"Female";
                    break;
                case 2:
                    orientation = @"Transgender Male";
                    break;
                case 3:
                    orientation = @"Transgender Female";
                    break;
            }
            
            orientation = [@"Looking for a\n" stringByAppendingString:orientation];
            self.orientationlbl.text = orientation;
            switch (self.prefs.ethnicity) {
                case 0:
                    self.distanceLbl.text = @"White/Caucasian";
                    break;
                case 1:
                    self.distanceLbl.text = @"Black/African-American";
                    break;
                case 2:
                    self.distanceLbl.text = @"Asian";
                    break;
                case 3:
                    self.distanceLbl.text = @"Native American Indian/Native Alaskan";
                    break;
                case 4:
                    self.distanceLbl.text = @"Latino/Hispanic";
                    break;
                case 5:
                    self.distanceLbl.text = self.prefs.otherEthnicity;
                    break;
            }
            
        });
    });
    
}

- (IBAction)fav:(id)sender {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        
        NSMutableArray *favs = [[NSMutableArray alloc] initWithArray:[[API getInstance] getFlingFavoritesForUser:[[API getInstance] getCurrentUser]]];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            if ([favs indexOfObject:[[API getInstance] getFlingProfileForUser:self.currentViewedUser]] != NSNotFound) {
                [self.addFavsBtn setTitle:@"Add Favorite" forState:UIControlStateNormal];
                // remove favorite
            } else {
                [self.addFavsBtn setTitle:@"Remove Favorite" forState:UIControlStateNormal];
                [[API getInstance] addUser:self.currentViewedUser ToFlingFavoritesOfUser:[[API getInstance] getCurrentUser]];
            }
        });
    });
}

- (IBAction) message:(id)sender {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        
        MessageChatroom *chatroom = [[API getInstance] createChatroomForUsersWithScreenName:[[API getInstance] getCurrentUser].screenName andScreenName:self.currentViewedUser.screenName];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            EVCFlingMessagingViewController *message = [[EVCFlingMessagingViewController alloc] initWithChatroom:chatroom];
            [self.navigationController pushViewController:message animated:YES];
            
        });
    });
}




@end
