//
//  EVCGroupViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/25/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestAPI.h>
#import <QuartzCore/CALayer.h>
#import <UIView+Toast.h>
#import "EVCCommonMethods.h"
#import "RESideMenu.h"
#import "EVCPostView.h"
#import <EVCComposeViewController.h>
#import <EVCGroupSettingsViewController.h>
#import "EVCViewController.h"
#import <EVCUserSearchViewViewController.h>


@interface EVCGroupViewController : UIViewController <EVCGroupSettingsViewControllerDelegate>{
    int max_post_height;
}

@property (nonatomic) IBOutlet UIScrollView *scroll;
@property (nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) UIBarButtonItem *composeButton, *settingsButton, *inviteButton;
@property (nonatomic) Group *group;
@property (nonatomic) IBOutlet UIToolbar *groupBar;
@property (nonatomic) UIViewController *parentController;


- (id) initWithGroup:(Group *) g andParent:(UIViewController *) parent;

- (void)writePost;
- (void)groupSettings;
- (void) deletePost:(Post *) p;


@end
