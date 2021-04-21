//
//  UIScreen+Extension.h
//  Musk
//
//  Created by yangjie on 2020/9/11.
//  Copyright © 2020 Elon. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScreen (Extension)

+ (BOOL)iPhoneX;
+ (BOOL)iPad;

+ (CGRect)bounds;
+ (CGSize)size;
+ (CGFloat)width;
+ (CGFloat)height;

// 和顶部状态栏的偏移
+ (CGFloat)statusBarOffset;
// 状态栏高度
+ (CGFloat)statusBarHeight;
// 默认导航栏高度（iOS11 新样式暂没用到）
+ (CGFloat)navigationBarHeight;
// 顶部高度 = 状态栏+导航栏
+ (CGFloat)topBarHeight;
// 底部栏安全区域高度 iPhoneX 34.0,其他0
+ (CGFloat)bottomBarHeight;
// 底部tabbar高度
+ (CGFloat)tabBarHeight;

@end

NS_ASSUME_NONNULL_END
