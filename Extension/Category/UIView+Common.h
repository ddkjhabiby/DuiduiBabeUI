//
//  UIView+Common.h
//  MXTTTXM
//
//  Created by Michael on 5/28/15.
//  Copyright (c) 2015 MXTTTXM UPUPUP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Common)

/** View的X坐标 */
@property (nonatomic, assign) CGFloat x;

/** View的Y坐标 */
@property (nonatomic, assign) CGFloat y;

/** View的width */
@property (nonatomic, assign) CGFloat width;

/** View的height */
@property (nonatomic, assign) CGFloat height;

/** View's origin - Sets X and Y Positions */
@property (nonatomic, assign) CGPoint origin;

/** View's size - Sets Width and Height */
@property (nonatomic, assign) CGSize size;

/** view的最底部的Y坐标 **/
@property (nonatomic, assign) CGFloat bottom;

/** view的最右边的X坐标 **/
@property (nonatomic, assign) CGFloat right;

/** view的中点的X坐标 **/
@property (nonatomic, assign) CGFloat centerX;

/** view的中点的Y坐标 **/
@property (nonatomic, assign) CGFloat centerY;

/** 边框颜色*/
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

/** 边框 */
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

//圆角
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

- (void)setHalfCornerRadius;
- (void)setCornerRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners viewSize:(CGSize)size;

- (void)setBorderWidth:(CGFloat)borderWidth color:(UIColor *)color;

@end
