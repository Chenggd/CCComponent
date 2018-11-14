//
//  CCGiftAnimManager.m
//  BeautyBeeTravel
//
//  Created by Chenggd on 2018/7/4.
//  Copyright © 2018年 圈播. All rights reserved.
//

#import "CCGiftAnimManager.h"
#import "CCGiftFloatView.h"

@interface CCGiftAnimManager()

/** 礼物数据源 */
@property (nonatomic, strong) NSMutableArray *waitGifts;
/** 标示礼物特效装载器在运行中 */
@property (nonatomic, assign) BOOL giftAnimOnRun;
//表示停止继续匹配特效队列
@property (nonatomic, assign) BOOL stopAnimQueue;

@end

@implementation CCGiftAnimManager

- (instancetype)initWithInView:(UIView *)view {
    if (self = [super init]) {
        _waitGifts = [NSMutableArray arrayWithCapacity:0];
        _giftAnimOnRun = NO;
        _stopAnimQueue = NO;
        //装载幕布
        [view addSubview:self.giftAnimScreenView];
    }
    return self;
}

- (UIView *)giftAnimScreenView {
    if (!_giftAnimScreenView) {
        _giftAnimScreenView = [UIView createF:(CGRect){0,0,kScreenWidth,kScreenHeight} BC:[UIColor clearColor]];
        _giftAnimScreenView.userInteractionEnabled = NO;
    }
    return _giftAnimScreenView;
}

- (void)addGiftAnimation:(CCLiveGiftMsgInfo *)info {
    if (info && info.model == 2) { //2为特效礼物
        info.type = AnimaGiftTypeKey;
        //先加入待展示数组
        [_waitGifts addObject:[info mutableCopy]];
        //处理送礼特效
        [self showNextGiftAnimation];
    }
}

- (void)showNextGiftAnimation {
    //TODO:这里连送的话展示逻辑需要调整～
    if (self.waitGifts.count && !_giftAnimOnRun) {
        CCLiveGiftMsgInfo *info = [self.waitGifts.firstObject mutableCopy];
        //移除队列中即将展示的礼物
        [_waitGifts removeObjectAtIndex:0];
        //送礼展示
        if (info.gift_number == 0) {
            NSLog(@"送出礼物数不可为0 ～");
        }
        [self showFloatView:info];
    }
}

- (void)showFloatView:(CCLiveGiftMsgInfo *)giftInfo {
    CCGiftFloatView *floatView = [[CCGiftFloatView alloc] initWithFrame:(CGRect){0,0,kScreenWidth,kScreenHeight}];
    [floatView setCenter:_giftAnimScreenView.center];
    [floatView setGiftInfo:[giftInfo mutableCopy]];
    CCWS(weakSelf)
    [floatView setFloatFinishedBlock:^(BOOL needGoon, CCLiveGiftMsgInfo *curGiftInfo) {
        //有资源的话才会有回调
        weakSelf.giftAnimOnRun = NO;
        if (!weakSelf.stopAnimQueue) {
            if (needGoon) {
                [self showFloatView:curGiftInfo];
            } else {
                [self showNextGiftAnimation];
            }
        } else {
            weakSelf.stopAnimQueue = NO;
        }
    }];
    //展示特效
    if (floatView.hasAnimCache) {
        //本地特效资源已下载成功
        [_giftAnimScreenView addSubview:floatView];
        _giftAnimOnRun = YES;
        [floatView startGiftAnimation];
    } else {
        NSLog(@"本地无资源,继续队列展示");
        [self showNextGiftAnimation];
    }
}

- (void)stopAllGiftAnimations {
    //清除特效
    _stopAnimQueue = YES;
    [_giftAnimScreenView.subviews makeObjectsPerformSelector:@selector(stopGiftAnimation)];
    [_waitGifts removeAllObjects];
}

@end
