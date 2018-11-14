//
//  CCHexColor.h
//  CCComponent
//
//  Created by Cheng on 2017/3/7.
//  Copyright © 2017年 Cheng. All rights reserved.
//



#import <UIKit/UIKit.h>
#define HXColor UIColor

@interface HXColor (HexColorAddition)

+ (HXColor *)colorWithHexString:(NSString *)hexString;
+ (HXColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

+ (HXColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;
+ (HXColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

@end
