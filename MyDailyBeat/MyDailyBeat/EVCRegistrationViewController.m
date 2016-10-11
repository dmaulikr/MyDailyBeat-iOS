//
//  EVCRegistrationViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/18/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "EVCRegistrationViewController.h"
#import "RegisterObject1.h"
#import <RestAPI.h>
#import "UIView+Toast.h"
#import "Constants.h"
#import "EVCFirstTimeSetupViewController.h"

@interface EVCRegistrationViewController ()

@end

@implementation EVCRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.formController = [[FXFormController alloc] init];
    self.formController.tableView = self.tableView;
    self.formController.delegate = self;
    RegisterObject1 *obj1 = [[RegisterObject1 alloc] init];
    self.formController.form = obj1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)submit:(UITableViewCell<FXFormFieldCell> *)cell {
    RegisterObject1 *frm = self.formController.form;
    BOOL result = (frm.first != nil) || !([frm.first isEqualToString:@""]);
    result = result && ((frm.last != nil) || !([frm.last isEqualToString:@""]));
    result = result && (frm.birthday != nil);
    result = result && ((frm.zipcode != nil) || !([frm.zipcode isEqualToString:@""]));
    result = result && ((frm.part2.screenName != nil) || !([frm.part2.screenName isEqualToString:@""]));
    result = result && ((frm.part2.password != nil) || !([frm.part2.password isEqualToString:@""]));
    result = result && ((frm.part2.verifyPassword != nil) || !([frm.part2.verifyPassword isEqualToString:@""]));
    result = result && ((frm.part2.part3.email != nil) || !([frm.part2.part3.email isEqualToString:@""]));
    result = result && ((frm.part2.part3.mobile != nil) || !([frm.part2.part3.mobile isEqualToString:@""]));
    if (result) {
        NSString *pass = frm.part2.password;
        NSCharacterSet * numset = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        NSString *lset = @"abcdefghijklmnopqrstuvwxyz";
        lset = [lset stringByAppendingString:[lset uppercaseString]];
        NSCharacterSet * abcset = [NSCharacterSet characterSetWithCharactersInString:lset];
        result = (pass.length >= 6 && pass.length <= 20);
        result = result && ([pass rangeOfCharacterFromSet:numset].location != NSNotFound);
        result = result && ([pass rangeOfCharacterFromSet:abcset].location != NSNotFound);
        if (result) {
            if ([frm.part2.password isEqualToString:frm.part2.verifyPassword]) {
                BOOL userExistsWithScreenName = [[RestAPI getInstance] doesUserExistWithScreenName:frm.part2.screenName];
                BOOL userExistsWithEmail = [[RestAPI getInstance] doesUserExistWithEmail:frm.part2.part3.email];
                BOOL userExistsWithMobile = [[RestAPI getInstance] doesUserExistWithMobile:frm.part2.part3.mobile];
                if (!userExistsWithScreenName && !userExistsWithEmail && !userExistsWithMobile) {
                    VerveUser *newuser = [[VerveUser alloc] init];
                    newuser.name = [NSString stringWithFormat:@"%@ %@", frm.first, frm.last];
                    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                    NSDateComponents *bd = [gregorianCalendar components:NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear fromDate:frm.birthday];
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    NSString *monthName = [[df monthSymbols] objectAtIndex:([bd month]-1)];
                    newuser.birth_month = monthName;
                    newuser.birth_date = [bd day];
                    newuser.birth_year = [bd year];
                    newuser.zipcode = frm.zipcode;
                    newuser.screenName = frm.part2.screenName;
                    newuser.password = frm.part2.password;
                    newuser.email = frm.part2.part3.email;
                    newuser.mobile = frm.part2.part3.mobile;
                    dispatch_queue_t queue = dispatch_queue_create(APP_ID_C_STRING, NULL);
                    dispatch_async(queue, ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.view makeToastActivity];
                        });
                        BOOL result = [[RestAPI getInstance] createUser:newuser];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.view hideToastActivity];
                            if (result) {
                                [self.view makeToast:@"User creation successful!" duration:3.5 position:@"bottom"];
                                [[NSUserDefaults standardUserDefaults] setObject:newuser.screenName forKey:KEY_SCREENNAME];
                                [[NSUserDefaults standardUserDefaults] setObject:newuser.password forKey:KEY_PASSWORD];
                                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FirstTimeLogin"];
                                [self.navigationController popViewControllerAnimated:YES];
                            } else {
                                [self.view makeToast:@"User creation failed!" duration:3.5 position:@"bottom"];
                                return;
                            }
                        });
                    });
                } else {
                    if (userExistsWithScreenName) {
                        [self.view makeToast:@"This screen name is unavailable." duration:3.5 position:@"bottom"];
                    } else if (userExistsWithEmail) {
                        [self.view makeToast:@"An account with this email address already exists." duration:3.5 position:@"bottom"];
                    } else {
                        [self.view makeToast:@"An account with this mobile phone number already exists." duration:3.5 position:@"bottom"];
                    }
                }
                
            } else {
                [self.view makeToast:@"Passwords do not match." duration: 3.5 position:CSToastPositionBottom];
            }
        } else {
            [self.view makeToast:@"Invalid password." duration: 3.5 position:CSToastPositionBottom];
        }
    } else {
        [self.view makeToast:@"Required field not filled." duration: 3.5 position:CSToastPositionBottom];
    }
    
}

@end
