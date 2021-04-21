//
//  UIScreen+Extension.m
//  Musk
//
//  Created by yangjie on 2020/9/11.
//  Copyright © 2020 Elon. All rights reserved.
//

#import "UIScreen+Extension.h"
#import <UIKit/UIKit.h>

@implementation UIScreen (Extension)

+ (BOOL)iPhoneX {
    return (MAX(self.height, self.width)/MIN(self.height, self.width) > 1.78 ? YES : NO);//iPhoneX,XR,XS,XSmax
}

+ (BOOL)iPad {
    return [[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone;
}

+ (CGRect)bounds {
    return [UIScreen mainScreen].bounds;
}

+ (CGSize)size {
    return self.bounds.size;
}

+ (CGFloat)width {
    return self.size.width;
}

+ (CGFloat)height {
    return self.size.height;
}


// 和顶部状态栏的偏移
+ (CGFloat)statusBarOffset {
    return (self.iPhoneX ? 24.0 : 0.0);
}

// 状态栏高度
+ (CGFloat)statusBarHeight {
    return ([UIApplication sharedApplication].statusBarFrame.size.height ? : (20 + self.statusBarOffset));
}

// 默认导航栏高度（iOS11 新样式暂没用到）
+ (CGFloat)navigationBarHeight {
    return 44;
}

// 顶部高度 = 状态栏+导航栏
+ (CGFloat)topBarHeight {
    return self.statusBarHeight + self.navigationBarHeight;
}

// 底部栏安全区域高度 iPhoneX 34.0,其他0
+ (CGFloat)bottomBarHeight {
    return (self.iPhoneX ? 34.0 : 0.0);
}

// 底部tabbar高度
+ (CGFloat)tabBarHeight {
    return (self.bottomBarHeight + 49.f);
}

@end
