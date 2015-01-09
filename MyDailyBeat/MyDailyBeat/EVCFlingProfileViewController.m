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

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andUser: (VerveUser *) user{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentViewedUser = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.currentViewedUser isEqual:[[API getInstance] getCurrentUser]]) {
        [self.addFavsBtn setHidden:YES];
        [self.sendMessageBtn setHidden:YES];
    }
    [self retrievePrefs];
    self.nameLbl.text = self.currentViewedUser.screenName;
    self.distanceLbl.text = @"";
    [self loadPicture];
    
}

- (void) loadPicture {
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

- (void) retrievePrefs {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        
        self.prefs = [[API getInstance] retrieveFlingPrefs];
        NSMutableArray *favs = [[NSMutableArray alloc] initWithArray:[[API getInstance] getFlingFavoritesForUser:[[API getInstance] getCurrentUser]]];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            if ([favs indexOfObject:[[API getInstance] getFlingProfileForUser:self.currentViewedUser]] != NSNotFound) {
                [self.addFavsBtn setTitle:@"Remove Favorite" forState:UIControlStateNormal];
            }
            if (self.prefs == nil)
                self.prefs = [[RelationshipPrefs alloc] init];
            self.ageLbl.text = [NSString stringWithFormat:@"Age: %d", self.prefs.age];
            self.aboutMeView.text = [[API getInstance] getFlingProfileForUser:self.currentViewedUser].aboutMe;
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
