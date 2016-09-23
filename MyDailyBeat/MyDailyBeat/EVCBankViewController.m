//
//  EVCBankViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 5/28/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "EVCBankViewController.h"
#import "Constants.h"
#import "VerveBankObject.h"
#import "RestAPI.h"
#import "EVCCommonMethods.h"

@interface EVCBankViewController ()

@end

@implementation EVCBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self retrieveBankData];
}

- (void) viewDidAppear:(BOOL)animated {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"myBank"];
    BankInfo * temp = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (temp != nil) {
        self.bank = temp;
        [self retrieveBankData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andBank:(BankInfo *) bankNotNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.bank = bankNotNil;
    }
    return self;
}

- (IBAction)gotoBank:(id)sender {
    if ([self isAppInstalled:self.bank.appName]) {
        NSString *name = self.bank.appName;
        name = [name stringByReplacingOccurrencesOfString:@" " withString:@"-"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[name stringByAppendingString:@"://"]]];
    } else {
        NSLog(@"%@", self.bank);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.bank.appURL]];
    }
}

- (BOOL) isAppInstalled: (NSString *) name {
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSLog(@"%@", [name stringByAppendingString:@"://"]);
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[name stringByAppendingString:@"://"]]];
}

- (BOOL) doesAppExist: (NSString *) name {
    __block BOOL val = false;
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        val = [[RestAPI getInstance] doesAppExistWithTerm:name andCountry:@"US"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
        });
    });
    
    return val;
    
}

- (void) retrieveBankData {
    if (self.bank != nil) {
        [nilLabel setHidden:YES];
        [imgView setHidden:NO];
        [btn setHidden:NO];
        [bankNameLbl setHidden:NO];
        dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
        dispatch_async(queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToastActivity];
            });
            NSURL *imgurl = [NSURL URLWithString:self.bank.iconURL];
            NSData *data = [NSData dataWithContentsOfURL:imgurl];
            UIImage *img = [[UIImage alloc] initWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view hideToastActivity];
                [imgView setImage:[EVCCommonMethods imageWithImage:img scaledToSize:CGSizeMake(120, 120)]];
                [bankNameLbl setText:self.bank.appName];
            });
        });
    } else {
        [nilLabel setHidden:NO];
        [imgView setHidden:YES];
        [btn setHidden:YES];
        [bankNameLbl setHidden:YES];
        [nilLabel setText:@"My Bank not Set"];
    }
}


@end
