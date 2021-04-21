//
//  UIImage+MXAddition.h
//  MXTTTXM
//
//  Created by Michael on 5/28/15.
//  Copyright (c) 2015 MXTTTXM UPUPUP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MXAddition)

/**
 *  使用颜色生成一张图片
 *
 *  @param color 颜色值
 *
 *  @return 生成的图片
 */
+ (UIImage *)imageWithhColor:(UIColor *)color;

/**
 *  使用颜色生成一张指定大小的图片
 *
 *  @param size 大小
 */
+ (UIImage *)imageWithhColor:(UIColor *)color size:(CGSize)size;

/** 
 *  根据UIVIew来截图 
 *  @param view 指定视图
 *
 */
+ (UIImage *)imageWithView:(UIView *)view;


- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

- (UIImage *)scaleToSizee:(CGSize)size;

/** 压缩到指定尺寸，但是所占内存只小一些，6.4M——>4.1M */
- (UIImage *)imageCompressForSize:(CGSize)size;

- (UIImage *)makeRoundCornersWithRadius:(const CGFloat)radius;

- (UIImage *)thumbnailImage:(CGSize)thumbnailSize;

/** 灰度 */
+ (UIImage *)grayImage:(UIImage *)sourceImage;

/**
 *  加水印
 *
 *  @param watermarkImage 水印图片
 *
 *  @return <#return value description#>
 */
- (UIImage *)addWatermarkWithImg:(UIImage *)watermarkImage;
- (UIImage *)addWatermarkWithImg:(UIImage *)watermarkImage isEmoji:(BOOL)isEmoji;

/**
 *  根据尺寸比例，将图片压缩到指定尺寸
 *
 *  @param sourceImage 原图
 *  @param targetWidth 需要缩小到的宽度
 *
 *  @return 缩小后的图片
 */
+ (UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth;

- (UIImage *)renderImageWithTintColor:(UIColor *)color;

#pragma mark - Video

+ (UIImage *)defaultPreviewImageWithVideoUrl:(NSURL *)url;


@end
