//
//  CCRoomMarkView.h
//  BeautyBeePro
//
//  Created by Chenggd on 2018/1/9.
//  Copyright © 2018年 Chenggd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCEvaluateTagInfo.h"

//更新frame
typedef void(^updateFrameComplete) (CGFloat curHeight);
typedef void(^tapMarkAction) (NSInteger type, CCEvaluateTagInfo *info);

/**
 房间标签
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
