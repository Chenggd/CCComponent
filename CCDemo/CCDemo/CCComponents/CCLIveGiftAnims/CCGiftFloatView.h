//
//  CCGiftFloatView.h
//  CCCustomComponent
//
//  Created by Chenggd on 2018/7/4.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import "CCGIftBaseAnimView.h"
#import "CCLiveGiftMsgInfo.h"

typedef void (^giftFinishedBlock)(BOOL needGoon, CCLiveGiftMsgInfo *curGiftInfo);
typedef void (^giftStartBlock)();

/**
 特效礼物
 */
@interface CCGiftFloatView : CCGIftBaseAnimView

@property (nonatomic, copy) giftFinishedBlock floatFinishedBlock;
@property (nonatomic, assign) BOOL hasAnimCache;
@property (nonatomic, strong) CCLiveGiftMsgInfo *giftInfo;

@end
