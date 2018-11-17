//
//  NSMutableDictionary+CCMutableDictionary.m
//  CCCustomComponent
//
//  Created by Dong on 2018/9/7.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import "NSMutableDictionary+CCMutableDictionary.h"

@implementation NSMutableDictionary (CCMutableDictionary)

#pragma mark - safe
- (void)CCremoveObjectForKey:(id)aKey {
    if (!aKey) {
        [self logWarning:@"removeObjectForKey: ==> key is nil"];
        return;
    }
    [self CCremoveObjectForKey:aKey];
}

- (void)CCsetObject:(id)anObject forKey:(id <NSCopying>)aKey {
    if (!anObject) {
        [self logWarning:@"setObject:forKey: ==> object is nil"];
        return;
    }
    
    if (!aKey) {
        [self logWarning:@"setObject:forKey: ==> key is nil"];
        return;
    }
    [self CCsetObject:anObject forKey:aKey];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [self swizzleMethod:@selector(CCremoveObjectForKey:) tarClass:@"__NSDictionaryM" tarSel:@selector(removeObjectForKey:)];
            [self swizzleMethod:@selector(CCsetObject:forKey:) tarClass:@"__NSDictionaryM" tarSel:@selector(setObject:forKey:)];
        }
    });
}

@end
