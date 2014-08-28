//
//  RelationshipPrefs.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/25/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"
#import "Constants.h"

@interface RelationshipPrefs : NSObject <FXForm>

@property (nonatomic) SexualPreference sexualPref;
@property (nonatomic) int age;

- (NSMutableArray *) stringArray;
- (int) enumToIndex;
- (SexualPreference) indexToEnum: (int) index;

@end
