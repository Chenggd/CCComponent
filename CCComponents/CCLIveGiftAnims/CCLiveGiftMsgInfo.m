//
//  CCLiveGiftMsgInfo.m
//  BeautyBeeTravel
//
//  Created by Dong on 2018/6/8.
//  Copyright © 2018年 圈播. All rights reserved.
//

#import "CCLiveGiftMsgInfo.h"

@implementation CCLiveGiftMsgInfo

+ (CCLiveGiftMsgInfo *)liveGiftMsgInfoByNimMsgInfo:(CCNIMInfo *)nimInfo msgBody:(NSDictionary *)msgBody {
    CCLiveGiftMsgInfo *info = [CCLiveGiftMsgInfo new];
    info.senderAvatar = msgBody[@"avatar"];
    info.senderName = msgBody[@"nickname"];
    info.giftIcon = msgBody[@"icon"];
    info.gift_number = [msgBody[@"number"] integerValue];
    info.giftText = msgBody[@"txt"];
    info.giftId = [msgBody[@"gift_id"] integerValue];
//    info.giftName = msgBody[@"gift_name"];
    info.model = [msgBody[@"mode"] integerValue];
    return info;
}

#pragma mark - NSMutableCopying
- (id)mutableCopyWithZone:(NSZone *)zone{
    CCLiveGiftMsgInfo *info = [[CCLiveGiftMsgInfo alloc]init];
    NSArray *allKeys = [NSMutableArray getPropertyList:[CCLiveGiftMsgInfo class]];
    for (NSString *key in allKeys) {
        if ([CCTool isNotBlank:[self valueForKey:key]]) {
            [info setValue:[self valueForKey:key] forKey:key];
        }
    }
    return info;
}

@end
