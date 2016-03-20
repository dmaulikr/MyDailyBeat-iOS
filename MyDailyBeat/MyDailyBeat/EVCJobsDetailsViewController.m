//
//  EVCJobsDetailsViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 12/28/15.
//  Copyright © 2015 eVerveCorp. All rights reserved.
//

#import "EVCJobsDetailsViewController.h"

@interface EVCJobsDetailsViewController ()

@end

@implementation EVCJobsDetailsViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andJob:(NSDictionary *) job {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.jobEntry = job;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.jobtitleLabel.text = [self.jobEntry objectForKey:@"jobtitle"];
    self.companyLabel.text = [self.jobEntry objectForKey:@"company"];
    self.locLabel.text = [self.jobEntry objectForKey:@"formattedLocationFull"];
    self.snippetLabel.text = [self.jobEntry objectForKey:@"snippet"];
    self.urlLabel.text = [self.jobEntry objectForKey:@"url"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
