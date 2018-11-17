//
//  CCGiftAnimManager.h
//  CCCustomComponent
//
//  Created by Chenggd on 2018/7/4.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLiveGiftMsgInfo.h"

/**
 礼物特效管理类
 */
@interface CCGiftAnimManager : NSObject
/**
 礼物特效幕布视图
 */
@property (nonatomic, strong) UIView *giftAnimScreenView;

/**
 指定弹幕的父视图
 @param view 父视图
 @return self
 */
- (instancetype)initWithInView:(UIView *)view;

/**
 添加礼物特效
 @param info 礼物数据
 */
- (void)addGiftAnimation:(CCLiveGiftMsgInfo *)info;

//停止所有礼物特效
- (void)stopAllGiftAnimations;

@end
