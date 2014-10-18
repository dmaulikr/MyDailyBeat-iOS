//
//  EVCGroupViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/25/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <API.h>
#import <GTScrollViewController.h>
#import <QuartzCore/CALayer.h>
#import <REComposeViewController.h>
#import <UIView+Toast.h>

@interface EVCGroupViewController : UIViewController <REComposeViewControllerDelegate>

@property (nonatomic) GTScrollViewController *scroll;
@property (nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) IBOutlet UILabel *screenNameLbl;
@property (nonatomic) IBOutlet UIButton *composeButton;
@property (nonatomic) Group *group;

- (id) initWithGroup:(Group *) g;

- (IBAction)writePost:(id)sender;

@end
