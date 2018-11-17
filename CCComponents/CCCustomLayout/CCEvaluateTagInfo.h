//
//  CCEvaluateTagInfo.h
//  BeautyBeePro
//
//  Created by Chenggd on 2017/11/19.
//  Copyright © 2017年 Chenggd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCEvaluateTagInfo : NSObject

@property (nonatomic, assign) BOOL available;
@property (nonatomic, assign) BOOL hasSelected;
@property (nonatomic, assign) NSInteger key;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *titleColor;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) NSString *iconName;

@property (nonatomic, assign) CGFloat txtWidth;

/**
 带数目样式比如：圈币消费（2）
 */
@property (nonatomic, assign) BOOL hasSubNum;

/**
 用于区分展示跟编辑标签 0编辑标签 1正常标签
 */
@property (nonatomic, assign) NSInteger type;

@end

@interface NSDictionary (returnEvaluateTagInfo)

- (CCEvaluateTagInfo *)returnEvaluateTagInfo;

@end
