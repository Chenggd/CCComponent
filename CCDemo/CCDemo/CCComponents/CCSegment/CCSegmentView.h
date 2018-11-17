//
//  CCSegmentView.h
//  BeautyBeePro
//
//  Created by Chenggd on 2018/1/30.
//  Copyright © 2018年 Chenggd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickItemBlock) (NSInteger index);

@interface CCSegmentView : UIView

@property (nonatomic, assign) float itemWidth;
@property (nonatomic, assign) float itemHeight;
@property (nonatomic, assign) float itemFont;
@property (nonatomic, assign) float itemSelectFont;
@property (nonatomic, assign) float lineWidth;
@property (nonatomic, assign) float lineHeight;
@property (nonatomic, assign) float lineSpaceForBottom;
@property (nonatomic, strong) UIColor *itemColor;
@property (nonatomic, strong) UIColor *itemSelectColor;
@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, weak) NSArray *items;
@property (nonatomic, assign) BOOL needChange;
@property (nonatomic, copy) clickItemBlock clickItemBlock;

@property (nonatomic, assign) BOOL hasBottomLine;

//用于文字颜色渐变
@property (nonatomic, assign) BOOL colorTransition; //默认开启
/** 外部滚动视图 （#warning 若使用文字渐变则必须设定）*/
@property (nonatomic, weak) UIScrollView *outScrollView;

/**
 创建菜单选择器
 @param items 数据源
 @param style 0:下划线在中间 1:下划线在底部
 @return self
 */
- (instancetype)initWithItems:(NSArray *)items style:(NSInteger)style;
- (void)selectSegmentIndex:(NSInteger)index;
- (void)refreshBadgeForIndex:(NSInteger)index;

@end
