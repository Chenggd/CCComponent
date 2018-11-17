//
//  CCMyCollectInfo.h
//  CCCustomComponent
//
//  Created by Chenggd on 2018/9/26.
//  Copyright © 2018 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCMyCollectInfo : NSObject

//用户UID
@property (nonatomic, assign) NSInteger uid;
//0.分享 1.讨论  (0:文字 1:图文 2:视频文字)
@property (nonatomic, assign) NSInteger type;
//点赞数
@property (nonatomic, assign) NSInteger praises;
//分享ID
@property (nonatomic, strong) NSString *object_id;
//昵称
@property (nonatomic, strong) NSString *nickname;
//头像地址
@property (nonatomic, strong) NSString *avatar;
//标题
@property (nonatomic, strong) NSString *content;
//封面图片
@property (nonatomic, strong) NSString *pic;
//时间
@property (nonatomic, strong) NSString *dateline;
//资源长宽
@property (nonatomic, strong) NSDictionary *size;

#pragma mark - 给个人主页分享列表用
//标题
@property (nonatomic, strong) NSString *title;
//分享ID
@property (nonatomic, strong) NSString *share_id;

//0:收藏 1:圈子分享 （可以传一个cell宽度，用于计算，目前写死）
@property (nonatomic, assign) NSInteger style;
//封面高度
@property (nonatomic, assign) CGFloat coverHeight;
//总高度
@property (nonatomic, assign) CGFloat cellHeight;
//内容高度 最大2行or没有内容则不展示
@property (nonatomic, assign) CGFloat contentHeight;

@end

NS_ASSUME_NONNULL_END
