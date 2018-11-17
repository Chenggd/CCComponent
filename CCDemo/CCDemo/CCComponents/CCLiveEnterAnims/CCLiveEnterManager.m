//
//  CCLiveEnterManager.m
//  CCCustomComponent
//
//  Created by Dong on 2018/8/8.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import "CCLiveEnterManager.h"

@interface CCLiveEnterManager ()

@property (nonatomic, strong) NSMutableArray *waitEnterTasks;
@property (nonatomic, strong) NSMutableArray *enterViews;
/** 标示进房装载器已经开始运行 */
@property (nonatomic, assign) BOOL enterStart;

@end

@implementation CCLiveEnterManager

- (instancetype)initWithInView:(UIView *)view {
    if (self = [super init]) {
        _waitEnterTasks = [NSMutableArray arrayWithCapacity:0];
        _enterViews = [NSMutableArray arrayWithCapacity:0];
        _enterStart = YES;
        //装载幕布
        [view addSubview:self.enterScreenView];
        [view addSubview:self.animaScreenView];
        //装载弹道
        CCLiveEnterView *enterView = [[CCLiveEnterView alloc] initWithFrame:CGRectMake(-100, 0, 100, 30)];
        enterView.screenView = _enterScreenView;
        enterView.animaScreenView = _animaScreenView;
        [enterView setLiveEnterStatusBlock:^(CCLiveEnterStatus status) {
            if (status == CCLiveEnterIdle) {
                [self showNextLEView];
            }
        }];
        [_enterScreenView addSubview:enterView];
        [_enterViews addObject:enterView];
    }
    return self;
}

- (UIView *)enterScreenView {
    if (!_enterScreenView) {
        _enterScreenView = [UIView createF:(CGRect){0,0,kScreenWidth,30} BC:[UIColor clearColor]];
        _enterScreenView.clipsToBounds = YES;
    }
    return _enterScreenView;
}

- (UIView *)animaScreenView {
    if (!_animaScreenView) {
        _animaScreenView = [UIView createF:(CGRect){0,0,kScreenWidth,kScreenHeight} BC:[UIColor clearColor]];
        _animaScreenView.clipsToBounds = YES;
        _animaScreenView.userInteractionEnabled = NO;
    }
    return _animaScreenView;
}

- (void)addEnterLiveTask:(CCLiveAudienceInfo *)enterTaskInfo  {
    if (enterTaskInfo) {
        //先加入待展示数组
        NSLog(@"用户：%@ 进房特效启动中～",enterTaskInfo.nickname);
        [_waitEnterTasks addObject:enterTaskInfo];
        //处理送礼弹幕
        [self showNextLEView];
    }
}

- (void)showNextLEView {
    if (self.waitEnterTasks.count && _enterStart) {
        CCLiveAudienceInfo *info = self.waitEnterTasks.firstObject;
        //查找闲置的弹道并展示弹幕
        for (int i=0; i<_enterViews.count; i++) {
            CCLiveEnterView *enterView = _enterViews[i];
            if (enterView.enterStatus == CCLiveEnterIdle) {
                enterView.enterInfo = info;
                enterView.enterStatus = CCLiveEnterShow;
                [_waitEnterTasks removeObjectAtIndex:0];
                break;
            }
        }
    }
}

- (void)closedAllEnterTask {
    //停止所有弹道动画
    for (int i=0; i<_enterViews.count; i++) {
        CCLiveEnterView *enterView = _enterViews[i];
        if (enterView.enterStatus != CCLiveEnterIdle) {
            enterView.enterStatus = CCLiveEnterIdle;
            [enterView restoreToOrginStatus];
        }
    }
    [_waitEnterTasks removeAllObjects];
}

@end
