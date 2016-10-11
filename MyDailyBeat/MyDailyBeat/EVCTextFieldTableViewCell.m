//
//  EVCTextFieldTableViewCell.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/18/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCTextFieldTableViewCell.h"

@implementation EVCTextFieldTableViewCell
@synthesize textField;

- (id) initWithPlaceHolder:(NSString *)placeHolder {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EVCTextFieldTableViewCell_iPhone" owner:self options:nil];
    self = [nib objectAtIndex:0];
    if (self) {
        self.placeHolderText = placeHolder;
        textField.placeholder = self.placeHolderText;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
