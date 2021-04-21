//
//  UIImage+GradientColor.h
//  LoLa
//
//  Created by ddkj007 on 2019/5/13.
//  Copyright © 2019 ddkj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DDGradientType) {
    DDGradientTypeTopToBottom = 0,//从上到下
    DDGradientTypeLeftToRight = 1,//从左到右
    DDGradientTypeUpleftToLowright = 2,//左上到右下
    DDGradientTypeUprightToLowleft = 3,//右上到左下
};

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (GradientColor)

+ (UIImage *)gradientColorImageFromColors:(NSArray *)colors gradientType:(DDGradientType)gradientType imgSize:(CGSize)imgSize alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
