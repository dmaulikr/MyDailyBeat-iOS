//
//  EVCCommonMethods.m
//  MyDailyBeat
//
//  Created by Virinchi Balabhadrapatruni on 10/19/14.
//  Copyright (c) 2014 eVerveCorp. All rights reserved.
//

#import "EVCCommonMethods.h"

@implementation EVCCommonMethods

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIButton *) barButtonSystemItem:(UIBarButtonSystemItem) item withText:(NSString *) title {
    UIBarButtonItem *tempBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:nil action:nil];
    UIImage *img = tempBarButton.image;
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    
    return btn;

}

+ (UIImage*) imageWithColor:(UIColor*)color size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    UIBezierPath* rPath = [UIBezierPath bezierPathWithRect:CGRectMake(0., 0., size.width, size.height)];
    [color setFill];
    [rPath fill];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (double) metersForRadius: (double) miles {
    return miles * 1609.34;
}
+ (double) milesForRadius: (double) meters {
    return meters/1609.34;
}

@end
