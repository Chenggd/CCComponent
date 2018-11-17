//
//  CCEvaluateTagInfo.m
//  BeautyBeePro
//
//  Created by Chenggd on 2017/11/19.
//  Copyright © 2017年 Chenggd. All rights reserved.
//

#import "CCEvaluateTagInfo.h"

@implementation CCEvaluateTagInfo

@end

@implementation NSDictionary (returnEvaluateTagInfo)

- (CCEvaluateTagInfo *)returnEvaluateTagInfo {
    CCEvaluateTagInfo *info = [[CCEvaluateTagInfo alloc] init];
    NSArray *allKeys = [NSMutableArray getPropertyList:[CCEvaluateTagInfo class]];
    for (NSString *key in allKeys) {
        if ([CCTool isNotBlank:[self valueForKey:key]]) {
            [info setValue:[self valueForKey:key] forKey:key];
        }
    }
    return info;
};

@end


