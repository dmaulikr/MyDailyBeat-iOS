//
//  VerveUserPreferences.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/13/15.
//  Copyright (c) 2015 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"
#import "Constants.h"

@interface VerveUserPreferences : NSObject <FXForm>

@property (nonatomic) int gender, age, status, ethnicity, beliefs, contact, drinker;
@property (nonatomic) BOOL smoker, veteran, feelingBlue;
@property (nonatomic) NSString *otherEthnicity, *otherBeliefs;

- (NSMutableDictionary *) toJSON;


@end
