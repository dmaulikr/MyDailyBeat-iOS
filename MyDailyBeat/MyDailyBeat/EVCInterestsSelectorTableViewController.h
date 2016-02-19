//
//  EVCInterestsSelectorTableViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 2/8/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVCInterestsSelectorTableViewController : UITableViewController

@property (nonatomic, retain) NSMutableArray *interests;
@property (nonatomic, retain) NSDictionary *initialInterests;
@property (nonatomic, retain) NSArray *travel, *volunteer, *ac, *finearts, *clubs, *reading, *exercise, *cooking, *outdoors, *teaching;


@end
