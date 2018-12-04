//
//  CCFlexibleLayout.h
//  CCCustomComponent
//
//  Created by Chenggd on 2018/9/21.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CCFlexibleDataSource <NSObject>

//控制对应section的瀑布流列数
- (NSInteger)numberOfColsInSection:(NSInteger)section;
//控制每个cell的尺寸，实际上就是获取宽高比
- (CGSize)sizeOfItemAtIndexPath:(NSIndexPath *)indexPath;
//控制瀑布流cell的间距
- (CGFloat)spaceOfCells:(NSInteger)section;
//内边距
- (UIEdgeInsets)sectionInsets:(NSInteger)section;
//每个section的header尺寸
- (CGSize)sizeOfHeader:(NSInteger)section;
//每个cell的额外高度
- (CGFloat)heightOfAdditionalContent:(NSIndexPath *)indexPath;

@end

/**
 主要用于卡片布局中宽度一致样式（待扩展）
 */
@interface CCFlexibleLayout : UICollectionViewLayout

@property (nonatomic, weak) id<CCFlexibleDataSource>dataSource;
@property (nonatomic, strong, nullable) UIView *collectionHeaderView;

//指定内容最小高度
@property (nonatomic, assign) CGFloat contentMinHeight;

@end

NS_ASSUME_NONNULL_END
