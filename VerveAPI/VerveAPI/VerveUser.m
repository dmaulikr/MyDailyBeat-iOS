//
//  VerveUser.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/17/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "VerveUser.h"

@implementation VerveUser

@synthesize name, screenName, password, email, birth_month, birth_year, mobile, zipcode;

-(NSMutableDictionary *) toJSON {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    [data setObject:[NSString stringWithFormat:@"%@",name] forKey:@"name"];
    [data setObject:[NSString stringWithFormat:@"%@",screenName] forKey:@"screenName"];
    [data setObject:[NSString stringWithFormat:@"%@",password] forKey:@"password"];
    [data setObject:[NSString stringWithFormat:@"%@",email] forKey:@"email"];
    [data setObject:[NSString stringWithFormat:@"%@",mobile] forKey:@"mobile"];
    [data setObject:[NSString stringWithFormat:@"%@",zipcode] forKey:@"zipcode"];
    [data setObject:[NSString stringWithFormat:@"%@",birth_month] forKey:@"birth_month"];
    [data setObject:[NSNumber numberWithLong:birth_year] forKey:@"birth_year"];
    
    return data;
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy) {
        [copy setName:[self.name copyWithZone:zone]];
        [copy setEmail:[self.email copyWithZone:zone]];
        [copy setScreenName:[self.screenName copyWithZone:zone]];
        [copy setPassword:[self.password copyWithZone:zone]];
        [copy setMobile:[self.mobile copyWithZone:zone]];
        [copy setZipcode:[self.zipcode copyWithZone:zone]];
        [copy setBirth_month:[self.birth_month copyWithZone:zone]];
        [copy setBirth_year:self.birth_year];
    }
    
    return copy;
}

@end
