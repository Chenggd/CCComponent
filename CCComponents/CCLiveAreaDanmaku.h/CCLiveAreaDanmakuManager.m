//
//  CCLiveAreaDanmakuManager.m
//  BeautyBeeTravel
//
//  Created by Dong on 2018/9/6.
//  Copyright © 2018年 美蜂. All rights reserved.
//

#import "CCLiveAreaDanmakuManager.h"
#import "CCLiveAreaDanmakuView.h"
#import "UIView+WhenTappedBlocks.h"

@interface CCLiveAreaDanmakuManager()

/** 弹幕数据源 */
@property (nonatomic, strong) NSMutableArray *waitDanmakus;
/** 标示特效装载器在运行中 */
@property (nonatomic, assign) BOOL danmakuAnimOnRun;
//表示停止继续匹配特效队列
@property (nonatomic, assign) BOOL stopAnimQueue;

@end

@implementation CCLiveAreaDanmakuManager

- (instancetype)initWithInView:(UIView *)view {
    if (self = [super init]) {
        _waitDanmakus = [NSMutableArray arrayWithCapacity:0];
        _stopAnimQueue = NO;
        _danmakuAnimOnRun = NO;
        //装载幕布
        [view addSubview:self.danmakuScreenView];
    }
    return self;
}

- (UIView *)danmakuScreenView {
    if (!_danmakuScreenView) {
        _danmakuScreenView = [UIView createF:(CGRect){0,0,kScreenWidth,24} BC:[UIColor clearColor]];
    }
    return _danmakuScreenView;
}

- (void)addLiveAreaDanmaku:(CCDanmuGiftInfo *)info {
    if (info) {
        //先加入待展示数组
        [_waitDanmakus addObject:[info mutableCopy]];
        //处理全区弹幕特效
        [self showNextDanmaku];
    }
}

- (void)showNextDanmaku {
    if (self.waitDanmakus.count && !_danmakuAnimOnRun) {
        CCDanmuGiftInfo *info = [self.waitDanmakus.firstObject mutableCopy];
        //移除队列中即将展示的弹幕
        [_waitDanmakus removeObjectAtIndex:0];
        [self showLiveDanmakuAnimation:info];
    }
}

- (void)showLiveDanmakuAnimation:(CCDanmuGiftInfo *)danmakuInfo {
    CCLiveAreaDanmakuView *danmakuView = [[CCLiveAreaDanmakuView alloc] initWithFrame:(CGRect){10,0,24,24}];
    danmakuView.tag = 110;
    danmakuView.danmakuMsgInfo = danmakuInfo;
    CCWS(weakSelf)
    [danmakuView setDmFinishedBlock:^(CCDanmuGiftInfo *curDanmakuInfo) {
        //结束开始下一个
        weakSelf.danmakuAnimOnRun = NO;
        [self showNextDanmaku];
    }];
    [danmakuView setDmTapActionBlock:^(CCDanmuGiftInfo *curDanmakuInfo) {
        if ([weakSelf.areaDanmakuDelegate respondsToSelector:@selector(tapLiveAreaDanmakuAction:)]) {
            [weakSelf.areaDanmakuDelegate tapLiveAreaDanmakuAction:curDanmakuInfo];
        }
    }];
    [self.danmakuScreenView addSubview:danmakuView];
    _danmakuAnimOnRun = YES;
    [danmakuView startAreaDanmakuAnimation];
}

- (void)stopLiveAreaDanmaku {
    CCLiveAreaDanmakuView *danmakuView = [self.danmakuScreenView viewWithTag:110];
    if (danmakuView) {
        [danmakuView stopAreaDanmakuAnimation];
    }
}

@end
