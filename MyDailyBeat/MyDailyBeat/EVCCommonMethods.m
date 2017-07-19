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

+ (UIImage *)fixOrientationForImage: (UIImage *) inputImage {
    
    // No-op if the orientation is already correct
    if (inputImage.imageOrientation == UIImageOrientationUp) return inputImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (inputImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, inputImage.size.width, inputImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, inputImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, inputImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (inputImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, inputImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, inputImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, inputImage.size.width, inputImage.size.height,
                                             CGImageGetBitsPerComponent(inputImage.CGImage), 0,
                                             CGImageGetColorSpace(inputImage.CGImage),
                                             CGImageGetBitmapInfo(inputImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (inputImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,inputImage.size.height,inputImage.size.width), inputImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,inputImage.size.width,inputImage.size.height), inputImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
