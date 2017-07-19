//
//  EVCJobsDetailsViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/28/15.
//  Copyright © 2015 eVerveCorp. All rights reserved.
//

#import "EVCVolunteeringDetailsViewController.h"
#import "EVCCommonMethods.h"

@interface EVCVolunteeringDetailsViewController ()

@end

@implementation EVCVolunteeringDetailsViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andOpportunity:(NSDictionary *) opportunity {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.opportunity = opportunity;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage* image3 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"hamburger-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(showMenu)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *menuButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    self.tabBarController.navigationItem.rightBarButtonItem = menuButton;
    
    UIImage* image4 = [EVCCommonMethods imageWithImage:[UIImage imageNamed:@"profile-icon-white"] scaledToSize:CGSizeMake(30, 30)];
    CGRect frameimg2 = CGRectMake(0, 0, image4.size.width, image4.size.height);
    UIButton *someButton2 = [[UIButton alloc] initWithFrame:frameimg2];
    [someButton2 setBackgroundImage:image4 forState:UIControlStateNormal];
    [someButton2 addTarget:self action:@selector(showProfile)
          forControlEvents:UIControlEventTouchUpInside];
    [someButton2 setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *profileButton =[[UIBarButtonItem alloc] initWithCustomView:someButton2];
    self.tabBarController.navigationItem.leftBarButtonItem = profileButton;
    
    self.titleLbl.text = [self.opportunity objectForKey:@"title"];
    self.locLabel.text = [self buildLocationString:[self.opportunity objectForKey:@"location"]];
    NSDictionary *parentOrg = [self.opportunity objectForKey:@"parentOrg"];
    self.parentOrgLabel.text = [parentOrg objectForKey:@"name"];
    NSDictionary *availability = [self.opportunity objectForKey:@"availability"];
    NSString *startDate = [availability objectForKey:@"startDate"];
    if (startDate == nil) {
        // flexible
        self.startLabel.text = @"Flexible";
        self.endLabel.hidden = YES;
    } else {
        NSArray *av = [self getAvailability:availability];
        self.startLabel.text = [av objectAtIndex:0];
        self.endLabel.text = [av objectAtIndex:1];
    }
    
    self.urlTextView.text = [self.opportunity objectForKey:@"vmUrl"];
    self.descripTextView.text = [self.opportunity objectForKey:@"plaintextDescription"];
    NSString *imageURL = [self.opportunity objectForKey:@"imageUrl"];
    if (imageURL != nil) {
        [self fetchImage:imageURL];
    }

    // Do any additional setup after loading the view from its nib.
}

- (void) fetchImage: (NSString *) url {
    dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToastActivity];
        });
        NSURL *imgurl = [NSURL URLWithString:url];
        NSData *data = [[RestAPI getInstance] fetchImageAtRemoteURL:imgurl];
        UIImage *img = [[UIImage alloc] initWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
            [self.imageView setImage:[EVCCommonMethods imageWithImage:img scaledToSize:CGSizeMake(128, 128)]];
        });
    });
}

- (NSArray *) getAvailability:(NSDictionary *) availability {
    NSString *startDate = [availability objectForKey:@"startDate"];
    NSString *startTime = [availability objectForKey:@"startTime"];
    NSString *endDate = [availability objectForKey:@"endDate"];
    NSString *endTime = [availability objectForKey:@"endTime"];
    NSString *start = [NSString stringWithFormat:@"%@ %@", startDate, startTime];
    NSString *end = [NSString stringWithFormat:@"%@ %@", endDate, endTime];
    NSArray *arr = [[NSArray alloc] initWithObjects:start, end, nil];
    return arr;
}

- (NSString *) buildLocationString:(NSDictionary *) locationDic {
    NSString *city = [locationDic objectForKey:@"city"];
    NSString *region = [locationDic objectForKey:@"region"];
    NSString *zip = [locationDic objectForKey:@"postalCode"];
    NSString *country = [locationDic objectForKey:@"country"];
    return [NSString stringWithFormat:@"%@, %@ %@ %@", city, region, zip, country];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showMenu {
    [self.sideMenuViewController presentRightMenuViewController];
}

- (void) showProfile {
    [self.sideMenuViewController presentLeftMenuViewController];
}




@end
