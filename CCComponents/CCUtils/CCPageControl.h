//
//  CCPageControl.h
//  HASAKA
//
//  Created by Dong on 2017/1/19.
//  Copyright (c) 2015年 HASAKA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCPageControl : UIPageControl

- (instancetype)initWithFrame:(CGRect)frame activeImgStr:(NSString *)activeImgStr inactiveImgStr:(NSString *)inactiveImgStr;

- (instancetype)initWithFrame:(CGRect)frame activeImg:(UIImage *)activeImg inactiveImg:(UIImage *)inactiveImg;

@property (nonatomic, strong) UIImage *activeImage;
@property (nonatomic, strong) UIImage *inactiveImage;

@end
