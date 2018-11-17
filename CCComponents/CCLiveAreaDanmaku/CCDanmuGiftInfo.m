//
//  CCDanmuGiftInfo.m
//  CCCustomComponent
//
//  Created by Dong on 2018/5/14.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import "CCDanmuGiftInfo.h"

@implementation CCDanmuGiftInfo

#pragma mark - NSMutableCopying
- (id)mutableCopyWithZone:(NSZone *)zone{
    CCDanmuGiftInfo *info = [[CCDanmuGiftInfo alloc]init];
    NSArray *allKeys = [NSMutableArray getPropertyList:[CCDanmuGiftInfo class]];
    for (NSString *key in allKeys) {
        if ([CCTool isNotBlank:[self valueForKey:key]]) {
            [info setValue:[self valueForKey:key] forKey:key];
        }
    }
    return info;
}

@end
