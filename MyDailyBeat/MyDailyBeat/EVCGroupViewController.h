//
//  EVCGroupViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/25/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <API.h>
#import <QuartzCore/CALayer.h>
#import <UIView+Toast.h>
#import "EVCCommonMethods.h"
#import "RESideMenu.h"
#import "EVCPostView.h"
#import <EVCComposeViewController.h>
#import <EVCGroupSettingsViewController.h>


@interface EVCGroupViewController : UIViewController {
    int max_post_height;
}

@property (nonatomic) IBOutlet UIScrollView *scroll;
@property (nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) IBOutlet UILabel *screenNameLbl;
@property (nonatomic) IBOutlet UIButton *composeButton, *settingsButton;
@property (nonatomic) Group *group;

- (id) initWithGroup:(Group *) g;

- (IBAction)writePost:(id)sender;
- (IBAction)groupSettings:(id)sender;


@end
