//
//  CCLiveEnterManager.h
//  CCCustomComponent
//
//  Created by Dong on 2018/8/8.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCLiveEnterView.h"
#import "CCLiveAudienceInfo.h"

/**
 直播间进房特效管理类(兼容多个弹道～)
 */
@interface CCLiveEnterManager : NSObject

@property (nonatomic, strong) CCLiveEnterView *liveEnterView;
/**
 进房特效幕布视图
 */
@property (nonatomic, strong) UIView *enterScreenView;
/**
 座驾幕布视图
 */
@property (nonatomic, strong) UIView *animaScreenView;
/**
 指定进房特效的父视图
 @param view 父视图
 @return self
 */
- (instancetype)initWithInView:(UIView *)view;
/**
 添加进房特效
 @param enterTaskInfo 进房用户
 */
- (void)addEnterLiveTask:(CCLiveAudienceInfo *)enterTaskInfo;
/**
 停止所有进房特效
 */
- (void)closedAllEnterTask;

@end
