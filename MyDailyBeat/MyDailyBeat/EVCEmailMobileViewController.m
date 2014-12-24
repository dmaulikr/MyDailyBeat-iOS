//
//  EVCEmailMobileViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/20/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCEmailMobileViewController.h"

@interface EVCEmailMobileViewController ()

@end

@implementation EVCEmailMobileViewController

@synthesize emailField, mobileField, goButton, parentController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andParent:(EVCRegistrationViewController *) parent
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        parentController = parent;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)go:(id)sender {
    NSMutableArray *controllerArray = [parentController viewControllers];
    EVCPersonalInfo1ViewController *personalInfo = [controllerArray objectAtIndex:PERSONAL_INFO_INDEX];
    NSString *name = @" ";
        /*NSString *name = [[[personalInfo firstNameField] text] stringByAppendingString:[@" " stringByAppendingString:[[personalInfo lastNameField] text]]];
    
    if (name == nil) {
        name = @"Test Name";
    }*/
    NSString *birth_month = [personalInfo birth_month];
    long birth_year = [personalInfo birth_year];
    NSString *zipcode = [personalInfo zipCodeField].text;
    NSLog(@"First Name=%@", [[personalInfo firstNameField] text]);
    NSLog(@"Last Name=%@", [[personalInfo lastNameField] text]);
    NSLog(@"Birth Month=%@", [personalInfo birth_month]);
    NSLog(@"Birth Year=%d", [personalInfo birth_year]);
    NSLog(@"zipcode=%@", [[personalInfo zipCodeField] text]);
    

    
    EVCScreenNameViewController *screenNameController = [controllerArray objectAtIndex:SCREEN_NAME_INDEX];
    NSString *screenName = [screenNameController screenNameField].text;
    NSString *pass = @"";
    if ([screenNameController.passField.text isEqualToString:screenNameController.verifyPassField.text]) {
        pass = screenNameController.passField.text;
        
        dispatch_queue_t queue = dispatch_queue_create(APP_ID_C_STRING, NULL);
        dispatch_async(queue, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToastActivity];
            });
            
            VerveUser *user = [[VerveUser alloc] init];
            user.name = name;
            user.screenName = screenName;
            user.password = pass;
            user.birth_month = birth_month;
            user.birth_year = birth_year;
            user.zipcode = zipcode;
            user.email = [emailField text];
            user.mobile = [mobileField text];
            BOOL result = [[API getInstance] createUser:user];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view hideToastActivity];
                if (result)
                    [self.view makeToast:@"User creation successful!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"VerveAPIBundle.bundle/check.png"]];
                else {
                    [self.view makeToast:@"User creation failed!" duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"VerveAPIBundle.bundle/error.png"]];
                    return;
                }
                
                [self.parentController.navigationController popToRootViewControllerAnimated:YES];
                
            });
        });
    } else {
        //        [parentController viewPager].fromIndex = [parentController viewPager].toIndex;
        //        [parentController viewPager].toIndex--;
        //        [[parentController viewPager] moveToTargetIndex];
        NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.verve.VerveAPIBundle"];
        [self.view makeToast:@"Passwords don't match. Please try again." duration:3.5 position:@"bottom" image:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"error" ofType:@"png"]]];
        return;
    }
    
}

@end
