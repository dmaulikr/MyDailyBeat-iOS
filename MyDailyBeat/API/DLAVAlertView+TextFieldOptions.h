//
//  DLAVAlertView_TextFieldOptions.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/21/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "DLAVAlertView.h"

@interface DLAVAlertView (TextFieldOptions)

- (void)setAutoCapitalizationType:(UITextAutocapitalizationType)autoCapitalizationType ofTextFieldAtIndex:(NSInteger)index;
- (void)setAutoCorrectionType:(UITextAutocorrectionType)autoCorrectionType ofTextFieldAtIndex:(NSInteger)index;

@end
