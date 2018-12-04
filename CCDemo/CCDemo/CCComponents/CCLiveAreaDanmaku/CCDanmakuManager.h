//
//  CCDanmakuManager.h
//  Dong
//
//  Created by Dong on 2018/5/11.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCDanmuGiftInfo.h"

@interface CCDanmakuManager : NSObject

/**
 弹幕幕布视图
 */
@property (nonatomic, strong) UIView *danmakuScreenView;

/**
 指定弹幕的父视图
 @param view 父视图
 @return self
 */
- (instancetype)initWithInView:(UIView *)view;

/**
 设置弹幕数据源
 @param type 弹幕类型 0:循环展示 1:只展示一次
 */
- (void)addDanmakuDataSource:(NSMutableArray *)dataSource type:(NSInteger)type;

/**
 发送弹幕
 @param info 弹幕
 @param type 弹幕类型
 @param first 装载在 弹幕头/下一个
 */
- (void)sendDanmaku:(CCDanmuGiftInfo *)info type:(NSInteger)type first:(BOOL)first;

/**
 开始弹幕
 */
- (void)startDanmaku;

/**
 结束弹幕
 */
- (void)stopDanmaku;

@end
