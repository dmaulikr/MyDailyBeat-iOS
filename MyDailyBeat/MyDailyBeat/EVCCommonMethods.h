//
//  EVCCommonMethods.h
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/19/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVCCommonMethods : NSObject

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIButton *) barButtonSystemItem:(UIBarButtonSystemItem) item withText:(NSString *) title;
+ (UIImage*) imageWithColor:(UIColor*)color size:(CGSize)size;

+ (double) metersForRadius: (double) miles;
+ (double) milesForRadius: (double) meters;

@end
