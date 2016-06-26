//
//  Queue.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 6/1/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "Queue.h"

@implementation Queue

@synthesize queue = _queue;

- (id) init {
    self = [super init];
    if (self) {
        self.queue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) push: (id) object {
    [self.queue addObject:object];
}
- (id) pop {
    id retval = [self.queue objectAtIndex:0];
    [self.queue removeObjectAtIndex:0];
    return retval;
}
@end
