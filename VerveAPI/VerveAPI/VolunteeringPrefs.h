//
//  VolunteeringPrefs.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 8/24/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

@interface VolunteeringPrefs : NSObject <FXForm>

@property(nonatomic) BOOL spiritual;
@property(nonatomic) BOOL nonprofit;
@property(nonatomic) BOOL community;

- (NSMutableArray *) getBoolArray;

@end
