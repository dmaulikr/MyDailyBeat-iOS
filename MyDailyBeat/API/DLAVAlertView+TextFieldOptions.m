//
//  DLAVAlertView+TextFieldOptions.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/21/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLAVAlertView+TextFieldOptions.h"

@implementation DLAVAlertView (TextFieldOptions)

- (void)setAutoCapitalizationType:(UITextAutocapitalizationType)autoCapitalizationType ofTextFieldAtIndex:(NSInteger)index {
    [self textFieldAtIndex:index].autocapitalizationType = autoCapitalizationType;
}
- (void)setAutoCorrectionType:(UITextAutocorrectionType)autoCorrectionType ofTextFieldAtIndex:(NSInteger)index {
    [self textFieldAtIndex:index].autocorrectionType = autoCorrectionType;
}

@end
