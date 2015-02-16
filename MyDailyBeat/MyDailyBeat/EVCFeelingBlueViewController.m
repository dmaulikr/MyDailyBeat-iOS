//
//  EVCFeelingBlueViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 1/9/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import "EVCFeelingBlueViewController.h"

@interface EVCFeelingBlueViewController ()

@end

@implementation EVCFeelingBlueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)callSuicideAction:(id)sender {
    UIAlertController *action = [UIAlertController alertControllerWithTitle:@"Call Suicide Hotline?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self makeCall: @"1-800-273-8255"];
    }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //none
    }];
    
    [action addAction:no];
    [action addAction:yes];
    [self presentViewController:action animated:YES completion:nil];
}
- (IBAction)callVeteransAction:(id)sender {
    UIAlertController *action = [UIAlertController alertControllerWithTitle:@"Call Veterans Hotline?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self makeCall: @"1-800-273-8255" withAccessCode:@"1"];
    }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //none
    }];
    
    [action addAction:no];
    [action addAction:yes];
    [self presentViewController:action animated:YES completion:nil];
}

- (void) makeCall:(NSString *) num {
    NSString *dialstring = [[NSString alloc] initWithFormat:@"telprompt://*671%@", num];
    NSURL *url = [NSURL URLWithString:dialstring];
    [[UIApplication sharedApplication] openURL:url];
}
- (void) makeCall:(NSString *) num withAccessCode: (NSString *) code{
    NSString *dialstring = [[NSString alloc] initWithFormat:@"telprompt://*671%@,,%@", num, code];
    NSURL *url = [NSURL URLWithString:dialstring];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)callAnonymousAction:(id)sender {
    EVCFeelingBlueTableViewController *table = [[EVCFeelingBlueTableViewController alloc] initWithNibName:@"EVCFeelingBlueTableViewController" bundle:nil];
    [self.navigationController pushViewController:table animated:YES];
}

@end
