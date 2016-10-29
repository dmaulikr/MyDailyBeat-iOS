//
//  EVCMyHealthViewController.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 5/30/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "EVCMyHealthViewController.h"
#import "EVCCommonMethods.h"

@interface EVCMyHealthViewController ()

@end

@implementation EVCMyHealthViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPrescriptionProvider: (PrescripProviderInfo *) provider andHealthPortal: (HealthInfo *) portal {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.provider = provider;
        self.portal = portal;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSData *data1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"myHealthPortal"];
    HealthInfo * temp1 = [NSKeyedUnarchiver unarchiveObjectWithData:data1];
    if (temp1 != nil) {
        self.portal = temp1;
    }
    NSData *data2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"myPrescripProvider"];
    PrescripProviderInfo * temp2 = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
    if (temp2 != nil) {
        self.provider = temp2;
    }
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setup {
    if (self.provider != nil && self.portal != nil) {
        if (![self.portal.logoURL isEqualToString:@""]) {
            dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
            dispatch_async(queue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view makeToastActivity];
                });
                NSURL *imgurl = [NSURL URLWithString:self.portal.logoURL];
                NSData *data = [[RestAPI getInstance] fetchImageAtRemoteURL:imgurl];
                UIImage *img = [[UIImage alloc] initWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view hideToastActivity];
                    [healthPortalLogoView setImage:[EVCCommonMethods imageWithImage:img scaledToSize:CGSizeMake(304, 128)]];
                });
            });
        } else {
            UIImage *img = [UIImage imageNamed:@"404-logo"];
            [healthPortalLogoView setImage:[EVCCommonMethods imageWithImage:img scaledToSize:CGSizeMake(304, 128)]];
        }
        
        if (![self.provider.logoURL isEqualToString:@""]) {
            dispatch_queue_t queue = dispatch_queue_create("dispatch_queue_t_dialog", NULL);
            dispatch_async(queue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view makeToastActivity];
                });
                NSURL *imgurl = [NSURL URLWithString:self.provider.logoURL];
                NSData *data = [[RestAPI getInstance] fetchImageAtRemoteURL:imgurl];
                UIImage *img = [[UIImage alloc] initWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view hideToastActivity];
                    [prescripProviderLogoView setImage:[EVCCommonMethods imageWithImage:img scaledToSize:CGSizeMake(304, 128)]];
                });
            });
        } else {
            UIImage *img = [UIImage imageNamed:@"404-logo"];
            [prescripProviderLogoView setImage:[EVCCommonMethods imageWithImage:img scaledToSize:CGSizeMake(304, 128)]];
        }
        
        [prescripLabel setText:self.provider.URL];
        [portalLabel setText:self.portal.URL];
    } else {
        [prescripLabel setText:@"Prescription Provider not set"];
        [portalLabel setText:@"Health Portal not set"];
    }
}

- (IBAction)goToProvider:(id)sender {
    if (self.provider != nil) {
        NSString *trueU = [@"http://www." stringByAppendingString:self.provider.URL];
        [self openURLinBrowser:trueU];
    }
}

- (IBAction)goToPortal:(id)sender {
    if (self.portal != nil) {
        [self openURLinBrowser:self.portal.URL];
    }
}

- (void) openURLinBrowser: (NSString *) url {
    NSString *fullURL = [NSString stringWithFormat:@"%@", url];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fullURL]];
    
}

@end
