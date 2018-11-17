//
//  CCTool.h
//  CCDemo
//
//  Created by Chenggd on 2018/11/17.
//  Copyright © 2018 Chenggd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCTool : NSObject

+ (BOOL)isNotBlank:(id)obj;

+ (float )getTextHeight:(NSString *)text linebreakMode:(NSLineBreakMode)linebreakMode font:(UIFont *)font width:(float)width;

+ (float)getWidth:(NSString *)text font:(UIFont *)font;

+ (CGSize)getStringRect:(NSAttributedString *)aString width:(CGFloat)width height:(CGFloat)height;

// 验证保留两位小数点的金额
+ (BOOL)validateMoney:(NSString *)money;

// 保留1位小数点
+ (NSString *)transformExtremeByNum:(NSInteger)orginNum;

@end

NS_ASSUME_NONNULL_END
