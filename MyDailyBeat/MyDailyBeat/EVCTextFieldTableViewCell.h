//
//  EVCTextFieldTableViewCell.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/18/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVCTextFieldTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) NSString *placeHolderText;

- (id) initWithPlaceHolder:(NSString *) placeHolder;

@end
