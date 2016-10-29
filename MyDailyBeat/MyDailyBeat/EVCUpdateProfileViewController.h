//
//  EVCUpdateProfileViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/21/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"
#import "EVCAppDelegate.h"
#import "EVCCommonMethods.h"

@interface EVCUpdateProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    NSMutableArray *months, *years;
}


@property (nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic) NSString *name, *email, *mobile, *zipcode, *month;
@property (nonatomic) long year;
@property (nonatomic) UIPickerView *picker;

@property (nonatomic, retain) UIImagePickerController *imgPicker;

@end
