//
//  FlingProfile.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 12/31/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlingProfile : NSObject

@property (nonatomic, retain) NSString *screenName, *aboutMe;
@property (nonatomic) int age;
@property (nonatomic, retain) NSMutableArray *interests;

@end
