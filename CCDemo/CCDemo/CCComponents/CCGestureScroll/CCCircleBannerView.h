//
//  CCCircleBannerView.h
//  CCCustomComponent
//
//  Created by Chenggd on 2018/9/27.
//  Copyright © 2018 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCHomeBannerInfo.h"

typedef void(^scrollItemHandler) (NSInteger index);
typedef void(^scrollDidHandler) (CGFloat contentOffsetX, CGFloat width);
typedef void(^tapCirBannerHandler) (CCHomeBannerInfo *info);

NS_ASSUME_NONNULL_BEGIN

/**
 分页滚动缩放视图(适用于数量不多的Banner视图)
 */
@interface CCCircleBannerView : UIView

@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, copy) tapCirBannerHandler tapCirBannerHandler;

@property (nonatomic, assign) float space;
@property (nonatomic, assign) float ratioBySpace;

+ (instancetype)creatCircleBannerView:(CGRect)frame
                           dataSource:(NSMutableArray *)dataSource
                    scrollItemHandler:(scrollItemHandler)handle
                     scrollDidHandler:(scrollDidHandler)scrollHandle;

- (void)reloadCircleBannerData:(NSMutableArray *)dataSource;

@end

@interface CCTouchView : UIView

@property (nonatomic, retain) UIView *receiver;

@end

NS_ASSUME_NONNULL_END
