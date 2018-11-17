//
//  CCLiveAreaDanmakuView.h
//  CCCustomComponent
//
//  Created by Dong on 2018/9/6.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCDanmuGiftInfo.h"

typedef void (^dmFinishedBlock)(CCDanmuGiftInfo *curDanmakuInfo);
//typedef void (^dmStartBlock)();
typedef void (^dmTapActionBlock)(CCDanmuGiftInfo *curDanmakuInfo);

/**
 直播间全区弹幕特效
 */
@interface CCLiveAreaDanmakuView : UIView

@property (nonatomic, copy) dmFinishedBlock dmFinishedBlock;
@property (nonatomic, copy) dmTapActionBlock dmTapActionBlock;
@property (nonatomic, strong) CCDanmuGiftInfo *danmakuMsgInfo;
//展示时长
@property (nonatomic, assign) NSTimeInterval runDuration;

- (void)startAreaDanmakuAnimation;
- (void)stopAreaDanmakuAnimation;

@end
