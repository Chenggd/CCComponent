//
//  CCGradientView.m
//  BeautyBeeTravel
//
//  Created by Dong on 2018/8/8.
//  Copyright © 2018年 美蜂. All rights reserved.
//

#import "CCGradientView.h"

@implementation CCGradientView

//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    // Drawing code
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    //绘制颜色渐变，创建色彩空间对象
//    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
//    //创建起/终点颜色
//    CGColorRef beginColor = self.firstColor.CGColor;
//    CGColorRef endColor = self.secondColor.CGColor;
//    //创建颜色数组
//    CFArrayRef colorArray = CFArrayCreate(kCFAllocatorDefault, (const void*[]){beginColor, endColor}, 2, nil);
//    //创建渐变对象
//    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef, colorArray, (CGFloat[]) {
//        0.0f,     //对应起点颜色位置
//        1.0f    //对应终点颜色位置
//    });
//    //释放颜色数组,起点和终点颜色,色彩空间
//    CFRelease(colorArray);
////    CGColorRelease(beginColor);
////    CGColorRelease(endColor);
//    CGColorSpaceRelease(colorSpaceRef);
//    //绘制
//    CGContextDrawLinearGradient(context, gradientRef, CGPointMake(0, 0), CGPointMake(0, 1), kCGGradientDrawsBeforeStartLocation);
//    // 释放渐变对象
//    CGGradientRelease(gradientRef);
    
    
    //背景渐变
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.frame = self.bounds;
//    gradientLayer.colors = @[(__bridge id)self.firstColor.CGColor,
//                                 (__bridge id)self.secondColor.CGColor];
//    if (_needBorder) {
//        //根据星星宽度计算吧
//        gradientLayer.locations = @[@(1-40.f/self.width),@(1.f)];
//    }
//    gradientLayer.startPoint = CGPointMake(0, 1);
//    gradientLayer.endPoint = CGPointMake(1, 1);
//    [self.layer addSublayer:gradientLayer];
//
//    if (_needBorder) {
//        //边框渐变
//        for (int i=0; i<2; i++) {
//            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//            gradientLayer.frame = CGRectMake(0, i*self.height-(i>0?1:0), self.width, 1);
//            gradientLayer.colors = @[(__bridge id)self.bordColor.CGColor,
//                                     (__bridge id)self.bordTColor.CGColor];
//            gradientLayer.startPoint = CGPointMake(0, 1);
//            gradientLayer.endPoint = CGPointMake(1, 1);
//            [self.layer addSublayer:gradientLayer];
//        }
//    }
//}

- (void)refreshLayer {
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[(__bridge id)self.firstColor.CGColor,
                             (__bridge id)self.secondColor.CGColor];
    if (_needBorder) {
        //根据星星宽度计算吧
        gradientLayer.locations = @[@(1-40.f/self.width),@(1.f)];
    }
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint = CGPointMake(1, 1);
    [self.layer addSublayer:gradientLayer];
    
    if (_needBorder) {
        //边框渐变
        for (int i=0; i<2; i++) {
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = CGRectMake(0, i*self.height-(i>0?1:0), self.width, 1);
            gradientLayer.colors = @[(__bridge id)self.bordColor.CGColor,
                                     (__bridge id)self.bordTColor.CGColor];
            gradientLayer.startPoint = CGPointMake(0, 1);
            gradientLayer.endPoint = CGPointMake(1, 1);
            [self.layer addSublayer:gradientLayer];
        }
    }
}

@end
