//
//  Queue.h
//  VerveAPI
//
//  Created by Virinchi Balabhadrapatruni on 6/1/16.
//  Copyright © 2016 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Queue : NSObject {
    NSMutableArray *_queue;
}

@property (nonatomic, retain) NSMutableArray *queue;

- (id) init;
- (void) push: (id) object;
- (id) pop;

@end
