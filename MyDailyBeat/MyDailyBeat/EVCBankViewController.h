//
//  EVCBankViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 5/28/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"

@interface EVCBankViewController : UIViewController {
    IBOutlet UIImageView *imgView;
    IBOutlet UIButton *btn;
    IBOutlet UILabel *bankNameLbl, *nilLabel;
}

@property (nonatomic) BankInfo *bank;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andBank:(BankInfo *) bankNotNil;

- (IBAction)gotoBank:(id)sender;

@end
