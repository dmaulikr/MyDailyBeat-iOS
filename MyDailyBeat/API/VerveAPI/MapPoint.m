//
//  MapPoint.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 10/2/15.
//  Copyright © 2015 eVerveCorp. All rights reserved.
//

#import "MapPoint.h"

@implementation MapPoint
@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;

-(id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate  {
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
        
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    MapPoint *copy = [[MapPoint alloc] initWithName:self.name address:self.address coordinate:self.coordinate];
    return copy;
}

-(NSString *)title {
    if ([_name isKindOfClass:[NSNull class]])
        return @"Unknown charge";
    else
        return _name;
}

-(NSString *)subtitle {
    return _address;
}

@end
