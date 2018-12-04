//
//  CCBaseListTab.h
//  BeautyBeePro
//
//  Created by Chenggd on 2018/1/4.
//  Copyright © 2018年 Chenggd. All rights reserved.
//

#import "CCBaseListTab.h"

@interface CCBaseListTab ()<UITableViewDelegate>

@property (nonatomic, assign) BOOL canScroll;

@end

@implementation CCBaseListTab

- (void)dealloc {
    [CCNotiYCenter removeObserver:self];
    self.delegate = nil;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.openNestedHook = NO;
    }
    return self;
}

- (void)setOpenNestedHook:(BOOL)openNestedHook {
    _openNestedHook = openNestedHook;
    if (_openNestedHook) {
        self.delegate = self;
        //子控制器视图到达/离开顶部的通知
        [CCNotiYCenter addObserver:self selector:@selector(acceptMsg:) name:kNotifScrollGoTop object:nil];
        [CCNotiYCenter addObserver:self selector:@selector(acceptMsg:) name:kNotifScrollLeaveTop object:nil];
    }
}

- (void)acceptMsg:(NSNotification *)notification {
    if (_openNestedHook) {
        NSString *notificationName = notification.name;
        NSDictionary *userInfo = notification.userInfo;
        BOOL canScroll = [userInfo[@"canScroll"] boolValue];
        if ([notificationName isEqualToString:kNotifScrollGoTop]) {
            self.canScroll = canScroll;
        } else if ([notificationName isEqualToString:kNotifScrollLeaveTop]) {
            self.canScroll = NO;
            self.contentOffset = CGPointZero;
        }
        self.showsVerticalScrollIndicator = self.canScroll;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_openNestedHook) {
        if (!self.canScroll) {
            [scrollView setContentOffset:CGPointZero];
        }
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY <= 0) {
            [scrollView setContentOffset:CGPointZero];
            [CCNotiYCenter postNotificationName:kNotifScrollGoTop object:nil userInfo:@{@"canScroll":@YES}];
        }
    }
}

- (void)setMinContentHeight:(CGFloat)minContentHeight {
    _minContentHeight = minContentHeight;
    self.emptyDefaultView.height = minContentHeight;
    if (_minContentHeight > 0) {
        [self setContentSize:(CGSize){0,_minContentHeight}];
    }
}

- (UIView *)emptyDefaultView {
    if (!_emptyDefaultView) {
        UIImage *noDataIcon = [UIImage imageNamed:@"empty_focus"];
        _emptyDefaultView = [UIView createNullViewWithF:CGRectMake(0,0,self.width,300) img:noDataIcon imgFrm:(CGRect){(kGSize.width-noDataIcon.size.width)/2,kIPhoneXFitHeight(0),noDataIcon.size.width,noDataIcon.size.height} txt:@"暂无数据" target:self sel:nil otherView:nil];
    }
    return _emptyDefaultView;
}

@end
