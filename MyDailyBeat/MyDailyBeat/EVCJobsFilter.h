//
//  EVCJobsFilter.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/1/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"

typedef enum {
    ALL = 0,
    FULL_TIME = 1,
    PART_TIME = 2
} JobType;

typedef enum {
    TWENTY_FIVE_MILES = 0,
    FIFTY_MILES = 1,
    SEVENTY_FIVE_MILES = 2,
    ONE_HUNDRED_MILES = 3
} JobSearchRadius;

@protocol EVCJobsFilterDelegate <NSObject>

- (void) updateJobType: (JobType) type andRadius: (JobSearchRadius) radius;

@end

@interface EVCJobsFilter : UIView {
    IBOutlet UISegmentedControl *jobType, *searchRadius;
    IBOutlet UIButton *filterButton;
}

@property (nonatomic) id <EVCJobsFilterDelegate> delegate;
@property (nonatomic, retain) NSString *currentQuery;
@property JobType jType;
@property JobSearchRadius sRadius;

- (IBAction)filter:(id)sender;

- (IBAction)jobTypeChanged:(id)sender;
- (IBAction)searchRadiusChanged:(id)sender;

@end
