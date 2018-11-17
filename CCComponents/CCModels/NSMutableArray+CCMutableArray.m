//
//  NSMutableArray+CCMutableArray.m
//  CCPro
//
//  Created by Dong on 15-8-14.
//  Copyright (c) 2016年 Dong. All rights reserved.
//

#import "NSMutableArray+CCMutableArray.h"
#import <objc/runtime.h>
#import "NSObject+CCObject.h"

@implementation NSMutableArray (CCMutableArray)

+ (NSMutableArray *)getPropertyList:(Class)className {
    NSMutableArray *mutableArr = [NSMutableArray array];
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList(className, &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        [mutableArr addObject:[NSString stringWithUTF8String:property_getName(property)]];
    }
    
    free(properties);
    return mutableArr;
}

#pragma mark - safe
- (id)CCobjectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        [self logWarning:[@"objectAtIndex: array bounds ==>" stringByAppendingFormat:@"index[%ld] >= count[%ld]",(long)index ,(long)[self count]]];
        return nil;
    }
    return [self CCobjectAtIndex:index];
}

- (void)CCaddObject:(id)anObject {
    if (!anObject) {
        [self logWarning:@"addObject: ==> object is nil"];
        return;
    }
    [self CCaddObject:anObject];
}

- (void)CCinsertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index > [self count]) {
        [self logWarning:[@"insertObject:atIndex: array bounds ==>" stringByAppendingFormat:@"index[%ld] >= count[%ld]",(long)index ,(long)[self count]]];
        return;
    }
    
    if (!anObject) {
        [self logWarning:@"insertObject:atIndex: ==> object is nil"];
        return;
    }
    
    [self CCinsertObject:anObject atIndex:index];
}

- (void)CCremoveObjectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        [self logWarning:[@"removeObjectAtIndex: array bounds ==>" stringByAppendingFormat:@"index[%ld] >= count[%ld]",(long)index ,(long)[self count]]];
        return;
    }
    
    return [self CCremoveObjectAtIndex:index];
}

- (void)CCreplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (index >= [self count]) {
        [self logWarning:[@"replaceObjectAtIndex:withObject: array bounds ==>" stringByAppendingFormat:@"index[%ld] >= count[%ld]",(long)index ,(long)[self count]]];
        return;
    }
    
    if (!anObject) {
        [self logWarning:@"replaceObjectAtIndex:withObject: ==> object is nil"];
        return;
    }
    
    [self CCreplaceObjectAtIndex:index withObject:anObject];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        @autoreleasepool {
//            [self swizzleMethod:@selector(CCobjectAtIndex:) tarClass:@"__NSArrayM" tarSel:@selector(objectAtIndex:)];
            [self swizzleMethod:@selector(CCaddObject:) tarClass:@"__NSArrayM" tarSel:@selector(addObject:)];
            [self swizzleMethod:@selector(CCinsertObject:atIndex:) tarClass:@"__NSArrayM" tarSel:@selector(insertObject:atIndex:)];
            [self swizzleMethod:@selector(CCremoveObjectAtIndex:) tarClass:@"__NSArrayM" tarSel:@selector(removeObjectAtIndex:)];
            [self swizzleMethod:@selector(CCreplaceObjectAtIndex:withObject:) tarClass:@"__NSArrayM" tarSel:@selector(replaceObjectAtIndex:withObject:)];
        }
    });
}

@end
