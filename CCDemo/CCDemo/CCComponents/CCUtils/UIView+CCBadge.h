//
//  UIView+CCBadge.h
//  BeautyBeePro
//
//  Created by Chenggd on 2018/2/2.
//  Copyright © 2018年 Chenggd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CCBadge)

/**
 显示小红点
 */
- (void)showBadge;

/**
 自定义位置

 @param orginX X
 @param orginY Y
 */
- (void)showBadgeOrginX:(float)orginX orginY:(float)orginY;

/**
 自定义位置
 
 @param redCount 红点数
 @param orginX orginX
 @param orginY orginY
 */
- (void)showBadgeWithCount:(NSInteger)redCount orginX:(CGFloat)orginX orginY:(CGFloat)orginY;

/**
 显示小红点个数

 @param redCount 个数
 */
- (void)showBadgeWithCount:(NSInteger)redCount;

/**
 隐藏小红点
 */
- (void)hidenBadge;

@end
