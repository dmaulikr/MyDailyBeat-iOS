//
//  EVCUserInviteViewController.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 11/7/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCUserInviteViewController.h"

@interface EVCUserInviteViewController ()

@end

@implementation EVCUserInviteViewController

- (id) initWithGroup:(Group *) g andRecipient:(VerveUser *) rec withSender:(VerveUser *) send {
    self = [super initWithNibName:@"EVCUserInviteViewController_iPhone" bundle:[NSBundle bundleForClass:[self class]]];
    if (self) {
        self.groupToInviteTo = g;
        self.recipient = rec;
        self.sender = send;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inviteMessage = [NSString stringWithFormat:@"Hey, %@, join my group on MyDailyBeat, %@!", self.recipient.name, self.groupToInviteTo.groupName];
    self.messageTxtView.text = self.inviteMessage;
    self.messageTxtView.delegate = self;
    self.nameLbl.text = [NSString stringWithFormat:@"Recipient Screen Name: %@", self.recipient.screenName];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithTitle:@"Send Invite" style:UIBarButtonItemStyleDone target:self action:@selector(sendInvite)];
    self.navigationItem.rightBarButtonItem = sendItem;
    self.navigationItem.title = @"Write Invite";
}

- (IBAction)changeSendingMethod:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.sendingmethod = SendByEmail;
            break;
        case 1:
            self.sendingmethod = SendByMobile;
            break;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    self.inviteMessage = textView.text;
}

- (void) sendInvite {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        BOOL success = [[RestAPI getInstance] inviteUser:self.recipient toJoinGroup:self.groupToInviteTo by:self.sendingmethod withMessage:self.inviteMessage];
        NSLog(@"%@", self.recipient);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            if (success)
                [self.presentingViewController.view makeToast:@"Invite sent!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"check.png"]];
            else {
                [self.presentingViewController.view makeToast:@"Invite send failed!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"error.png"]];
                return;
            }
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

        });
        
    });
}

@end
