//
//  CCCircleShareView.h
//  BeautyBeeTravel
//
//  Created by Chenggd on 2018/9/26.
//  Copyright © 2018 美蜂. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCMyCollectInfo.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^tapCircleShareAction)(CCMyCollectInfo *info, NSInteger index);

/**
 刷新头部关注用户数据
 */
typedef void (^refreshFoucsCSBlock)(NSMutableArray *focusArray);
/**
 结束刷新数据
 */
typedef void (^refreshShareEnd)();

/**
 个人主页圈子分享瀑布流
 */
@interface CCCircleShareView : UICollectionView

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) BOOL needLoad;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger page_size;
@property (nonatomic, strong) NSMutableArray *shareData;

@property (nonatomic, copy) tapCircleShareAction tapCircleShareAction;
@property (nonatomic, copy) refreshFoucsCSBlock refreshFoucsCSBlock;
@property (nonatomic, copy) refreshShareEnd refreshShareEnd;

/**
 0:分享列表 1:我关注的分享列表
 */
@property (nonatomic, assign) NSInteger shareType;
/**
 用于开启嵌套监听
 */
@property (nonatomic, assign) BOOL openNestedHook;

/**
 最小内容高度，用于显示空态
 */
@property (nonatomic, assign) CGFloat minContentHeight;

- (void)removeInfoByShareId:(NSString *)shareId;
- (void)reloadShareData;
- (void)desposeRefreshStatus;
- (void)clearOldData;

@end

NS_ASSUME_NONNULL_END
