//
//  CCNIMInfo.m
//  BeautyBeePro
//
//  Created by Chenggd on 2018/1/24.
//  Copyright © 2018年 Chenggd. All rights reserved.
//

#import "CCNIMInfo.h"
#import "CCUserLevealView.h"

@implementation CCNIMInfo

//- (instancetype)initWithRet:(FMResultSet *)resultSet {
//    self = [super init];
//    if (self) {
//        NSDictionary *propertyDic = [self getPropertyDic];
//        for (NSString *key in propertyDic) {
//            if ([key isEqualToString:@"sendInfo"]) {
//                if ([CCTool isNotBlank:[resultSet objectForColumn:key]]) {
//                    NSDictionary *sendDic = [CCTool jsonStringToData:[resultSet objectForColumn:key]];
//                    CCNIMMsgSendInfo *sendInfo = [CCNIMMsgSendInfo mj_objectWithKeyValues:sendDic];
//                    [self setValue:sendInfo forKey:key];
//                }
//            } else if ([key isEqualToString:@"msgInfo"]) {
//                if ([CCTool isNotBlank:[resultSet objectForColumn:key]]) {
//                    NSDictionary *msgDic = [CCTool jsonStringToData:[resultSet objectForColumn:key]];
//                    CCNIMMsgInfo *msgInfo = [CCNIMMsgInfo mj_objectWithKeyValues:msgDic];
//                    [self setValue:msgInfo forKey:key];
//                }
//            } else if (![self needSpecialDealByKey:key resultSet:resultSet]) {
//                NSString *attribute = [propertyDic objectForKey:key];
//                [self normalDealByKey:key attribute:attribute resultSet:resultSet];
//            }
//        }
//        //描述
//        NSDictionary *dic = [CCTool jsonStringToData:self.msgInfo.msgBody];
//        self.msgBodyJsDic = dic;
//    }
//    return self;
//}

//用于系统消息页面样式计算
- (void)setupSystemCellHeight {
    CGFloat orginHeight = 40;
    //校验描述
    if (!self.msgBodyJsDic) {
        self.msgBodyJsDic = [CCTool jsonStringToData:self.msgInfo.msgBody];
    }
    NSDictionary *dic = self.msgBodyJsDic;
    if ([CCTool isNotBlank:dic[@"msg"]]) {
        self.systemContentAttr = [self setUpContetAttStr:dic[@"msg"]];
        float contentMaxWidth = kScreenWidth-60-kLeftSpace-12*2;
        CGSize rect = [CCTool getStringRect:self.systemContentAttr width:contentMaxWidth height:MAXFLOAT];
        self.systemContentHeight = rect.height <20 ?20 :rect.height;
        //上下间隔+箭头
        self.systemContentHeight += 12*2+8;
        orginHeight += self.systemContentHeight;
        //底部间距
        orginHeight += 16;
    }
    //验证默认最小高度（头像+上下间距）
    if (orginHeight < (16*2+34)) {
        orginHeight = 16*2+34;
    }
    [self setSystemHeight:orginHeight];
}

- (NSMutableAttributedString *)setUpContetAttStr:(NSString *)content {
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:content];
    NSRange leftRange = NSMakeRange(0, content.length);
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"38362a"] range:leftRange];
    [attStr addAttribute:NSFontAttributeName value:kHelveticaFont(14) range:leftRange];
    return attStr;
}

//修改版(用于聊天列表)
- (NSMutableAttributedString *)liveChatRecordInfoAttriStr {
    if (!self.msgBodyJsDic) {
        self.msgBodyJsDic = [CCTool jsonStringToData:self.msgInfo.msgBody];
    }
    //校验描述
    NSDictionary *dic = self.msgBodyJsDic;
    NSInteger type = [self.msgInfo.type integerValue];
    NSString *nameStr = [CCTool isNotBlank:dic[@"nickname"]] ?[NSString stringWithFormat:@"%@",dic[@"nickname"]] :@"";
    NSString *contentStr = [CCTool isNotBlank:dic[@"content"]] ?dic[@"content"] :@"";
    NSString *midStr = @"";
    NSString *fullStr = @"";
    NSInteger role_id = [dic[@"role_id"] integerValue];
    NSRange nameRange = NSMakeRange(0, 0);
    NSMutableAttributedString *attStr = nil;
    if (type == CC_MESSAGE_LIVE_DANMAKU) {
        if ([dic[@"msg_type"] integerValue] == 0) { //普通聊天弹幕
            //是否为@ta消息体
            if ([dic[@"atto_uid"] integerValue] > 0 &&
                [CCTool isNotBlank:dic[@"atto_nickname"]]) {
                nameStr = [NSString stringWithFormat:@" %@: ",nameStr];
                midStr = [NSString stringWithFormat:@"@%@ ",dic[@"atto_nickname"]];
                fullStr = [NSString stringWithFormat:@"%@%@%@",nameStr,midStr,contentStr];
                attStr = [[NSMutableAttributedString alloc] initWithString:fullStr];
                nameRange = NSMakeRange(0, nameStr.length);
                [self addTapActionByNameRange:nameRange attStr:attStr];
                NSRange midRange = NSMakeRange(nameStr.length, midStr.length);
                [attStr yy_setColor:[UIColor colorWithHexString:@"ffd500"] range:midRange];
                NSRange contentRange = NSMakeRange(midRange.location+midRange.length, contentStr.length);
                [attStr yy_setColor:[UIColor colorWithHexString:@"ffffff"] range:contentRange];
                [attStr yy_setFont:kHelveticaFont(13) range:(NSRange){0,fullStr.length}];
            } else {
                nameStr = [NSString stringWithFormat:@" %@: ",nameStr];
                fullStr = [NSString stringWithFormat:@"%@%@",nameStr,contentStr];
                attStr = [[NSMutableAttributedString alloc] initWithString:fullStr];
                nameRange = NSMakeRange(0, nameStr.length);
                [self addTapActionByNameRange:nameRange attStr:attStr];
                NSRange contentRange = NSMakeRange(nameStr.length, contentStr.length);
                [attStr yy_setColor:[UIColor colorWithHexString:@"ffffff"] range:contentRange];
                [attStr yy_setFont:kHelveticaFont(13) range:(NSRange){0,fullStr.length}];
            }
            [self addCardMark:attStr role_id:role_id];
        } else { // 2.4新增其他弹幕处理
            attStr = [self normalChat:nameStr contentStr:contentStr role_id:role_id];
        }
    } else if (type == CC_MESSAGE_LIVE_SENDGIFT) {
        midStr = @"送了";
        nameStr = [NSString stringWithFormat:@" %@: ",nameStr];
        fullStr = [NSString stringWithFormat:@"%@%@%@",nameStr,midStr,contentStr];
        attStr = [[NSMutableAttributedString alloc] initWithString:fullStr];
        nameRange = NSMakeRange(0, nameStr.length);
        [self addTapActionByNameRange:nameRange attStr:attStr];
        NSRange midRange = NSMakeRange(nameStr.length, midStr.length);
        [attStr yy_setColor:[UIColor colorWithHexString:@"ffffff"] range:midRange];
        NSRange contentRange = NSMakeRange(midRange.length+midRange.location, contentStr.length);
        [attStr yy_setColor:[UIColor colorWithHexString:@"ffd500"] range:contentRange];
        [attStr yy_setFont:kHelveticaFont(13) range:(NSRange){0,fullStr.length}];
        
        [self addCardMark:attStr role_id:role_id];
    } else if (type == CC_MESSAGE_LIVE_ENTERORLEAVEL) {
        fullStr = [NSString stringWithFormat:@"%@%@",nameStr,contentStr];
        attStr = [[NSMutableAttributedString alloc] initWithString:fullStr];
        //2.4进房消息新增点击事件
        [attStr yy_setTextHighlightRange:(NSRange){0,fullStr.length} color:[UIColor colorWithHexString:@"ffd500" alpha:1] backgroundColor:[UIColor colorWithHexString:@"ffffff" alpha:0.2] tapAction:nil];
        [attStr yy_setFont:kHelveticaFont(13) range:(NSRange){0,fullStr.length}];
    } else if (type == CC_MESSAGE_LIVE_SHARE) {
        attStr = [self normalChat:nameStr contentStr:contentStr role_id:role_id];
    } else if (type == CC_MESSAGE_LIVE_FOCUS) {
        attStr = [self normalChat:nameStr contentStr:contentStr role_id:role_id];
    }
    return attStr;
}

- (void)addCardMark:(NSMutableAttributedString *)attStr role_id:(NSInteger)role_id {
    [self addFansCardView:attStr];
    [self addLevelView:attStr];
    if (role_id == 1) {
        [self addVipView:attStr];
    }
}

- (void)addLevelView:(NSMutableAttributedString *)attStr {
    NSDictionary *dic = [CCTool jsonStringToData:self.msgInfo.msgBody];
    CCUserLevealView *levelView = [CCUserLevealView createF:(CGRect){4,(30-14)/2,30,14} BC:[UIColor colorWithHexString:@"58d0f8"]];
    [levelView reloadLevealData:[NSString stringWithFormat:@"%ld",[dic[@"level"] integerValue]]];
    NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:levelView contentMode:UIViewContentModeScaleToFill attachmentSize:levelView.size alignToFont:kHelveticaFont(12) alignment:YYTextVerticalAlignmentCenter];
    //添加右间隔～～
    [attachment appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    [attStr insertAttributedString:attachment atIndex:0];
}

- (void)addVipView:(NSMutableAttributedString *)attStr {
    YYImage *gifImage = [YYImage imageNamed:@"live_chat_vip.gif"];
    YYAnimatedImageView *animaView = [[YYAnimatedImageView alloc] initWithImage:gifImage];
    [animaView setFrame:(CGRect){0,0,26,14}];
    NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:animaView contentMode:UIViewContentModeScaleToFill attachmentSize:animaView.size alignToFont:kHelveticaFont(12) alignment:YYTextVerticalAlignmentCenter];
    //添加右间隔～～
    [attachment appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    [attStr insertAttributedString:attachment atIndex:0];
}

- (void)addFansCardView:(NSMutableAttributedString *)attStr {
    NSDictionary *fansCardDic = self.msgBodyJsDic[@"medal"];
    NSString *fansCardName = fansCardDic[@"fans_name"];
    NSInteger online_uid = [fansCardDic[@"online_uid"] integerValue];
    NSInteger type = [self.msgInfo.type integerValue];
    //弹幕类型且佩戴勋章
    if (online_uid != 0 && type==CC_MESSAGE_LIVE_DANMAKU) {
        float fansCardWidth = [CCTool getWidth:fansCardName font:kHelveticaFont(10)]+3*2;
        UILabel *fansCardLbl = [UILabel createF:(CGRect){0,0,fansCardWidth,14} TC:[UIColor colorWithHexString:@"ffffff"] FT:kHelveticaFont(10) T:fansCardName AL:NSTextAlignmentCenter];
        fansCardLbl.layer.cornerRadius = 2.f;
        fansCardLbl.layer.masksToBounds = YES;
        [fansCardLbl setBackgroundColor:[UIColor colorWithHexString:@"5c45de"]];
        NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:fansCardLbl contentMode:UIViewContentModeScaleToFill attachmentSize:fansCardLbl.size alignToFont:kHelveticaFont(12) alignment:YYTextVerticalAlignmentCenter];
        [attStr insertAttributedString:attachment atIndex:0];
    }
}

- (void)addTapActionByNameRange:(NSRange)nameRange attStr:(NSMutableAttributedString*)attStr {
    [attStr yy_setTextHighlightRange:nameRange color:[UIColor colorWithHexString:@"36c8f9" alpha:1] backgroundColor:[UIColor colorWithHexString:@"ffffff" alpha:0.2] tapAction:nil];
}

/**
 带名称、等级的 聊天
 */
- (NSMutableAttributedString *)normalChat:(NSString *)nameStr contentStr:(NSString *)contentStr role_id:(NSInteger)role_id {
    //先这样留空前缀吧～～可以根据宽度计算空格多少～
    nameStr = [NSString stringWithFormat:@" %@: ",nameStr];
    NSString *fullStr = [NSString stringWithFormat:@"%@%@",nameStr,contentStr];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:fullStr];
    NSRange nameRange = NSMakeRange(0, nameStr.length);
    [self addTapActionByNameRange:nameRange attStr:attStr];
    NSRange contentRange = NSMakeRange(nameStr.length, contentStr.length);
    [attStr yy_setColor:[UIColor colorWithHexString:@"ffd500"] range:contentRange];
    [attStr yy_setFont:kHelveticaFont(13) range:(NSRange){0,fullStr.length}];
    
    [self addCardMark:attStr role_id:role_id];
    
    return attStr;
}

@end

@implementation NSDictionary (returnCCNIMInfo)

- (CCNIMInfo *)returnCCNIMInfo {
    CCNIMInfo *info = [[CCNIMInfo alloc] init];
    NSArray *allKeys = [NSMutableArray getPropertyList:[CCNIMInfo class]];
    for (NSString *key in allKeys) {
        NSString *relKey = key;
        if ([relKey isEqualToString:@"nimId"]) {
            relKey = @"id";
        } else if ([relKey isEqualToString:@"sendInfo"]) {
            relKey = @"send";
        } else if ([relKey isEqualToString:@"msgInfo"]) {
            relKey = @"msg";
        }
        if ([CCTool isNotBlank:[self valueForKey:relKey]]) {
            if ([relKey isEqualToString:@"send"]) {
                NSDictionary *sendDic = [self valueForKey:relKey];
                if ([sendDic isKindOfClass:[NSDictionary class]]) {
                    CCNIMMsgSendInfo *sendInfo = [sendDic returnNIMMsgSendInfo];
                    [info setSendInfo:sendInfo];
                }
            } else if ([relKey isEqualToString:@"msg"]){
                NSDictionary *msgDic = [self valueForKey:relKey];
                if ([msgDic isKindOfClass:[NSDictionary class]]) {
                    CCNIMMsgInfo *msgInfo = [msgDic returnCCNIMMsgInfo];
                    [info setMsgInfo:msgInfo];
                }
            } else {
                [info setValue:[self valueForKey:relKey] forKey:key];
            }
        }
    }
    if (!info.msgBodyJsDic) { //解析
        info.msgBodyJsDic = [CCTool jsonStringToData:info.msgInfo.msgBody];
    }
    return info;
}

@end


@implementation CCNIMMsgSendInfo

@end

@implementation NSDictionary (returnNIMMsgSendInfo)

- (CCNIMMsgSendInfo *)returnNIMMsgSendInfo {
    CCNIMMsgSendInfo *info = [[CCNIMMsgSendInfo alloc] init];
    NSArray *allKeys = [NSMutableArray getPropertyList:[CCNIMMsgSendInfo class]];
    for (NSString *key in allKeys) {
        NSString *relKey = key;
        if ([relKey isEqualToString:@"sendUid"]) {
            relKey = @"uid";
        }
        if ([CCTool isNotBlank:[self valueForKey:relKey]]) {
            [info setValue:[self valueForKey:relKey] forKey:key];
        }
    }
    return info;
}

@end


@implementation CCNIMMsgInfo

@end

@implementation NSDictionary (returnCCNIMMsgInfo)

- (CCNIMMsgInfo *)returnCCNIMMsgInfo {
    CCNIMMsgInfo *info = [[CCNIMMsgInfo alloc] init];
    NSArray *allKeys = [NSMutableArray getPropertyList:[CCNIMMsgInfo class]];
    for (NSString *key in allKeys) {
        NSString *relKey = key;
        if ([relKey isEqualToString:@"msgId"]) {
            relKey = @"id";
        } else if ([relKey isEqualToString:@"msgBody"]) {
            relKey = @"body";
        }
        if ([CCTool isNotBlank:[self valueForKey:relKey]]) {
            [info setValue:[self valueForKey:relKey] forKey:key];
        }
    }
    return info;
}

@end

