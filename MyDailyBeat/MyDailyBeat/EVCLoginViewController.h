//
//  EVCLoginViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/18/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVCLoginViewController : UIViewController <UITableViewDataSource>{
    IBOutlet UIImageView *header;
    IBOutlet UIButton *loginButton;
    IBOutlet UITableView *fields;
    IBOutlet UIButton *signUp;
}

@end
