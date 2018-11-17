//
//  CCDanmuGiftInfo.h
//  CCCustomComponent
//
//  Created by Dong on 2018/5/14.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCDanmuGiftInfo : NSObject<NSMutableCopying>

//弹幕Id
@property (nonatomic, assign) NSInteger danmu_id;
//礼物ID
@property (nonatomic, assign) NSInteger gift_id;
//礼物名称
@property (nonatomic, strong) NSString *gift_name;
//礼物数量
@property (nonatomic, assign) NSInteger gift_number;
//时间 yyyy-MM-dd HH:mm:ss
@property (nonatomic, strong) NSString *time;
//赠送用户UID
@property (nonatomic, strong) NSString *from_uid;
//赠送用户昵称
@property (nonatomic, strong) NSString *from_nickname;
//收礼用户UID
@property (nonatomic, strong) NSString *to_uid;
//收礼用户昵称
@property (nonatomic, strong) NSString *to_nickname;
//内容
@property (nonatomic, strong) NSString *content;
//头像
@property (nonatomic, strong) NSString *avartar;

//2.4新增用于直播间跳转
@property (nonatomic, strong) NSString *rtmpUrl;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *bgColor;

@end
