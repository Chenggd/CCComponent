//
//  CCPageScrollView.h
//  CCCustomComponent
//
//  Created by Chenggd on 2018/10/9.
//  Copyright © 2018 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CCScrollViewDirectionType) {
    CCScrollViewDirectionHorizontal = 0,                 
    CCScrollViewDirectionVertical
};

@protocol CCPageScrollViewDelegate <NSObject>

@optional     // 滑动到哪里抛出去 index
- (void)scrollToIndex:(NSInteger)currentIndex;

@end

/**
 滑动分页容器(多级嵌套配合CCHookScrollView使用)
 */
@interface CCPageScrollView : UIScrollView
/**
 排序方向 水平 or 垂直
 */
@property (nonatomic, assign) CCScrollViewDirectionType directionType;
/**
 滑动代理
 */
@property (nonatomic, assign) id<CCPageScrollViewDelegate> pageScrollDelegate;
/**
 索引位置
 */
@property (nonatomic, assign) NSInteger curPageIndex;
/**
 分页
 */
@property (nonatomic, strong) NSMutableArray *pageViews;
/**
 当前滚动标示
 */
@property (nonatomic, assign) BOOL canScroll;

/**
 滚动至index页面
 @param index index
 */
- (void)scrllToIndexPage:(NSInteger)index;
- (void)scrllToIndexPage:(NSInteger)index animated:(BOOL)isAnimated;

@end

NS_ASSUME_NONNULL_END
