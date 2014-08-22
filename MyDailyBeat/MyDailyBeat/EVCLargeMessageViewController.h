//
//  EVCLargeMessageViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/18/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVCLargeMessageViewController : UIViewController

@property(nonatomic, retain) IBOutlet UILabel *messageLabel;
@property(nonatomic, retain) NSString *message;

- (id) initWithMessage: (NSString *) text;

@end
