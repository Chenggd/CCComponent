//
//  NSMutableString+CCMutableString.m
//  CCCustomComponent
//
//  Created by Dong on 2018/9/7.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import "NSMutableString+CCMutableString.h"

@implementation NSMutableString (CCMutableString)

#pragma mark - safe
- (void)CCappendString:(NSString *)aString{
    if (!aString) {
        [self logWarning:@"appendString: ==> aString is nil"];
        return;
    }
    [self CCappendString:aString];
}

- (void)CCappendFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2){
    if (!format) {
        [self logWarning:@"appendFormat: ==> aString is nil"];
        return;
    }
    va_list arguments;
    va_start(arguments, format);
    NSString *formatStr = [[NSString alloc]initWithFormat:format arguments:arguments];
    [self CCappendFormat:@"%@",formatStr];
    va_end(arguments);
}

- (void)CCsetString:(NSString *)aString{
    if (!aString) {
        [self logWarning:@"setString: ==> aString is nil"];
        return;
    }
    [self CCsetString:aString];
}

- (void)CCinsertString:(NSString *)aString atIndex:(NSUInteger)index{
    if (index > [self length]) {
        [self logWarning:[@"insertString:atIndex: ==>" stringByAppendingFormat:@"index[%ld] >= length[%ld]",(long)index ,(long)[self length]]];
        return;
    }
    if (!aString) {
        [self logWarning:@"insertString:atIndex: ==> aString is nil"];
        return;
    }
    
    [self CCinsertString:aString atIndex:index];
}

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [self swizzleMethod:@selector(CCappendString:) tarClass:@"__NSCFConstantString" tarSel:@selector(appendString:)];
            [self swizzleMethod:@selector(CCappendFormat:) tarClass:@"__NSCFConstantString" tarSel:@selector(appendFormat:)];
            [self swizzleMethod:@selector(CCsetString:) tarClass:@"__NSCFConstantString" tarSel:@selector(setString:)];
            [self swizzleMethod:@selector(CCinsertString:atIndex:) tarClass:@"__NSCFConstantString" tarSel:@selector(insertString:atIndex:)];
        }
    });
}

@end
