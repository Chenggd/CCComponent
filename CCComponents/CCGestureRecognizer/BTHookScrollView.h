//
//  CCHookScrollView.h
//  BeautyBeeTravel
//
//  Created by Chenggd on 2018/10/9.
//  Copyright © 2018 美蜂. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCHookScrollView : UIScrollView

#pragma mark - hook
/**
 开启手势事件传递拦截,配合hookAreaTop使用,用于处理多级嵌套手势
 */
@property (nonatomic, assign) BOOL openTouchHook;
/**
 拦截区域
 */
@property (nonatomic, assign) CGFloat hookAreaTop;

@end

NS_ASSUME_NONNULL_END
