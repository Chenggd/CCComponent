//
//  CCBaseListTab.h
//  BeautyBeePro
//
//  Created by Chenggd on 2018/1/4.
//  Copyright © 2018年 Chenggd. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 刷新头部关注用户数据
 */
typedef void (^refreshHeadBlock)(NSMutableArray *headArray);

@interface CCBaseListTab : UITableView

@property (nonatomic, assign) BOOL needLoad;
@property (nonatomic, assign) NSInteger sortNum;
@property (nonatomic, assign) NSInteger startrow;
@property (nonatomic, assign) NSInteger endrow;
@property (nonatomic, assign) NSInteger loadRow;
@property (nonatomic, strong) NSMutableArray *listData;

/**
 用于开启嵌套监听
 */
@property (nonatomic, assign) BOOL openNestedHook;

- (void)desposeRefreshStatus;
- (void)checkNewUpdateMsg;
- (void)clearOldData;

/**
 最小内容高度，用于显示空态
 */
@property (nonatomic, assign) CGFloat minContentHeight;
@property (nonatomic, strong) UIView *emptyDefaultView;
@property (nonatomic, copy) refreshHeadBlock refreshHeadBlock;

@end
