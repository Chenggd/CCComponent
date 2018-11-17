//
//  UIButton+CCEnlargeTouchArea.h
//  shehui
//
//  Created by Cheng on 2017/3/28.
//  Copyright © 2017年 happyfirst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CCEnlargeTouchArea)

/**
 增加按钮点击区域方法
 */
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;


@end
