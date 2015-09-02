//
//  VervePreferences.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/17/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerveUserPreferences.h"
#import "VerveMatchingPreferences.h"
#import "FXForms.h"

@interface VervePreferences : NSObject <FXForm>

@property (nonatomic) VerveUserPreferences *userPreferences;
@property (nonatomic) VerveMatchingPreferences *matchingPreferences;

@end
