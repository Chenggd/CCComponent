//
//  NSObject+CCObject.m
//  CCPro
//
//  Created by Dong on 15-8-14.
//  Copyright (c) 2016年 Dong. All rights reserved.
//

#import "NSObject+CCObject.h"
#import <objc/runtime.h>

@implementation NSObject (CCObject)

#pragma mark - safe
+ (void)swizzleMethod:(SEL)srcSel tarSel:(SEL)tarSel {
    Class clazz = [self class];
    [self swizzleMethod:clazz srcSel:srcSel tarClass:clazz tarSel:tarSel];
}

+ (void)swizzleMethod:(SEL)srcSel tarClass:(NSString *)tarClassName tarSel:(SEL)tarSel {
    if (!tarClassName) {
        return;
    }
    Class srcClass = [self class];
    Class tarClass = NSClassFromString(tarClassName);
    [self swizzleMethod:srcClass srcSel:srcSel tarClass:tarClass tarSel:tarSel];
}

+ (void)swizzleMethod:(Class)srcClass srcSel:(SEL)srcSel tarClass:(Class)tarClass tarSel:(SEL)tarSel {
    if (!srcClass) {
        return;
    }
    if (!srcSel) {
        return;
    }
    if (!tarClass) {
        return;
    }
    if (!tarSel) {
        return;
    }
    
    @try {
        Method srcMethod = class_getInstanceMethod(srcClass,srcSel);
        Method tarMethod = class_getInstanceMethod(tarClass,tarSel);
        method_exchangeImplementations(srcMethod, tarMethod);
    } @catch (NSException *exception) {
        NSString *exceptionStr = [self formatExceptionToString:exception withReason:nil];
        NSLog(@"%@", exceptionStr);
    } @finally {
        
    }
}

- (NSString *)formatExceptionToString:(NSException *)exception withReason:(NSString *)reasonStr{
    NSArray *arr = [exception callStackSymbols];
    NSString *reasonText = nil;
    if (reasonStr) {
        reasonText = reasonStr;
    }else{
        reasonText = [exception reason];
    }

    NSString *exceptionDes = [NSString stringWithFormat:@"\n\n%@\nname: %@\ntime: %@\nreason: %@\ncallStackSymbols: \n%@\n%@\n\n",
                              @"=============CCObject Exception Report=============",
                              [exception name],
                              [NSDate date],
                              reasonText,
                              [arr componentsJoinedByString:@"\n"],
                              @"=============CCObject Exception Report end========="];
    
    return exceptionDes;
}

- (void)logWarning:(NSString *)aString {
    @try {
        NSException *e = [NSException exceptionWithName:@"CCExceptionLog" reason:aString userInfo:nil];

        ("%@", [self formatExceptionToString:e withReason:nil]);
#ifndef KCCProReleaseServer
        @throw e;
#endif
    } @catch (NSException *exception) {
        NSString *exceptionStr = [self formatExceptionToString:exception withReason:nil];
        NSLog(@"%@", exceptionStr);
    }
}

- (NSObject *)feedType {
    return objc_getAssociatedObject(self, @selector(feedType));
}

- (void)setFeedType:(NSObject *)value {
    objc_setAssociatedObject(self, @selector(feedType), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
