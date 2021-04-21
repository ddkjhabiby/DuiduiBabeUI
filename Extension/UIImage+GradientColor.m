//
//  UIImage+GradientColor.m
//  LoLa
//
//  Created by ddkj007 on 2019/5/13.
//  Copyright © 2019 ddkj. All rights reserved.
//

#import "UIImage+GradientColor.h"

@implementation UIImage (GradientColor)

+ (UIImage *)gradientColorImageFromColors:(NSArray *)colors gradientType:(DDGradientType)gradientType imgSize:(CGSize)imgSize alpha:(CGFloat)alpha {
    NSMutableArray *array = [NSMutableArray array];
    [colors enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:(id)((UIColor *)obj).CGColor];
    }];
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, imgSize.width, imgSize.height));
    if (alpha < 1 && alpha > 0) {
        CGContextSetAlpha(context, alpha);
    }
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors firstObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)array, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case DDGradientTypeTopToBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        case DDGradientTypeLeftToRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, 0.0);
            break;
        case DDGradientTypeUpleftToLowright:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, imgSize.height);
            break;
        case DDGradientTypeUprightToLowleft:
            start = CGPointMake(imgSize.width, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    return image;
}

@end
