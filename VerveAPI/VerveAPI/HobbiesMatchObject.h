//
//  HobbiesMatchObject.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 6/14/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HobbiesPreferences.h"
#import "VerveUser.h"

@interface HobbiesMatchObject : NSObject

@property (nonatomic, retain) HobbiesPreferences *prefs;
@property (nonatomic, retain) VerveUser *userObj;

@end
