//
//  CCRoomMarkView.h
//  BeautyBeePro
//
//  Created by Chenggd on 2018/1/9.
//  Copyright © 2018年 Chenggd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCEvaluateTagInfo.h"

/**
 需要优化为可配置选项便于适配不同业务，目前为定义了一些常用业务
 （可配元素：带icon，带add按钮，文字大小、颜色，背景颜色，左/右对齐布局，间距等）
 */
typedef NS_ENUM(NSInteger, CCSMarkType) {   //标签类型
    CCRoomMarkType = 1,                     //房间
    CCRoomEditorMarkType = 2,               //房间编辑
    CCSVEditorMarkType = 3,                 //小视频编辑
    CCSVMarkType = 4,                       //小视频
    CCNormalMarkType = 5,                   //其他(无图)
    CCSearchMarkType = 6                    //搜索文字(无图)
};

//更新frame
typedef void(^updateFrameComplete) (CGFloat curHeight);
typedef void(^tapMarkAction) (NSInteger type, CCEvaluateTagInfo *info);

/**
 左对齐布局标签
 */
@interface CCRoomMarkView : UICollectionView

@property (nonatomic, strong) NSMutableArray *tagInfos;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) float itemHeight;
@property (nonatomic, assign) float itemSpace;
@property (nonatomic, copy) updateFrameComplete updateFrameComplete;
@property (nonatomic, copy) tapMarkAction tapAction;

- (instancetype)initWithFrame:(CGRect)frame style:(CCSMarkType)style;
- (void)addNewTag:(NSString *)title;
- (NSString *)tagListForStr;

@end
