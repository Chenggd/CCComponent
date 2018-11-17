//
//  UIView+CCBadge.m
//  BeautyBeePro
//
//  Created by Chenggd on 2018/2/2.
//  Copyright © 2018年 Chenggd. All rights reserved.
//

#import "UIView+CCBadge.h"
#import "UIView+Additions.h"
#import <objc/runtime.h>

static char badgeViewKey;
static NSInteger const pointWidth = 10; //小红点的宽高
static NSInteger const rightRange = 2; //距离控件右边的距离
static CGFloat const badgeFont = 14; //字体的大小

@implementation UIView (CCBadge)

- (void)showBadge {
    if (self.badge == nil) {
        CGRect frame = CGRectMake(CGRectGetWidth(self.frame) + rightRange, -pointWidth / 2, pointWidth, pointWidth);
        self.badge = [[UILabel alloc] initWithFrame:frame];
        self.badge.backgroundColor = [UIColor redColor];
        self.badge.textColor = [UIColor whiteColor];
        self.badge.font = [UIFont systemFontOfSize:badgeFont];
        self.badge.textAlignment = NSTextAlignmentCenter;
        self.badge.layer.cornerRadius = pointWidth / 2;
        self.badge.layer.masksToBounds = YES;
        self.badge.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.badge.layer.borderWidth = 1.f;
    }
    [self addSubview:self.badge];
    [self bringSubviewToFront:self.badge];
}

- (void)showBadgeRedCount:(NSInteger)redCount {
    self.badge.text = (redCount > 99 ? [NSString stringWithFormat:@"99+"] : [NSString stringWithFormat:@"%@", @(redCount)]);
    [self.badge sizeToFit];
    CGRect relFrame = CGRectMake(0,0,self.badge.width+4,self.badge.height+4);
    self.badge.frame = relFrame;
    self.badge.layer.cornerRadius = self.badge.height/2.f;
}

- (void)showBadgeOrginX:(float)orginX orginY:(float)orginY {
    CGRect frame = CGRectMake(orginX, orginY, pointWidth, pointWidth);
    if (self.badge == nil) {
        self.badge = [[UILabel alloc] initWithFrame:frame];
        self.badge.backgroundColor = [UIColor redColor];
        self.badge.layer.cornerRadius = pointWidth/2;
        self.badge.layer.masksToBounds = YES;
        self.badge.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.badge.layer.borderWidth = 1.f;
    }
    [self.badge setFrame:frame];
    [self addSubview:self.badge];
    [self bringSubviewToFront:self.badge];
}

- (void)showBadgeWithCount:(NSInteger)redCount {
    if (redCount < 0) {
        return;
    }
    [self showBadge];
    self.badge.textColor = [UIColor whiteColor];
    self.badge.font = [UIFont systemFontOfSize:badgeFont];
    self.badge.textAlignment = NSTextAlignmentCenter;
    self.badge.text = (redCount > 99 ? [NSString stringWithFormat:@"99+"] : [NSString stringWithFormat:@"%@", @(redCount)]);
    [self.badge sizeToFit];
    CGRect frame = self.badge.frame;
    frame.size.width += (frame.size.width/3);
    frame.size.height += 3;
    frame.origin.x = self.width;
    frame.origin.y = (self.height-frame.size.height)/2;
    if (CGRectGetWidth(frame) < CGRectGetHeight(frame)) {
        frame.size.width = CGRectGetHeight(frame);
    }
    self.badge.frame = frame;
    self.badge.layer.cornerRadius = CGRectGetHeight(self.badge.frame) / 2;
}

- (void)showBadgeWithCount:(NSInteger)redCount orginX:(CGFloat)orginX orginY:(CGFloat)orginY {
    if (redCount < 0) {
        return;
    }
    [self showBadge];
    self.badge.textColor = [UIColor whiteColor];
    self.badge.font = [UIFont systemFontOfSize:badgeFont];
    self.badge.textAlignment = NSTextAlignmentCenter;
    self.badge.text = (redCount > 99 ? [NSString stringWithFormat:@"99+"] : [NSString stringWithFormat:@"%@", @(redCount)]);
    [self.badge sizeToFit];
    
    CGRect frame = self.badge.frame;
    frame.size.height += 3;
    frame.size.width += frame.size.height/2;
    frame.origin.x = orginX;
    frame.origin.y = orginY;
    if (CGRectGetWidth(frame) < CGRectGetHeight(frame)) {
        frame.size.width = CGRectGetHeight(frame);
    }
    self.badge.frame = frame;
    self.badge.layer.cornerRadius = CGRectGetHeight(self.badge.frame)/2;
}

- (void)hidenBadge {
    [self.badge removeFromSuperview];
}

#pragma mark - GetterAndSetter

- (UILabel *)badge {
    return objc_getAssociatedObject(self, &badgeViewKey);
}

- (void)setBadge:(UILabel *)badge {
    objc_setAssociatedObject(self, &badgeViewKey, badge, OBJC_ASSOCIATION_RETAIN);
}

@end
