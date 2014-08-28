//
//  EVCViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/17/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCViewController.h"

@interface EVCViewController ()

@end

@implementation EVCViewController

@synthesize api;

@synthesize mTableView;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigationItem].title = @"Home";
    UIImage* image3 = [EVCViewController imageWithImage:[UIImage imageNamed:@"1408346500_menu-alt"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(showMenu)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *menuButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.leftBarButtonItem=menuButton;
    
    self.mTableView.dataSource = self;
    self.mTableView.delegate = self;
    api = [API getInstance];
    
    if ([api getCurrentUser] == nil) {
        DLAVAlertView *loginAlert = [[DLAVAlertView alloc] initWithTitle:@"Login to MyDailyBeat" message:@"Please enter your screen name and password." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [loginAlert addTextFieldWithText:@"" placeholder:@"ScreenName"];
        [loginAlert addTextFieldWithText:@"" placeholder:@"Password"];
        [loginAlert setSecureTextEntry:YES ofTextFieldAtIndex:1];
        UITextField *field1 = [loginAlert textFieldAtIndex:0];
        [field1 setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [field1 setAutocorrectionType:UITextAutocorrectionTypeNo];
        
        [loginAlert showWithCompletion:^(DLAVAlertView *alertView, NSInteger buttonIndex) {
            [self loginWithScreenName:[loginAlert textFieldTextAtIndex:0] andPassword:[loginAlert textFieldTextAtIndex:1]];
        }];
    } else {
        [self loginWithScreenName:[api getCurrentUser].screenName andPassword:[api getCurrentUser].password];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Celler";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (void) showMenu {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void) loginWithScreenName:(NSString *) screenName andPassword:(NSString *) password {
    NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.verve.VerveAPIBundle"];
    
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
            BOOL success = [api loginWithScreenName:screenName andPassword:password];
            if (success) {
                NSLog(@"Damn");
                [self.view makeToast:@"Login successful!" duration:3.5 position:@"bottom" image:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"check" ofType:@"png"]]];
            } else {
                [self.view makeToast:@"Login failed!" duration:3.5 position:@"bottom" image:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"error" ofType:@"png"]]];
            }
            [self.view hideToastActivity];
        });
    });
}

@end
