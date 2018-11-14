//
//  CCHookScrollView.m
//  BeautyBeeTravel
//
//  Created by Chenggd on 2018/10/9.
//  Copyright © 2018 美蜂. All rights reserved.
//

#import "CCHookScrollView.h"

@interface CCHookScrollView ()<UIScrollViewDelegate>

/**
 当前滚动标示
 */
@property (nonatomic, assign) BOOL canScroll;

/**
 当子View滚动互斥MainView时，MainView的原始状态
 */
@property (nonatomic, assign) BOOL lastCanScroll;

@end

@implementation CCHookScrollView

- (void)dealloc {
    [CCNotiYCenter removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.canScroll = YES;
        self.delegate = self;
        //子控制器视图到达/离开顶部的通知
        [CCNotiYCenter addObserver:self selector:@selector(acceptMsg:) name:kNotifScrollGoTop object:nil];
        //子视图与自身的滚动互斥
        [CCNotiYCenter addObserver:self selector:@selector(acceptMsg:) name:kNotifScrollEnableMainView object:nil];
    }
    return self;
}

#pragma mark - hookGesture
//是否让外层scrollView的手势透传到子视图
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.openTouchHook) {
        CGPoint currentPoint = [gestureRecognizer locationInView:self];
        if (CGRectContainsPoint(CGRectMake(0, self.hookAreaTop, kScreenWidth, self.contentSize.height-self.hookAreaTop), currentPoint)) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.openTouchHook) {
        //当前偏移量
        CGFloat curOffsetY = scrollView.contentOffset.y;
        //吸顶临界点
        CGFloat criticalPointOffsetY = self.hookAreaTop;
        /* 利用contentOffset处理内外层scrollView的滑动冲突问题
         * 一、吸顶状态: segmentView到达临界点(这里设置的临界点是导航栏底部，可以自定义))
         mainTableView不能滚动(固定mainTableView的位置-通过设置contentOffset的方式),segmentView的子控制器的tableView或collectionView在竖直方向上可以滚动；
         二、未吸顶状态:
         mainTableView能滚动,segmentView的子控制器的tableView或collectionView在竖直方向上不可以滚动；
         */
        if (curOffsetY >= criticalPointOffsetY) {
            /*
             * 到达临界点 ：此状态下有两种情况
             * 1.未吸顶状态 -> 吸顶状态
             * 2.维持吸顶状态 (segmentView的子控制器的tableView或collectionView在竖直方向上的contentOffsetY大于0)
             */
            scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
            //进入吸顶状态
            [CCNotiYCenter postNotificationName:kNotifScrollGoTop object:nil userInfo:@{@"canScroll":@YES}];
            self.canScroll = NO;
        } else {
            /*
             * 未达到临界点 ：此状态下有两种情况，且这两种情况完全相反，这也是引入一个canScroll属性的重要原因
             * 1.吸顶状态 -> 不吸顶状态
             * 2.维持吸顶状态 (segmentView的子控制器的tableView或collectionView在竖直方向上的contentOffsetY大于0)
             */
            if (!self.canScroll) {
                //维持吸顶状态
                scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
                //进入吸顶状态
                [CCNotiYCenter postNotificationName:kNotifScrollGoTop object:nil userInfo:@{@"canScroll":@YES}];
                self.canScroll = NO;
            } else {
                [CCNotiYCenter postNotificationName:kNotifScrollLeaveTop object:nil userInfo:@{@"canScroll":@NO}];
                self.canScroll = YES;
                /* 吸顶状态 -> 不吸顶状态
                 * segmentView的子控制器的tableView或collectionView在竖直方向上的contentOffsetY小于等于0时，会通过通知的方式改变self.canScroll的值；
                 * 这里不再做多余处理，已经在SegmentVC中做了处理-发送“leaveTop”的通知
                 */
            }
        }
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    if (self.openTouchHook) {
        //通知分页子控制器列表返回顶部
        [CCNotiYCenter postNotificationName:kNotifScrollBackToTop object:nil];
    }
    return YES;
}

- (void)acceptMsg:(NSNotification *)notification {
    NSString *notificationName = notification.name;
    NSDictionary *userInfo = notification.userInfo;
    BOOL canScroll = [userInfo[@"canScroll"] boolValue];
    if ([notificationName isEqualToString:kNotifScrollGoTop]) {
        self.canScroll = canScroll;
        self.showsVerticalScrollIndicator = self.canScroll;
    } else if ([notificationName isEqualToString:kNotifScrollEnableMainView]) {
        if (!canScroll) { //开始滑动时记录MainView状态
            self.lastCanScroll = self.canScroll;
        }
        self.canScroll = canScroll;
        self.scrollEnabled = self.canScroll;
        if (canScroll) { //结束滑动时还原MainView状态
            self.canScroll = self.lastCanScroll;
        }
    }
}

@end
