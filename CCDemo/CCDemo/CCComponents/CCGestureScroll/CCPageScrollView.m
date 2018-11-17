//
//  CCPageScrollView.m
//  CCCustomComponent
//
//  Created by Chenggd on 2018/10/9.
//  Copyright © 2018 Dong. All rights reserved.
//

#import "CCPageScrollView.h"

@interface CCPageScrollView () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *tempScrollView;

@end

@implementation CCPageScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.directionType = CCScrollViewDirectionHorizontal;
        self.bounces = NO;
        self.delegate = self;
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = YES;
        self.showsHorizontalScrollIndicator = YES;
        //子视图到达/离开顶部的通知
        [CCNotiYCenter addObserver:self selector:@selector(acceptMsg:) name:kNotifScrollGoTop object:nil];
        [CCNotiYCenter addObserver:self selector:@selector(acceptMsg:) name:kNotifScrollLeaveTop object:nil];
        //初始化子视图位置
        [CCNotiYCenter addObserver:self selector:@selector(acceptMsg:) name:kNotifScrollBackToTop object:nil];
    }
    return self;
}

- (void)setPageViews:(NSMutableArray *)pageViews {
    if (_pageViews != pageViews) {
        _pageViews =  pageViews;
        [self setupPageContent];
    }
}

- (void)setupPageContent {
    if (self.directionType == CCScrollViewDirectionHorizontal) {
        //默认水平排列
        int index = 0;
        CGFloat tWidth = 0;
        for (UIView *itemView in _pageViews) {
            itemView.frame = CGRectMake(index * self.width, 0 , itemView.width, itemView.height);
            itemView.tag = index;
            //            [self setDelegateSelfWithItemView:itemView];
            [self addSubview:itemView];
            index ++ ;
            tWidth += itemView.width;
        }
        [self setContentSize:CGSizeMake(tWidth, 0)];
    } else {
        int index = 0;
        CGFloat tHeight = 0;
        for (UIView *itemView in _pageViews) {
            itemView.frame = CGRectMake(0, itemView.height * index, itemView.width, itemView.height);
            itemView.tag = index;
            [self addSubview:itemView];
            index ++ ;
            tHeight += itemView.height;
        }
        [self setContentSize:CGSizeMake(0, tHeight)];
    }
}


- (void)scrllToIndexPage:(NSInteger)index {
    [self scrllToIndexPage:index animated:YES];
}

- (void)scrllToIndexPage:(NSInteger)index animated:(BOOL)isAnimated {
    if (_pageViews.count > index) {
        _curPageIndex = index;
        CGPoint point = CGPointMake(0, 0);
        if (_directionType == CCScrollViewDirectionVertical) {
            point = CGPointMake(0, self.height * index);
        } else {
            point = CGPointMake(self.width * index, 0);
        }
        [self setContentOffset:point animated:isAnimated];
        self.tempScrollView = _pageViews[_curPageIndex];
    }
}

#pragma mark - UIScrollViewDelegate
// 减速 相对后
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _curPageIndex = scrollView.contentOffset.x / self.width;
    // index 抛出去
    if ([self.pageScrollDelegate respondsToSelector:@selector(scrollToIndex:)]) {
        [self.pageScrollDelegate scrollToIndex:_curPageIndex];
        self.tempScrollView = _pageViews[_curPageIndex];
    }
//    [self setSubViewTouchEnable:YES];
//    [self setSubViewScrollEnable:YES];
}

// called when setContentOffset
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    [self setSubViewTouchEnable:YES];
//    [self setSubViewScrollEnable:YES];
}

//滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self setSubViewTouchEnable:NO];
//    [self setSubViewScrollEnable:NO];
}

//增加分页视图左右滑动和外界MainView上下滑动互斥处理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [CCNotiYCenter postNotificationName:kNotifScrollEnableMainView object:nil userInfo:@{@"canScroll":@NO}];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [CCNotiYCenter postNotificationName:kNotifScrollEnableMainView object:nil userInfo:@{@"canScroll":@YES}];
//    [self setSubViewScrollEnable:YES];
}

#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return NO;
//}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint velocityPoint = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:gestureRecognizer.view];
        if (_directionType == CCScrollViewDirectionHorizontal) {
            if (velocityPoint.x > 0 && _curPageIndex == 0) {
                NSLog(@"侧滑冲突，手势被失效");
                return NO;
            }
        } else {
            if (velocityPoint.y > 0 && _curPageIndex == 0) {
                NSLog(@"侧滑冲突，手势被失效");
                return NO;
            }
        }
        
    }
    return YES;
}

#pragma mark - canscroll notif
- (void)acceptMsg:(NSNotification *)notif {
    NSDictionary *userInfo = notif.userInfo;
    BOOL canScroll = [userInfo[@"canScroll"] boolValue];
    if ([notif.name isEqualToString:kNotifScrollGoTop]) {
        self.canScroll = canScroll;
//        [self setSubViewScrollEnable:self.canScroll];
    } else if ([notif.name isEqualToString:kNotifScrollLeaveTop]) {
        self.canScroll = canScroll;
//        [self setSubViewScrollEnable:self.canScroll];
    } else if ([notif.name isEqualToString:kNotifScrollBackToTop]) {
        [self.tempScrollView setContentOffset:CGPointZero];
    }
}

//- (void)setSubViewTouchEnable:(BOOL)isEnable {
//    for (UIView *itemView in self.subviews) {
//        if (itemView) {
//            itemView.userInteractionEnabled = isEnable;
//        }
//    }
//}
//
//- (void)setSubViewScrollEnable:(BOOL)isEnable {
//    for (UIView *itemView in self.subviews) {
//        if ([itemView isKindOfClass:[UIScrollView class]]) {
//            UIScrollView *scrollView = (UIScrollView *)itemView;
//            scrollView.scrollEnabled = isEnable;
//        }
//    }
//}

@end
