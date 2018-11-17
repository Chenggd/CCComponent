//
//  CCLiveGiftMsgInfo.h
//  BeautyBeeTravel
//
//  Created by Dong on 2018/6/8.
//  Copyright © 2018年 圈播. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCLiveGiftMsgInfo : NSObject

@property (nonatomic, strong) NSString *senderAvatar;
@property (nonatomic, strong) NSString *senderName;
@property (nonatomic, strong) NSString *giftIcon;
@property (nonatomic, strong) NSString *giftName;
@property (nonatomic, assign) NSInteger giftId;
@property (nonatomic, assign) NSInteger to_uid;
@property (nonatomic, assign) NSInteger gift_number;
@property (nonatomic, assign) NSInteger model;
//2.2新增type
@property (nonatomic, strong) NSString *type;

//改为服务端拼接了～～
@property (nonatomic, strong) NSString *giftText;
/**
 根据云新消息转化为对应的礼物弹道展示模型
 @param nimInfo 物弹道展示模型
 */
+ (CCLiveGiftMsgInfo *)liveGiftMsgInfoByNimMsgInfo:(CCNIMInfo *)nimInfo msgBody:(NSDictionary *)msgBody;
    
@end
