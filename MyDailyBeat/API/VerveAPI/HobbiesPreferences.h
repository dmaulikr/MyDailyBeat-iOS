//
//  HobbiesPreferences.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 6/14/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXForms.h"

@interface HobbiesPreferences : NSObject <FXForm>

@property (nonatomic) BOOL books, golf, cars, walking, hiking, wine, woodworking, cardsonline, cards, gamesonline, arts, prayer, support, shopping, travel, localfieldtrips, history, sports;

+ (HobbiesPreferences *) fromJSON: (NSMutableArray *) array;
+ (NSMutableArray *) toJSON: (HobbiesPreferences *) prefs;

@end
