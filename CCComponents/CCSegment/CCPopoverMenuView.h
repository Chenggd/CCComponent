//
//  CCPopoverMenuView.h
//  BeautyBeeTravel
//
//  Created by Dong on 2018/5/2.
//  Copyright © 2018年 圈播. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^dismissMenuBlock)(BOOL inside);
typedef void (^tapMenuAction)();

@interface CCPopoverMenuView : UIView

@property (nonatomic, copy) dismissMenuBlock dismissMenuBlock;
@property (nonatomic, copy) tapMenuAction tapMenuAction;

+ (instancetype)creatPopoverMenuText:(NSString *)text hasArrow:(BOOL)hasArrow;
/**
 @param inView 父试图
 @param point 决定箭头的位置
 @param direction 箭头方向
 */
- (void)showPopoverMenuInView:(UIView *)inView point:(CGPoint)point direction:(CCPopoverArrowDirection)direction;
- (void)dismissMenu:(BOOL)inside;

/**
 出现的位置
 @param inView 父视图
 @param fromPoint 起始点
 @param toPoint 结束点
 @param normalDirection 方向
 */
- (void)showPopoverMenuInView:(UIView *)inView fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint normalDirection:(NSInteger)normalDirection;
- (void)dismissNormalMenu:(BOOL)inside;

- (void)refreshText:(NSString *)text;

@end
