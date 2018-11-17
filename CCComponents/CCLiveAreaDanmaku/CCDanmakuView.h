//
//  CCDanmakuView.h
//  Dong
//
//  Created by Dong on 2018/5/11.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCDanmuGiftInfo.h"

typedef NS_ENUM(NSInteger, CCDanmakuMoveStatus) { //弹幕的移动状态
    CCDanmakuMoveStart = 0,
    CCDanmakuMoveEnter = 1,
    CCDanmakuMoveEnd = 2
};

typedef void (^moveAnimationBlock)(CCDanmakuMoveStatus status);

@interface CCDanmakuView : UIView

@property (nonatomic, copy) moveAnimationBlock moveAnimationBlock;

+ (instancetype)creatDanmakuView:(CCDanmuGiftInfo *)info inView:(UIView *)inView
                           speed:(float)speed trajectory:(NSInteger)trajectory;
- (void)startDanmakuAnimation;
- (void)stopDanmakuAnimation;

@end
