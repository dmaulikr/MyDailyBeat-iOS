//
//  EVCUpdateProfileViewController.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 9/21/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DLAVAlertView.h>
#import <RestAPI.h>
#import <UIView+Toast.h>
#import "RESideMenu.h"
#import "EVCAppDelegate.h"

@interface EVCUpdateProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    NSMutableArray *months, *years;
}


@property (nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic) NSString *name, *email, *mobile, *zipcode, *month;
@property (nonatomic) long year;
@property (nonatomic) UIPickerView *picker;

@property (nonatomic, retain) UIImagePickerController *imgPicker;

@end
