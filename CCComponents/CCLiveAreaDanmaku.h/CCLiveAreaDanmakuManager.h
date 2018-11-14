//
//  CCLiveAreaDanmakuManager.h
//  BeautyBeeTravel
//
//  Created by Dong on 2018/9/6.
//  Copyright © 2018年 美蜂. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCDanmuGiftInfo.h"

@protocol CCLiveAreaDanmakuDelegate <NSObject>

@optional
- (void)tapLiveAreaDanmakuAction:(CCDanmuGiftInfo *)info;

@end

/**
 直播间全区弹幕管理类（兼容房间弹幕与全区弹幕）
 */
@interface CCLiveAreaDanmakuManager : NSObject

/** 幕布 */
@property (nonatomic, strong) UIView *danmakuScreenView;
@property (nonatomic, weak) id<CCLiveAreaDanmakuDelegate> areaDanmakuDelegate;
/**
 指定弹幕的父视图
 @param view 父视图
 @return self
 */
- (instancetype)initWithInView:(UIView *)view;

/**
 添加直播间弹幕特效
 @param info 弹幕数据
 */
- (void)addLiveAreaDanmaku:(CCDanmuGiftInfo *)info;

//停止所有特效
- (void)stopLiveAreaDanmaku;

@end
