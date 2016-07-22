//
//  VerveUser.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 8/17/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "VerveUser.h"

@implementation VerveUser

@synthesize name, screenName, password, email, birth_month, birth_date, birth_year, mobile, zipcode;

-(NSMutableDictionary *) toJSON {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    [data setObject:[NSString stringWithFormat:@"%@",name] forKey:@"name"];
    [data setObject:[NSString stringWithFormat:@"%@",screenName] forKey:@"screenName"];
    [data setObject:[NSString stringWithFormat:@"%@",password] forKey:@"password"];
    [data setObject:[NSString stringWithFormat:@"%@",email] forKey:@"email"];
    [data setObject:[NSString stringWithFormat:@"%@",mobile] forKey:@"mobile"];
    [data setObject:[NSString stringWithFormat:@"%@",zipcode] forKey:@"zipcode"];
    [data setObject:[NSString stringWithFormat:@"%@",birth_month] forKey:@"birth_month"];
    [data setObject:[NSNumber numberWithLong:birth_date] forKey:@"birth_date"];
    [data setObject:[NSNumber numberWithLong:birth_year] forKey:@"birth_year"];
    
    return data;
}

- (BOOL) hasNilField {
    BOOL hasNil = NO;
    hasNil = (([name isEqualToString:@""]) || (name == nil));
    hasNil = (([screenName isEqualToString:@""]) || (screenName == nil)) && hasNil;
    hasNil = (([password isEqualToString:@""]) || (password == nil)) && hasNil;
    hasNil = (([email isEqualToString:@""]) || (email == nil)) && hasNil;
    hasNil = (([mobile isEqualToString:@""]) || (mobile == nil)) && hasNil;
    hasNil = (([zipcode isEqualToString:@""]) || (zipcode == nil)) && hasNil;
    hasNil = (([birth_month isEqualToString:@""]) || (birth_month == nil)) && hasNil;
    hasNil = ((birth_date == 0)) && hasNil;
    hasNil = ((birth_year == 0)) && hasNil;
    return hasNil;
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
        [copy setBirth_date:self.birth_date];
        [copy setBirth_year:self.birth_year];
    }
    
    return copy;
}

@end
