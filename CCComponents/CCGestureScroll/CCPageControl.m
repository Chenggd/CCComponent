//
//  CCPageControl.m
//  Dong
//
//  Created by Dong on 2017/1/19.
//  Copyright (c) 2015年 Dong. All rights reserved.
//

#import "CCPageControl.h"

@implementation CCPageControl

- (instancetype)initWithFrame:(CGRect)frame activeImgStr:(NSString *)activeImgStr inactiveImgStr:(NSString *)inactiveImgStr {
    self = [super initWithFrame:frame];
    if (self) {
        _activeImage = [UIImage imageNamed:activeImgStr];
        _inactiveImage = [UIImage imageNamed:inactiveImgStr];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame activeImg:(UIImage *)activeImg inactiveImg:(UIImage *)inactiveImg {
    self = [super initWithFrame:frame];
    if (self) {
        _activeImage = activeImg;
        _inactiveImage = inactiveImg;
    }
    return self;
}

- (void)updateDots {
    for (int i = 0; i < [self.subviews count]; i++) {
        if ([[self.subviews objectAtIndex:i] isKindOfClass:[UIView class]]) {
            UIView* dot = [self.subviews objectAtIndex:i];
            [[dot subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            if (i == self.currentPage) {
                UIImageView *activieImage = [[UIImageView alloc] initWithImage:_activeImage];
                activieImage.center = CGPointMake(dot.width/2, dot.height/2);
                [dot addSubview:activieImage];
            } else {
                UIImageView *inactiveImage = [[UIImageView alloc] initWithImage:_inactiveImage];
                inactiveImage.center = CGPointMake(dot.width/2, dot.height/2);
                [dot addSubview:inactiveImage];
            }
        } else if ([[self.subviews objectAtIndex:i] isKindOfClass:[UIImageView class]]) {
            UIImageView* dot = [self.subviews objectAtIndex:i];
            if (i == self.currentPage)  {
                dot.image = _activeImage;
            } else {
                dot.image = _inactiveImage;
            }
        }
    }
}

- (void)setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    [self updateDots];
}

@end
