//
//  CCFlexibleLayout.m
//  CCCustomComponent
//
//  Created by Chenggd on 2018/9/21.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import "CCFlexibleLayout.h"

//用来储存某一item的的纵坐标
@interface ColItemInfo : NSObject

@property (nonatomic, assign) CGFloat colY;
@property (nonatomic, assign) NSInteger index;

@end

@implementation ColItemInfo

@end

//存储某一列的所有item的位置信息
@interface ColPosition : NSObject

@property (nonatomic, strong) NSMutableArray *colYs;
@property (nonatomic, assign) CGFloat maxY;

@end

@implementation ColPosition

- (CGFloat)maxY {
    //每个section的高度：返回最大值
    NSArray *temArr = [_colYs valueForKeyPath:@"colY"];
    CGFloat maxNum = [[temArr valueForKeyPath:@"@max.floatValue"] floatValue];
    maxNum = MAX(0.f, maxNum);
    return maxNum;
}

@end

@interface CCFlexibleLayout ()

//cell视图
@property (nonatomic, strong) NSMutableDictionary *layoutDict;
//头视图
@property (nonatomic, strong) NSMutableArray *layoutHeaderViewInfo;
//坐标寄存器
@property (nonatomic, strong) NSMutableArray *colHeights;

@end


@implementation CCFlexibleLayout

- (instancetype)init {
    if (self = [super init]) {
        _colHeights = [NSMutableArray arrayWithCapacity:0];
        _layoutHeaderViewInfo = [NSMutableArray arrayWithCapacity:0];
        _layoutDict = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

- (void)layoutInit {
    [_colHeights removeAllObjects];
    [_layoutHeaderViewInfo removeAllObjects];
    [_layoutDict removeAllObjects];
    //    //初始化headerView, Y为0
    //    UIView *headerView = _collectionHeaderView;
    //    if (headerView) {
    //        float headerWidth = headerView.bounds.size.width;
    //        float headerX = (kScreenWidth - headerWidth)/2;
    //        headerView.frame = (CGRect){headerX,0,headerWidth,headerView.height};
    //        [self.collectionView addSubview:headerView];
    //    }
}

- (void)setCollectionHeaderView:(UIView *)collectionHeaderView {
    if (_collectionHeaderView) {
        [_collectionHeaderView removeFromSuperview];
    }
    _collectionHeaderView = collectionHeaderView;
    if (_collectionHeaderView) { //添加头部
        [self.collectionView addSubview:_collectionHeaderView];
    }
    [self.collectionView reloadData];
}

- (void)prepareLayout {
    [super prepareLayout];
    
    //每次reloadData后需要layout
    [self layoutInit];
    NSInteger sectionNum = [self.collectionView numberOfSections];
    for (int section=0; section<sectionNum; section++) {
        //取(前一个section的Y坐标+当前section的高度)为当前section的初始坐标
        float originH = self.collectionHeaderView.height;
        float preSectionH = originH;
        float preSectionInsetBottom = 0;
        float currentSectionHeaderY = preSectionH + preSectionInsetBottom;
        if (section > 0) {
            ColPosition *colPosition = _colHeights[section-1];
            preSectionH = colPosition.maxY;
            preSectionInsetBottom = [_dataSource sectionInsets:section-1].bottom;
            currentSectionHeaderY = preSectionH + preSectionInsetBottom + [_dataSource spaceOfCells:(section-1)];
        }
        CGSize headerSize = [_dataSource sizeOfHeader:section];
        float headerX = (kScreenWidth - headerSize.width)/2;
        float headerH = headerSize.height;
        //拼接header 的layoutAttributes
        UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        headerAttributes.frame = (CGRect){headerX,currentSectionHeaderY,headerSize.width,headerSize.height};
        [_layoutHeaderViewInfo addObject:headerAttributes];
        
        //每个section开始计算height清零
        UIEdgeInsets insets = [_dataSource sectionInsets:section];
        NSInteger num = [_dataSource numberOfColsInSection:section];
        NSMutableArray *rowSavers = [NSMutableArray arrayWithCapacity:0];
        //初始化section的Cols布局参数
        for (int index=0; index<num; index++) {
            //当前section中cell的初始Y：sectionY + sectionHeaderHeight + insetTop
            float currentSectionY = currentSectionHeaderY + headerH + insets.top;
            ColItemInfo *info = [ColItemInfo new];
            info.colY = currentSectionY;
            info.index = index;
            [rowSavers addObject:info];
        }
        ColPosition *haha = [ColPosition new];
        haha.colYs = rowSavers;
        [_colHeights addObject:haha];
        
        //拼接cell的layoutAttributes
        NSInteger itemNum = [self.collectionView numberOfItemsInSection:section];
        //pandaudn
        for (int item=0; item<itemNum; item++){
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *itemAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameForCellAtIndexPath:indexPath];
            [_layoutDict setObject:itemAttributes forKey:[NSIndexPath indexPathForItem:item inSection:section]];
        }
        
    }
}

//计算cell大小
- (CGRect)frameForCellAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataSource) {
        UIEdgeInsets sectionInsets = [_dataSource sectionInsets:indexPath.section];
        CGFloat space = [_dataSource spaceOfCells:indexPath.section];
        NSInteger colNum = [_dataSource numberOfColsInSection:indexPath.section];
        NSInteger spaceNum = MAX(0, [_dataSource numberOfColsInSection:indexPath.section-1]);
        CGFloat cellWidth = (kScreenWidth - sectionInsets.left - sectionInsets.right - space*spaceNum)/colNum;
        CGSize itemSize = [_dataSource sizeOfItemAtIndexPath:indexPath];
        CGFloat originX = 0.f;
        CGFloat originY  = 0.f;
        CGFloat cellHeight = 0.f;
        //根据图片宽高计算cell高度
        if (itemSize.width > 0) {
            cellHeight = cellWidth * itemSize.height / itemSize.width;
        }
        cellHeight += [_dataSource heightOfAdditionalContent:indexPath];
        //找到最小高度
        NSArray *colYs = ((ColPosition *)_colHeights[indexPath.section]).colYs;
        ColItemInfo *minInfo = nil;
        CGFloat minY = INFINITY;
        for (int i=0; i<colYs.count; i++) {
            ColItemInfo *info = colYs[i];
            if (info.colY < minY) {
                minY = info.colY;
                minInfo = info;
            }
        }
        if (minInfo) {
            originX = sectionInsets.left + cellWidth*minInfo.index + space*minInfo.index;
            originY = minInfo.colY;
            minInfo.colY += cellHeight + space;
            //更新最小的
            ColPosition *curPosition = _colHeights[indexPath.section];
            [curPosition.colYs removeObjectAtIndex:minInfo.index];
            [curPosition.colYs insertObject:minInfo atIndex:minInfo.index];
            //            NSLog(@"cell-rect:%@",NSStringFromCGRect((CGRect){originX, originY, cellWidth, cellHeight}));
            return (CGRect){originX, originY, cellWidth, cellHeight};
        }
    }
    return CGRectZero;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _layoutDict[indexPath];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:0];
    if (rect.origin.y < 0) {
        rect.origin.y = 0;
    }
    [_layoutDict.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UICollectionViewLayoutAttributes *attribute = obj;
        if (CGRectIntersectsRect(attribute.frame, rect)) {
            [result addObject:attribute];
        }
    }];
    [_layoutHeaderViewInfo enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UICollectionViewLayoutAttributes *attribute = obj;
        if (CGRectIntersectsRect(attribute.frame, rect)) {
            [result addObject:attribute];
        }
    }];
    return result;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= _layoutHeaderViewInfo.count) {
        return nil;
    }
    return _layoutHeaderViewInfo[indexPath.section];
}

- (CGSize)collectionViewContentSize {
    if (_colHeights.count) {
        ColPosition *colPosition = _colHeights.lastObject;
        float max = colPosition.maxY;
        if (_dataSource) {
            max += [_dataSource sectionInsets:_colHeights.count-1].bottom;
            if (_contentMinHeight > 0) {
                max = MAX(_contentMinHeight, max);
            }
            return (CGSize){kScreenWidth, max};
        }
    }
    return CGSizeZero;
}

@end
