//
//  BTCircleBannerView.h
//  BeautyBeeTravel
//
//  Created by Chenggd on 2018/9/27.
//  Copyright © 2018 美蜂. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTHomeBannerInfo.h"

typedef void(^scrollItemHandler) (NSInteger index);
typedef void(^scrollDidHandler) (CGFloat contentOffsetX, CGFloat width);
typedef void(^tapCirBannerHandler) (BTHomeBannerInfo *info);

NS_ASSUME_NONNULL_BEGIN

/**
 分页滚动缩放视图
 */
@interface BTCircleBannerView : UIView

@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, copy) tapCirBannerHandler tapCirBannerHandler;

+ (instancetype)creatCircleBannerView:(CGRect)frame
                           dataSource:(NSMutableArray *)dataSource
                    scrollItemHandler:(scrollItemHandler)handle
                     scrollDidHandler:(scrollDidHandler)scrollHandle;

- (void)reloadCircleBannerData:(NSMutableArray *)dataSource;

@end

@interface BTTouchView : UIView

@property (nonatomic, retain) UIView *receiver;

@end

NS_ASSUME_NONNULL_END
