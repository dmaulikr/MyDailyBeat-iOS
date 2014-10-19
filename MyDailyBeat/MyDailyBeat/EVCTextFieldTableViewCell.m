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
    self = [self init];
    if (self) {
        self.placeHolderText = placeHolder;
    }
    return self;
}

- (void)awakeFromNib {
    textField.placeholder = self.placeHolderText;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
