//
//  CCAlertButtonInfo.h
//  CCAssistant
//
//  Created by Cheng on 2017/6/15.
//  Copyright © 2017年 Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCAlertButtonInfo : NSObject

@property (nonatomic, assign) BOOL isCloseButton;
@property (nonatomic, assign) BOOL isTextBold; //加粗
@property (nonatomic, assign) NSInteger buttonTag;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *textColor;
@property (nonatomic, strong) NSString *textJumpUrl;
@property (nonatomic, assign) NSInteger textFontSize;
@property (nonatomic, strong) NSString *subText; //新增份额子字段
@property (nonatomic, strong) NSString *shareId; //新增份额id
@property (nonatomic, assign) BOOL hasSubStatus; //按钮是否含有副标题文案
@property (nonatomic, assign) BOOL warnStatus; //警示操作标示
@property (nonatomic, strong) NSString *subTitle; //副标题文案

+ (instancetype)creatButtonModelByDic:(NSDictionary *)dic;

@end
