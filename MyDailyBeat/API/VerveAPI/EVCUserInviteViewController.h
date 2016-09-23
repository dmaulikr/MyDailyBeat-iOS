//
//  EVCUserInviteViewController.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 11/7/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerveUser.h"
#import "RestAPI.h"
#import "Group.h"
#import "Constants.h"



@interface EVCUserInviteViewController : UIViewController <UITextViewDelegate>

@property(nonatomic) IBOutlet UILabel *nameLbl;
@property(nonatomic) IBOutlet UITextView *messageTxtView;
@property(nonatomic) IBOutlet UISegmentedControl *methodChooser;
@property EVCUserInviteSendingMethod sendingmethod;

@property(nonatomic) VerveUser *sender, *recipient;
@property(nonatomic) Group *groupToInviteTo;
@property(nonatomic) NSString *inviteMessage;

- (id) initWithGroup:(Group *) g andRecipient:(VerveUser *) rec withSender:(VerveUser *) send;

@end
