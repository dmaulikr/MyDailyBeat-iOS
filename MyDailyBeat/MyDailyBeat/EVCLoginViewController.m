//
//  EVCLoginViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/18/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCLoginViewController.h"
#import "VerveAPI/Constants.h"

@interface EVCLoginViewController ()

@end

@implementation EVCLoginViewController

@synthesize userNameFeild,passWordFeild;

- (void)viewDidLoad {
    [super viewDidLoad];
    fields.dataSource = self;
    fields.delegate = self;
    fields.scrollEnabled = FALSE;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    header.image = [UIImage imageNamed:@"Logo.png"];

    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadLoginData];
}

- (void) loadLoginData {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        NSString *defScreenName = [[NSUserDefaults standardUserDefaults] stringForKey:KEY_SCREENNAME];
        NSString *defPass = [[NSUserDefaults standardUserDefaults] stringForKey:KEY_PASSWORD];
        NSMutableArray *groups = [[NSMutableArray alloc] init];
        if (defScreenName != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToastActivity];
            });
            [[API getInstance] loginWithScreenName:defScreenName andPassword:defPass];
            groups = [[API getInstance] getGroupsForCurrentUser];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                RESideMenu *sideMenuViewController;
                
                EVCProfileViewController *profile = [[EVCProfileViewController alloc] initWithNibName:@"EVCProfileViewController_iPhone" bundle:nil];
                EVCViewController *controller = [[EVCViewController alloc] initWithNibName:@"EVCViewController_iPhone" bundle:nil];
                UINavigationController *root = [[UINavigationController alloc] initWithRootViewController:controller];
                EVCMenuViewController *menu = [[EVCMenuViewController alloc] initWithGroups:groups andParent:root];
                
                sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:root
                                                                    leftMenuViewController:[[UINavigationController alloc] initWithRootViewController:profile]
                                                                   rightMenuViewController:menu];
                sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
                sideMenuViewController.delegate = (EVCAppDelegate *)[[UIApplication sharedApplication] delegate];
                UIColor *bgcolor = UIColorFromHex(0x0097A4);
                CGSize bgsize = CGSizeMake(640, 1136);
                sideMenuViewController.backgroundImage = [EVCCommonMethods imageWithColor:bgcolor size:bgsize];
                sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
                sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
                sideMenuViewController.contentViewShadowOpacity = 0.6;
                sideMenuViewController.contentViewShadowRadius = 12;
                sideMenuViewController.contentViewShadowEnabled = YES;
                self.view.window.rootViewController = sideMenuViewController;
                [self.view hideToastActivity];
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        }
        
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    
    tableView.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"User Name";
            userNameFeild = [[UITextField alloc] initWithFrame:CGRectMake(115,12, 180, 31)];
            userNameFeild.textAlignment = UITextAlignmentCenter;
            userNameFeild.textColor = [UIColor blackColor];
            userNameFeild.clearButtonMode  = UITextFieldViewModeAlways;
            userNameFeild.font = [UIFont fontWithName:@"Helvetica" size:14.0];
            userNameFeild.autocapitalizationType = UITextAutocapitalizationTypeNone;
            userNameFeild.autocorrectionType = UITextAutocorrectionTypeNo;
            [cell.contentView addSubview:userNameFeild];
            break;
        case 1:
            cell.textLabel.text = @"Password";
            passWordFeild = [[UITextField alloc] initWithFrame:CGRectMake(115,12, 180, 31)];
            passWordFeild.textAlignment = UITextAlignmentCenter;
            self.passWordFeild.textColor = [UIColor blackColor];
            passWordFeild.clearButtonMode = UITextFieldViewModeAlways;
            passWordFeild.secureTextEntry = YES;
            passWordFeild.font = [UIFont fontWithName:@"Helvetica" size:14.0];
            passWordFeild.autocapitalizationType = UITextAutocapitalizationTypeNone;
            passWordFeild.autocorrectionType = UITextAutocorrectionTypeNo;
            [cell.contentView addSubview:passWordFeild];
            
            break;
        default:
            break;
    }
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (int) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (IBAction)login:(id)sender {
    NSString *username = userNameFeild.text;
    NSString *pass = passWordFeild.text;
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        NSMutableArray *groups = [[NSMutableArray alloc] init];
        BOOL success = [[API getInstance] loginWithScreenName:username andPassword:pass];
        if (success) {
            groups = [[API getInstance] getGroupsForCurrentUser];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSUserDefaults standardUserDefaults] setObject:username forKey:KEY_SCREENNAME];
                [[NSUserDefaults standardUserDefaults] setObject:pass forKey:KEY_PASSWORD];
                RESideMenu *sideMenuViewController;
                EVCProfileViewController *profile = [[EVCProfileViewController alloc] initWithNibName:@"EVCProfileViewController_iPhone" bundle:nil];
                EVCViewController *controller = [[EVCViewController alloc] initWithNibName:@"EVCViewController_iPhone" bundle:nil];
                UINavigationController *root = [[UINavigationController alloc] initWithRootViewController:controller];
                EVCMenuViewController *menu = [[EVCMenuViewController alloc] initWithGroups:groups andParent:root];
                
                sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:root
                                                                    leftMenuViewController:[[UINavigationController alloc] initWithRootViewController:profile]
                                                                   rightMenuViewController:menu];
                sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
                sideMenuViewController.delegate = (EVCAppDelegate *)[[UIApplication sharedApplication] delegate];
                UIColor *bgcolor = UIColorFromHex(0xFCF58B);
                CGSize bgsize = CGSizeMake(640, 1136);
                sideMenuViewController.backgroundImage = [EVCCommonMethods imageWithColor:bgcolor size:bgsize];
                sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
                sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
                sideMenuViewController.contentViewShadowOpacity = 0.6;
                sideMenuViewController.contentViewShadowRadius = 12;
                sideMenuViewController.contentViewShadowEnabled = YES;
                self.view.window.rootViewController = sideMenuViewController;
                [self.view hideToastActivity];
                [self.navigationController popViewControllerAnimated:YES];
                
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view hideToastActivity];
                [self.view makeToast:@"Username and password do not match." duration:3.5 position:@"bottom" image:[UIImage imageNamed:@"VerveAPIBundle.bundle/error.png"]];
            });
        }
        
    });
    
    
}

- (IBAction)signup:(id)sender {
    EVCRegistrationViewController *controller = [[EVCRegistrationViewController alloc] initWithNibName:@"EVCRegistrationViewController_iPhone" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
