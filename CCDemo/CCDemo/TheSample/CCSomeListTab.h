//
//  CCSomeListTab.h
//  CCDemo
//
//  Created by Chenggd on 2018/12/4.
//  Copyright © 2018 Chenggd. All rights reserved.
//

#import "CCBaseListTab.h"

NS_ASSUME_NONNULL_BEGIN
/**
 结束刷新数据
 */
typedef void (^refreshSomeEnd)();

@interface CCSomeListTab : CCBaseListTab

@property (nonatomic, strong) NSMutableArray *focusArray;
@property (nonatomic, copy) refreshSomeEnd refreshSomeEnd;

@end

NS_ASSUME_NONNULL_END
