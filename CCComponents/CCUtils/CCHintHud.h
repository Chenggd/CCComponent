//
//  CCHintManager.h
//  BeautyBeePro
//
//  Created by Cheng on 2017/11/7.
//  Copyright © 2017年 Chenggd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^hintTapAciton)();
typedef void(^dissmissHudBlock)();

/**
 顶部信息提示（适用条件比较特殊）
 */
@interface CCHintHud : UIView

@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) UIColor *msgColor;
@property (nonatomic, assign) NSTextAlignment msgAlignment;
@property (nonatomic, strong) UIFont *msgFont;
@property (nonatomic, assign) BOOL onSuperView;
@property (nonatomic, assign) BOOL autoHide;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, strong) NSString *msgHintTitle;
@property (nonatomic, assign) BOOL showStatus;
@property (nonatomic, copy) dissmissHudBlock dissmissHudBlock;
@property (nonatomic, copy) hintTapAciton hintTapAciton;
@property (nonatomic, assign) BOOL hasArrow;

+ (instancetype)creatCCHintHudOrgin:(CGPoint)orgin;
- (void)showView:(UIView *)view autoHide:(BOOL)autoHide;
- (void)hideView:(UIView *)view after:(NSTimeInterval)after;

//废弃了～～
+ (instancetype)creatHintInView:(UIView *)view msg:(NSString *)msg orgin:(CGPoint)orgin autoHide:(BOOL)autoHide duration:(NSTimeInterval)duration onSuperView:(BOOL)onSuperView tapAction:(hintTapAciton)tapAction;
- (void)refreshTitle:(NSString *)title;
//～～～～～

@end
