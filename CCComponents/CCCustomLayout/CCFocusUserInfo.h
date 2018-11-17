//
//  CCFocusUserInfo.h
//  Dong
//
//  Created by Dong on 2018/4/12.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCFocusUserInfo : NSObject

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger user_type;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, assign) NSInteger follow_status;
@property (nonatomic, assign) NSInteger live_status;
@property (nonatomic, assign) NSInteger credits;
@property (nonatomic, assign) BOOL is_note;
//1.0版本
@property (nonatomic, assign) BOOL is_follow;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, assign) NSInteger praises;
@property (nonatomic, assign) NSInteger fans;
@property (nonatomic, assign) NSInteger follows;
//2.1新增加V
@property (nonatomic, assign) BOOL is_v;
//推流地址
@property (nonatomic, strong) NSString *rtmp;

@end

@interface NSDictionary (returnFocusUserInfo)

- (CCFocusUserInfo *)returnFocusUserInfo;

@end
