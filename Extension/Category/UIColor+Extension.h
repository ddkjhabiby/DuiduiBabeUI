//
//  UIColor+Extension.h
//  Musk
//
//  Created by yangjie on 2020/9/10.
//  Copyright © 2020 Elon. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface UIColor (Extension)

+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor *)colorWithHex:(NSInteger)hexValue;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)whiteColorWithAlpha:(CGFloat)alphaValue;
+ (UIColor *)blackColorWithAlpha:(CGFloat)alphaValue;

@end

NS_ASSUME_NONNULL_END
