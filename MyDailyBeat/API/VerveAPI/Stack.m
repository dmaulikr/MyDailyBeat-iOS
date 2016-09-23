//
//  Stack.m
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 6/1/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import "Stack.h"

@implementation Stack

@synthesize top = _top;
@synthesize stack = _stack;

- (id) init {
    self = [super init];
    if (self) {
        self.top = 0;
        self.stack = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) push: (id) object {
    [self.stack addObject:object];
    self.top = self.top + 1;
}
- (id) pop {
    id retval = [self.stack objectAtIndex:self.top];
    [self.stack removeObjectAtIndex:self.top];
    self.top = self.top - 1;
    return retval;
}

@end
