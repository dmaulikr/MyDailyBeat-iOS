//
//  VerveVolunteering.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 10/26/15.
//  Copyright © 2015 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapPoint.h"

@interface VerveVolunteering : NSObject

@property (nonatomic, retain) NSString *zipcode;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *npName;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) MapPoint *pnt;

@end
