//
//  EVCRegistrationMessageViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/19/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "EVCRegistrationMessageViewController.h"
#import "EVCRegistrationViewController.h"

@interface EVCRegistrationMessageViewController ()

@end

@implementation EVCRegistrationMessageViewController

- (id) initWithKey: (int) key {
    self = [super initWithNibName:@"EVCRegistrationMessageViewController" bundle:nil];
    if (self) {
        if (key == 1) {
            self.message = WELCOME_MESSAGE_1;
        } else {
            self.message = WELCOME_MESSAGE_2;
        }
        self.key = key;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [messageLabel setText:self.message];
    self.navigationController.navigationBar.tintColor = UIColorFromHex(0x0097A4);
}

- (void) message1 {
    EVCRegistrationMessageViewController *message2 = [[EVCRegistrationMessageViewController alloc] initWithKey:2];
    [self.navigationController pushViewController:message2 animated:YES];
}

- (void) message2 {
    EVCRegistrationViewController *controller = [[EVCRegistrationViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)next:(id)sender {
    if (_key == 1) {
        [self message1];
    } else {
        [self message2];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
