//
//  EVCResourceLinksTableViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/30/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface EVCResourceLinksTableViewController : UITableViewController {
    NSString *path, *module;
    NSDictionary *resLinks;
}

@property (nonatomic, retain) NSArray *dataArr;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andModuleName: (NSString *) m;

@end
