//
//  CCTool.m
//  CCDemo
//
//  Created by Chenggd on 2018/11/17.
//  Copyright © 2018 Chenggd. All rights reserved.
//

#import "CCTool.h"

@implementation CCTool

/**
 判断对象是否不空

 @param obj 要判断的对象
 @return 是否不空
 */
+ (BOOL)isNotBlank:(id)obj {
    if (!obj || [obj isKindOfClass:[NSNull class]] ||
        ([obj isKindOfClass:[NSString class]] && [obj isEqualToString:@""]) ||
        ([obj isKindOfClass:[NSString class]] && [obj isEqualToString:@"(null)"])||
        ([obj isKindOfClass:[NSString class]] && [obj isEqualToString:@"<null>"])
        ) {
        return NO;
    }
    return YES;
}

/**
 限制一定宽度得到高度
 */
+ (float)getTextHeight:(NSString *)text linebreakMode:(NSLineBreakMode)linebreakMode font:(UIFont *)font width:(float)width {
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          font, NSFontAttributeName,
                                          nil];
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil].size;
    return ceilf(size.height);
}

/**
 限制一定高度得到宽度
 */
+ (float)getWidth:(NSString *)text font:(UIFont *)font {
    if ([CCTool isNotBlank:text]) {
        return [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]].width;
    }
    return 0;
}

/**
 根据NSAttributedString获取size
 */
+ (CGSize)getStringRect:(NSAttributedString *)aString width:(CGFloat)width height:(CGFloat)height {
    NSMutableAttributedString *atrString = [[NSMutableAttributedString alloc] initWithAttributedString:aString];
    NSRange range = NSMakeRange(0, atrString.length);
    NSMutableDictionary *attDic = @{}.mutableCopy;
    NSDictionary *dic = nil;
    if (range.length) {
        //获取指定位置上的属性信息，并返回与指定位置属性相同并且连续的字符串的范围信息。
        dic = [atrString attributesAtIndex:0 effectiveRange:&range];
        attDic = dic.mutableCopy;
    }
    //不存在段落属性，则存入默认值
    NSMutableParagraphStyle *paragraphStyle = dic[NSParagraphStyleAttributeName];
    if (!paragraphStyle || nil == paragraphStyle) {
        paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineSpacing = 2;//增加行高
        paragraphStyle.headIndent = 0;//头部缩进，相当于左padding
        paragraphStyle.tailIndent = 0;//相当于右padding
        paragraphStyle.lineHeightMultiple = 0;//行间距是多少倍
        paragraphStyle.alignment = NSTextAlignmentLeft;//对齐方式
        paragraphStyle.firstLineHeadIndent = 0;//首行头缩进
        paragraphStyle.paragraphSpacing = 0;//段落后面的间距
        paragraphStyle.paragraphSpacingBefore = 0;//段落之前的间距
        [atrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    }
    //设置默认字体属性
    UIFont *font = dic[NSFontAttributeName];
    if (!font || nil == font) {
        font = kHelveticaFont(12);
        [atrString addAttribute:NSFontAttributeName value:font range:range];
    }
    [attDic setObject:font forKey:NSFontAttributeName];
    [attDic setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    CGSize strSize = [[aString string] boundingRectWithSize:CGSizeMake(width, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attDic context:nil].size;
    return CGSizeMake(ceilf(strSize.width), ceilf(strSize.height));
}

+ (BOOL)validateMoney:(NSString *)money {
    NSString *moneyRegex = @"(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,9}(([.]\\d{0,2})?)))?";
    NSPredicate *moneyPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",moneyRegex];
    return [moneyPre evaluateWithObject:money];
}

// 保留1位小数点
+ (NSString *)transformExtremeByNum:(NSInteger)orginNum {
    NSString *transformStr = @"";
    if (orginNum>9999) {
        transformStr = [NSString stringWithFormat:@"%.1fw",orginNum/10000.f];
    } else {
        transformStr = [NSString stringWithFormat:@"%ld",orginNum];
    }
    return transformStr;
}


/**
 json字符串转字典或者数组
 */
+ (id)jsonStringToData:(NSString *)str {
    if ([CCTool isNotBlank:str]) {
        NSData *strData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:strData options:NSJSONReadingAllowFragments error:&error];
        if (jsonObject != nil && error == nil){
            return jsonObject;
        }
    }
    return nil;
}

/**
 字典或者数组转json字符串
 */
+ (NSString*)dataToJsonString:(id)object {
    NSString *jsonString = nil;
    NSError *error;
    if (object) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:kNilOptions error:&error];
        if ([CCTool isNotBlank:jsonData]) {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        } else {
            NSLog(@"Got an error: %@", error);
        }
    }
    return jsonString;
}

@end
