//
//  CCAlertButtonInfo.m
//  CCAssistant
//
//  Created by Cheng on 2017/6/15.
//  Copyright © 2017年 Cheng. All rights reserved.
//

#import "CCAlertButtonInfo.h"

@implementation CCAlertButtonInfo

+ (instancetype)creatButtonModelByDic:(NSDictionary *)dic {
    CCAlertButtonInfo *item = [[CCAlertButtonInfo alloc]init];
    [item setIsCloseButton:[dic[@"title"] boolValue]];
    [item setIsTextBold:[dic[@"isTextBold"] boolValue]];
    [item setButtonTag:[dic[@"buttonTag"] integerValue]];
    [item setTextFontSize:[dic[@"textFontSize"] integerValue]];
    [item setText:dic[@"text"]];
    [item setTextColor:dic[@"textColor"]];
    [item setTextJumpUrl:dic[@"textJumpUrl"]];
    
    [item setWarnStatus:[dic[@"warnStatus"] boolValue]];
    [item setHasSubStatus:[dic[@"hasSubStatus"] boolValue]];
    [item setSubTitle:dic[@"subTitle"]];
    
    return item;
}

@end
