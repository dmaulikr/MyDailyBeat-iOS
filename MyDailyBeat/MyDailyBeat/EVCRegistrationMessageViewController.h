//
//  EVCRegistrationMessageViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/19/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"

@interface EVCRegistrationMessageViewController : UIViewController {
    IBOutlet UILabel *messageLabel;
    IBOutlet UIButton *nextButton;
}

@property (nonatomic, retain) NSString *message;
@property int key;

- (id) initWithKey: (int) key;
- (IBAction)next:(id)sender;

@end
