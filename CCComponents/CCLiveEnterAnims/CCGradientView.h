//
//  CCGradientView.h
//  BeautyBeeTravel
//
//  Created by Dong on 2018/8/8.
//  Copyright © 2018年 美蜂. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCGradientView : UIView

@property (nonatomic, strong) UIColor *firstColor;
@property (nonatomic, strong) UIColor *secondColor;
@property (nonatomic, strong) UIColor *bordColor;
@property (nonatomic, strong) UIColor *bordTColor;
@property (nonatomic, assign) BOOL needBorder;

- (void)refreshLayer;

@end
