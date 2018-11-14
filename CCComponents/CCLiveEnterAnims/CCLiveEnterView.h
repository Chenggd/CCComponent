//
//  CCLiveEnterView.h
//  BeautyBeeTravel
//
//  Created by Dong on 2018/8/8.
//  Copyright © 2018年 美蜂. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCLiveAudienceInfo.h"

typedef NS_ENUM(NSInteger, CCLiveEnterStatus) { //进房特效状态
    CCLiveEnterIdle = 0,                        //闲置
    CCLiveEnterShow = 1,                        //显示
    CCLiveEnterWillAppera = 2,                  //将要消失(2秒后)
    CCLiveEnterAppera = 3                       //消失
};

typedef NS_ENUM(NSInteger, CCLiveEnterStyle) { //进房特效style
    CCLELeftToRight = 0,                       //从左到右
    CCLERightToLeft = 1,                       //从右到左
    CCLEScattered = 2                          //分散
};

typedef void (^liveEnterStatusBlock)(CCLiveEnterStatus status);

@interface CCLiveEnterView : UIView

@property (nonatomic, strong) CCLiveAudienceInfo *enterInfo;
@property (nonatomic, assign) CCLiveEnterStatus enterStatus;
@property (nonatomic, copy) liveEnterStatusBlock liveEnterStatusBlock;
@property (nonatomic, assign) CCLiveEnterStyle style;
//指定父视图
@property (nonatomic, strong) UIView *screenView;
//指定动画展示父视图
@property (nonatomic, strong) UIView *animaScreenView;

- (void)restoreToOrginStatus;

@end
