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

@end
