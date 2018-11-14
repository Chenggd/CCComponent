//
//  UIImage+CCImage.h
//  CCComponent
//
//  Created by Cheng on 2017/3/7.
//  Copyright © 2017年 Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CCImage)

/*!
 *  图片由颜色填充
 *
 *  @param color 颜色
 *
 *  @return uiimage
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color frame:(CGRect)frame;
/**
 *  给Image着色
 *
 *  @param tintColor 目标颜色
 *
 *  @return UIImage
 */
-(UIImage *)imageWithTintColor:(UIColor *)tintColor;
/**
 *  给image按照灰度着色
 *
 *  @param tintColor 目标颜色
 *
 *  @return UIImage
 */
-(UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;
/**
 *  按照指定的blendMode 给image着色
 *
 *  @param tintColor 目标颜色
 *  @param blendMode 着色模式
 *
 *  @return UIImage
 */
-(UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

/**
 按照图片透明度着色
 
 @param alpha 透明度
 @return UIImage
 */
-(UIImage *)imageWithApplyingAlpha:(CGFloat)alpha;


/**
 返回模糊图片

 @param image 原始图片
 @param blur 模糊度
 @return UIImage
 */
+ (UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

@end
