//
//  NSObject+CCObject.h
//  CCPro
//
//  Created by Dong on 15-8-14.
//  Copyright (c) 2016年 Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CCObject)

@property (nonatomic, strong) NSObject *feedType;

/*
 * To swizzle two selector for self class.
 * @param srcSel source selector
 * @param tarSel target selector
 */
+ (void)swizzleMethod:(SEL)srcSel tarSel:(SEL)tarSel;

/*
 * To swizzle two selector from self class to target class.
 * @param srcSel source selector
 * @param tarClassName target class name string
 * @param tarSel target selector
 */
+ (void)swizzleMethod:(SEL)srcSel tarClass:(NSString *)tarClassName tarSel:(SEL)tarSel;

/*
 * To swizzle two selector from self class to target class.
 * @param srcClass source class
 * @param srcSel source selector
 * @param tarClass target class
 * @param tarSel target selector
 */
+ (void)swizzleMethod:(Class)srcClass srcSel:(SEL)srcSel tarClass:(Class)tarClass tarSel:(SEL)tarSel;

- (void)logWarning:(NSString *)aString;

@end
