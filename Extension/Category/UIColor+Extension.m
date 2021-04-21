//
//  UIColor+Extension.m
//  Musk
//
//  Created by yangjie on 2020/9/10.
//  Copyright © 2020 Elon. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue {
    NSParameterAssert(hexValue <= 0xFFFFFF && hexValue >= 0x000000);
    return [UIColor colorWithRed:((CGFloat)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((CGFloat)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((CGFloat)(hexValue & 0xFF))/255.0
                           alpha:alphaValue];
}

+ (UIColor *)colorWithHex:(NSInteger)hexValue {
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([hexString hasPrefix:@"0X"] || [hexString hasPrefix:@"0x"]) {
        hexString = [hexString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString substringFromIndex:1];
    }
#if DEBUG
    NSParameterAssert(hexString.length >= 6);
#else
    if (hexString.length < 6) {
        return nil;
    }
#endif
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [hexString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [hexString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [hexString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    return [self colorWithHexString:hexString alpha:1];
}

+ (UIColor *)whiteColorWithAlpha:(CGFloat)alphaValue {
    return [UIColor colorWithHex:0xffffff alpha:alphaValue];
}

+ (UIColor *)blackColorWithAlpha:(CGFloat)alphaValue {
    return [UIColor colorWithHex:0x000000 alpha:alphaValue];
}

@end
