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
#import "AFHTTPRequestOperation.h"
#import <MobileCoreServices/UTType.h>
#import <sys/time.h>

#define BASE_URL @"https://1-dot-mydailybeat-api.appspot.com/_ah/api/mydailybeat/v1"

@interface API : NSObject

/* getInstance */
+(API *)getInstance;
/* Checks for Connectivity */
+(BOOL)hasConnectivity;

-(VerveUser *) getCurrentUser;
- (BOOL) createUser: (VerveUser *) userData;





@end
