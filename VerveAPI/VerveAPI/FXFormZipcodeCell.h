//
//  FXFormZipcodeCell.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 9/21/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "FXForms.h"

@interface FXFormZipcodeCell : FXFormDefaultCell <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign, getter = isReturnKeyOverriden) BOOL returnKeyOverridden;

@end
