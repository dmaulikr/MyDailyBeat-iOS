//
//  API.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/17/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Reachability.h"
#import "VerveUser.h"

@interface API : NSObject

/* getInstance */
+(API *)getInstance;
/* Checks for Connectivity */
+(BOOL)hasConnectivity;

-(VerveUser *) getCurrentUser;





@end
