//
//  CCLiveScrollBanner.h
//  BeautyBeeTravel
//
//  Created by Dong on 2018/6/19.
//  Copyright © 2018年 圈播. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCHomeBannerInfo.h"

typedef void (^tapLiveBannerBlock)(CCHomeBannerInfo *info);

/**
 广告轮播图
 */
@interface CCLiveScrollBanner : UIView

@property (nonatomic, strong) NSMutableArray *bannerData;
@property (nonatomic, assign) NSInteger curIndex;
@property (nonatomic, assign) BOOL autoScroll;
@property (nonatomic, copy) tapLiveBannerBlock tapLiveBannerBlock;

- (void)clearAllBanner;

@end
