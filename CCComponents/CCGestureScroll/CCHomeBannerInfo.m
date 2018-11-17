//
//  CCHomeBannerInfo.m
//  CCCommunity
//
//  Created by Chenggd on 2017/9/16.
//  Copyright © 2017年 Cheng. All rights reserved.
//

#import "CCHomeBannerInfo.h"

@implementation CCHomeBannerInfo

@end

@implementation NSDictionary (returnBannerInfo)

- (CCHomeBannerInfo *)returnBannerInfo {
    CCHomeBannerInfo *info = [[CCHomeBannerInfo alloc] init];
    NSArray *allKeys = [NSMutableArray getPropertyList:[CCHomeBannerInfo class]];
    for (NSString *key in allKeys) {
        if ([key isEqualToString:@"bannerId"]) {
            [info setValue:[CCTool isNotBlank:[self valueForKey:@"id"]] ?[self valueForKey:@"id"] :@"" forKey:key];
        } else if ([key isEqualToString:@"imgUrl"]) {
            [info setValue:[CCTool isNotBlank:[self valueForKey:@"image"]] ?[self valueForKey:@"image"] :@"" forKey:key];
        } else if ([key isEqualToString:@"linkUrl"]) {
            [info setValue:[CCTool isNotBlank:[self valueForKey:@"parameters"]] ?[self valueForKey:@"parameters"] :@"" forKey:key];
        } else if ([key isEqualToString:@"type"]) {
            [info setValue:[CCTool isNotBlank:[self valueForKey:@"type"]] ?[self valueForKey:@"type"] :@"" forKey:key];
        } else if ([key isEqualToString:@"sort"]) {
            [info setValue:[CCTool isNotBlank:[self valueForKey:@"sort"]] ?[self valueForKey:@"sort"] :@"" forKey:key];
        }
    }
    return info;
}

@end

