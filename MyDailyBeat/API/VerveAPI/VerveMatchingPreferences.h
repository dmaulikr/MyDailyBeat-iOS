//
//  VerveMatchingPreferences.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/13/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"
#import "Constants.h"
#import "VerveRelationshipPrefs.h"

@interface VerveMatchingPreferences : NSObject <FXForm>

@property (nonatomic) int gender, age, status, ethnicity, beliefs, drinker;
@property (nonatomic) BOOL smoker, veteran;

- (NSMutableDictionary *) toJSON;

@end
