//
//  Stack.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 6/1/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stack : NSObject {
    int _top;
    NSMutableArray *_stack;
}

@property int top;
@property (nonatomic, retain) NSMutableArray *stack;

- (id) init;
- (void) push: (id) object;
- (id) pop;

@end
