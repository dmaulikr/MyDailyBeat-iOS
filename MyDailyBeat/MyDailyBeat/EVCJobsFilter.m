//
//  EVCJobsFilter.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/1/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "EVCJobsFilter.h"

@implementation EVCJobsFilter

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"EVCJobsFilter" owner:self options:nil] objectAtIndex:0];
        // now add the view to ourselves...
        [xibView setFrame:[self bounds]];
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 5);
        self.layer.shadowOpacity = 0.5f;
        self.layer.shadowPath = shadowPath.CGPath;
        self.jType = [[NSUserDefaults standardUserDefaults] integerForKey:@"JobTypeFilter"];
        self.sRadius = [[NSUserDefaults standardUserDefaults] integerForKey:@"JobSearchRadiusFilter"];
        [jobType setSelectedSegmentIndex:self.jType];
        [searchRadius setSelectedSegmentIndex:self.sRadius];
        [self addSubview:xibView];

    }
    return self;
}

- (IBAction)jobTypeChanged:(id)sender {
    switch (jobType.selectedSegmentIndex) {
        case 0:
            self.jType = ALL;
            break;
        case 1:
            self.jType = FULL_TIME;
            break;
        case 2:
            self.jType = PART_TIME;
            break;
            
        default:
            break;
    }
}
- (IBAction)searchRadiusChanged:(id)sender {
    switch (searchRadius.selectedSegmentIndex) {
        case 0:
            self.sRadius = TWENTY_FIVE_MILES;
            break;
        case 1:
            self.sRadius = FIFTY_MILES;
            break;
        case 2:
            self.sRadius = SEVENTY_FIVE_MILES;
            break;
        case 3:
            self.sRadius = ONE_HUNDRED_MILES;
            break;
            
        default:
            break;
    }
}

- (IBAction)filter:(id)sender {
    [self.delegate updateJobType:self.jType andRadius:self.sRadius];
}



@end
