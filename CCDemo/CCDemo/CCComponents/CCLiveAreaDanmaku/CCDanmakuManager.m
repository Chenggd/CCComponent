//
//  CCDanmakuManager.m
//  Dong
//
//  Created by Dong on 2018/5/11.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import "CCDanmakuManager.h"
#import "CCDanmakuView.h"

@interface CCDanmakuManager ()

/** 在显示中的普通弹幕视图数组 */
@property (nonatomic, strong) NSMutableArray *normalDanmakuViews;
/** 在显示中的礼物弹幕视图数组 */
@property (nonatomic, strong) NSMutableArray *giftDanmakuViews;
/** 普通弹幕数据源 */
@property (nonatomic, strong) NSMutableArray *normalDanmakus;
/** 礼物弹幕数据源 */
@property (nonatomic, strong) NSMutableArray *giftDanmakus;
/** 弹道速率 */
@property (nonatomic, strong) NSMutableArray *trajectorys;
/** next普通弹幕展示索引 */
@property (nonatomic, assign) NSInteger normalIndex;
/** next礼物弹幕展示索引 */
@property (nonatomic, assign) NSInteger giftIndex;
/** 标示总的弹幕装载器已经开始运行 */
@property (nonatomic, assign) BOOL beStart;
/** 标示礼物弹幕装载器已经开始运行 */
@property (nonatomic, assign) BOOL giftStart;

@end

@implementation CCDanmakuManager

- (instancetype)initWithInView:(UIView *)view {
    if (self = [super init]) {
        _normalDanmakuViews = [NSMutableArray arrayWithCapacity:0];
        _giftDanmakuViews = [NSMutableArray arrayWithCapacity:0];
        _normalDanmakus = [NSMutableArray arrayWithCapacity:0];
        _giftDanmakus = [NSMutableArray arrayWithCapacity:0];
        _trajectorys = [NSMutableArray arrayWithCapacity:0];
        _normalIndex = 0;
        _giftIndex = 0;
        _beStart = NO;
        _giftStart = NO;
        //装载幕布
        [view addSubview:self.danmakuScreenView];
    }
    return self;
}

- (UIView *)danmakuScreenView {
    if (!_danmakuScreenView) {
        _danmakuScreenView = [UIView createF:(CGRect){0,0,kScreenWidth,150} BC:[UIColor clearColor]];
        _danmakuScreenView.layer.masksToBounds = YES;
        _danmakuScreenView.userInteractionEnabled = NO;
    }
    return _danmakuScreenView;
}

- (void)addDanmakuDataSource:(NSMutableArray *)dataSource type:(NSInteger)type {
    [self stopDanmaku];
    if (type == 0) { //添加普通弹幕
        [_normalDanmakus removeAllObjects];
        [_normalDanmakus addObjectsFromArray:dataSource];
    } else {
        [_giftDanmakus removeAllObjects];
        [_giftDanmakus addObjectsFromArray:dataSource];
    }
}

- (void)sendDanmaku:(CCDanmuGiftInfo *)info type:(NSInteger)type first:(BOOL)first {
    if (_trajectorys.count != 3) {
        for (int i=0; i<3; i++) {
            //随机设置弹道速率
            [self setupSpeedByTrajectory:i];
        }
    }
    if (type == 0) { //添加普通弹幕
        [_normalDanmakus insertObject:info atIndex:(first?0 :_giftIndex)];
    } else {
        if (!_giftStart) { //只显示一次需要特殊处理～手动重启
            [_giftDanmakus addObject:info];
            [self creatDanmakuViewByTrajectory:2];
        } else {
            [_giftDanmakus insertObject:info atIndex:(first?0 :_giftIndex)];
        }
    }
}

- (void)creatDanmakuViewByTrajectory:(NSInteger)trajectory {
    CCDanmuGiftInfo *info = nil;
    if (![self nextIndexInDataSourece:trajectory]) {
        return;
    }
    if (trajectory == 2) {
        if (_giftDanmakus.count>_giftIndex) {
            info = _giftDanmakus[_giftIndex];
        }
    } else {
        if (_normalDanmakus.count>_normalIndex) {
            info = _normalDanmakus[_normalIndex];
        }
    }
    if ([CCTool isNotBlank:info]) {
        CCDanmakuView *view = [CCDanmakuView creatDanmakuView:info inView:self.danmakuScreenView speed:[_trajectorys[trajectory] floatValue] trajectory:trajectory];
        [view setY:trajectory*(view.height+12)];
        [_danmakuScreenView addSubview:view];
        if (trajectory == 2) {
            if (!_giftStart) {
                _giftStart = YES;
            }
            _giftIndex += 1;
            [_giftDanmakuViews addObject:view];
        } else {
            _normalIndex += 1;
            [_normalDanmakuViews addObject:view];
        }
        CCWS(weakSelf)
        [view setMoveAnimationBlock:^(CCDanmakuMoveStatus status) {
            if (status == CCDanmakuMoveStart) {
//                NSLog(@"开始");
            } else if (status == CCDanmakuMoveEnter) {
//                NSLog(@"出现下一个")`;
                [weakSelf creatDanmakuViewByTrajectory:trajectory];
            } else if (status == CCDanmakuMoveEnd) {
//                NSLog(@"结束");
            }
        }];
        [view startDanmakuAnimation];
    }
}

//弹幕是否循环显示
- (BOOL)nextIndexInDataSourece:(NSInteger)trajectory {
    if (trajectory == 2) { //匹配弹幕
        //(礼物弹幕只显示一次)
        if (_giftIndex > _giftDanmakus.count-1) {
            _giftStart = NO;
            _giftIndex = 0;
            [_giftDanmakus removeAllObjects];
            return NO;
        }
    } else {
        if (_normalIndex > _normalDanmakus.count-1) {
            _normalIndex = 0;
        }
    }
    return YES;
}

- (void)startDanmaku {
    if (_beStart) {
        return;
    }
    _beStart = YES;
    
    for (int i=0; i<3; i++) {
        //随机设置弹道速率
        [self setupSpeedByTrajectory:i];
        //装载弹道 0、1为普通弹道 3为礼物弹道，展示规则不一样
        //后续优化为可根据需求设置多个弹道，即每条弹道所属规则与数据对应
        [self creatDanmakuViewByTrajectory:i];
    }
}

- (void)setupSpeedByTrajectory:(NSInteger)trajectory {
    float randomNum = (float)(arc4random()%40+50);
    [_trajectorys insertObject:@(randomNum) atIndex:trajectory];
}

- (void)stopDanmaku {
    if (!_beStart) {
        return;
    }
    _beStart = NO;
    
    [self stopNormalDanmaku];
    [self stopGiftDanmaku];
    [_trajectorys removeAllObjects];
}

- (void)stopNormalDanmaku {
    _normalIndex = 0;
    [_normalDanmakuViews makeObjectsPerformSelector:@selector(stopDanmakuAnimation)];
    [_normalDanmakuViews removeAllObjects];
}

- (void)stopGiftDanmaku {
    _giftStart = NO;
    _giftIndex = 0;
    [_giftDanmakuViews makeObjectsPerformSelector:@selector(stopDanmakuAnimation)];
    [_giftDanmakuViews removeAllObjects];
    //只显示一次～～
    [_giftDanmakus removeAllObjects];
}

@end
