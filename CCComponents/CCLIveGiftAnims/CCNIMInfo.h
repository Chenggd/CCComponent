//
//  CCNIMInfo.h
//  BeautyBeePro
//
//  Created by Chenggd on 2018/1/24.
//  Copyright © 2018年 Chenggd. All rights reserved.
//

#import "CCBaseInfo.h"
#import "FMResultSet.h"
#import <MJExtension.h>
#import <YYText.h>

#pragma mark - msgSendInfo
@interface CCNIMMsgSendInfo : CCBaseInfo

@property (nonatomic, strong) NSString *sendUid;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *role_id;
@property (nonatomic, strong) NSString *user_type;

@end

@interface NSDictionary (returnNIMMsgSendInfo)

- (CCNIMMsgSendInfo *)returnNIMMsgSendInfo;

@end

#pragma mark - msgInfo
@interface CCNIMMsgInfo : CCBaseInfo

@property (nonatomic, strong) NSString *msgId;
@property (nonatomic, strong) NSString *msgBody;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *image;

@end

@interface NSDictionary (returnCCNIMMsgInfo)

- (CCNIMMsgInfo *)returnCCNIMMsgInfo;

@end

#pragma mark - nimInfo

@interface CCNIMInfo : CCBaseInfo

@property (nonatomic, strong) NSString *nimId;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *dateline;
@property (nonatomic, assign) NSInteger showTime;
@property (nonatomic, strong) CCNIMMsgSendInfo *sendInfo;
@property (nonatomic, strong) CCNIMMsgInfo *msgInfo;
@property (nonatomic, assign) BOOL isRead;

//以下不会存储，每次即调即用
@property (nonatomic, assign) CGFloat liveChatHeight;
@property (nonatomic, assign) CGFloat liveChatWidth;
@property (nonatomic, strong) YYTextLayout *textLayout;
//去除多次解析
@property (nonatomic, strong) NSDictionary *msgBodyJsDic;
//用于系统通知样式
@property (nonatomic, strong) NSMutableAttributedString *systemContentAttr;
//用于系统通知样式计算
@property (nonatomic, assign) CGFloat systemContentHeight;
//用于系统通知样式计算
@property (nonatomic, assign) CGFloat systemHeight;

// 将数据库中的查询分离出来
- (instancetype)initWithRet:(FMResultSet *)resultSet;
- (NSMutableAttributedString *)liveChatRecordInfoAttriStr;
- (void)setupSystemCellHeight;

@end

@interface NSDictionary (returnCCNIMInfo)

- (CCNIMInfo *)returnCCNIMInfo;

@end



