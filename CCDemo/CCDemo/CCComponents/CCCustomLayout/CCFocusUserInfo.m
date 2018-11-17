//
//  CCFocusUserInfo.m
//  Dong
//
//  Created by Dong on 2018/4/12.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import "CCFocusUserInfo.h"

@implementation CCFocusUserInfo

@end


@implementation NSDictionary (returnFocusUserInfo)

- (CCFocusUserInfo *)returnFocusUserInfo {
    CCFocusUserInfo *info = [[CCFocusUserInfo alloc] init];
    NSArray *allKeys = [NSMutableArray getPropertyList:[CCFocusUserInfo class]];
    for (NSString *key in allKeys) {
        if ([CCTool isNotBlank:[self valueForKey:key]]) {
            [info setValue:[self valueForKey:key] forKey:key];
        }
    }
    return info;
}

@end
