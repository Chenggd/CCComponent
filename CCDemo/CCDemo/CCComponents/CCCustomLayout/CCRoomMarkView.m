//
//  CCRoomMarkView.m
//  BeautyBeePro
//
//  Created by Chenggd on 2018/1/9.
//  Copyright © 2018年 Chenggd. All rights reserved.
//

#import "CCRoomMarkView.h"
#import "UIView+WhenTappedBlocks.h"

@interface CCRoomMarkLayout : UICollectionViewFlowLayout

@property (nonatomic) CGFloat maximumInteritemSpacing;

@end

@implementation CCRoomMarkLayout

- (instancetype)init {
    if (self = [super init]) {
        self.maximumInteritemSpacing = 20;
    }
    return self;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    //数组內布局元素可能是无序的
    for(int i = 0; i < [attributes count]; i++) {
        UICollectionViewLayoutAttributes *curAttr = attributes[i];
        CGRect curAttrFrame = curAttr.frame;
        if (i == 0) {
            curAttrFrame.origin.x = self.sectionInset.left;
            curAttr.frame = curAttrFrame;
        } else {
            UICollectionViewLayoutAttributes *preAttr = attributes[i-1];
            NSInteger origin = CGRectGetMaxX(preAttr.frame);
            //根据maximumInteritemSpacing计算x值，注意考虑内边距
            CGFloat targetX = origin + _maximumInteritemSpacing;
            if (targetX + CGRectGetWidth(curAttr.frame) < self.collectionViewContentSize.width-self.sectionInset.right) { //不换行
                //当系统计算的间距!= maximumInteritemSpacing时调整
                if (CGRectGetMinX(curAttr.frame) != targetX) {
                    curAttrFrame.origin.x = targetX;
                    curAttr.frame = curAttrFrame;
                }
            } else { //换行
                curAttrFrame.origin.x = self.sectionInset.left;
                curAttr.frame = curAttrFrame;
            }
        }
    }
    return attributes;
}

@end

@interface CCRoomMarkView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) CCEvaluateTagInfo *editorInfo;
@property (nonatomic, assign) NSInteger curIndex;
@property (nonatomic, assign) CCSMarkType style;
@property (nonatomic, assign) float leftSpace;
@property (nonatomic, assign) float rowSpace;

@end

@implementation CCRoomMarkView

static NSString *markCellId = @"markCellId";

- (instancetype)initWithFrame:(CGRect)frame style:(CCSMarkType)style {
    if (self = [super initWithFrame:frame collectionViewLayout:[self layoutByStyle:style]]) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        _style = style;
        _maxCount = 5;
        _itemHeight = 20;
        _itemSpace = 7;
        if (_style == CCRoomEditorMarkType) {
            _itemHeight = 32;
            _itemSpace = _itemHeight/2.f;
        } else if (_style == CCSearchMarkType) {
            _itemHeight = 28;
            _itemSpace = _itemHeight/2.f;
            _maxCount = 6;
            _leftSpace = 26;
            _rowSpace = 0;
        }
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:markCellId];
    }
    return self;
}

- (CCRoomMarkLayout *)layoutByStyle:(NSInteger)style {
    CCRoomMarkLayout *layout = [[CCRoomMarkLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 8;
    layout.minimumInteritemSpacing = 8;
    layout.maximumInteritemSpacing = 8;
    float leftSpace = 0;
    float rowSpace = 0;
    if (style == CCRoomEditorMarkType) {
        rowSpace = 20;
        leftSpace = 20;
    } else if (style == CCSearchMarkType) {
        leftSpace = 26;
        rowSpace = 0;
        layout.minimumInteritemSpacing = 38;
        layout.maximumInteritemSpacing = 38;
        layout.minimumLineSpacing = kLeftSpace;
    }
    layout.sectionInset = UIEdgeInsetsMake(rowSpace, leftSpace, rowSpace, leftSpace);
    return layout;
}

#pragma mark UICollectionViewDelegate
//// cell点击变色
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
//    return NO;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _tagInfos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = (UICollectionViewCell *)[self dequeueReusableCellWithReuseIdentifier:markCellId forIndexPath:indexPath];
    [cell.contentView.layer setCornerRadius:(_style==CCRoomEditorMarkType?_itemHeight/2.f :_itemHeight/2.f)];
    [cell.contentView.layer setMasksToBounds:YES];
    UIImageView *img = (UIImageView *)[cell.contentView viewWithTag:801];
    if (!img && (_style!=CCNormalMarkType && _style!=CCSearchMarkType)) {
        img = [UIImageView createF:(CGRect){_itemSpace,(_itemHeight-16)/2,16,16} Img:nil];
        [img setTag:801];
        [cell.contentView addSubview:img];
    }
    UILabel *tagLabel = (UILabel *)[cell.contentView viewWithTag:800];
    float orginX = img ?img.right+5 :_itemSpace;
    if (!tagLabel) {
        tagLabel = [UILabel createF:(CGRect){orginX,0,cell.width-orginX-_itemSpace,_itemHeight} TC:[UIColor colorWithHexString:@"ffffff"] FT:kHelveticaFont(12) T:@"" AL:NSTextAlignmentCenter];
        tagLabel.backgroundColor = [UIColor clearColor];
        [tagLabel setTag:800];
        [cell.contentView addSubview:tagLabel];
    }

    if (_tagInfos.count) {
        CCEvaluateTagInfo *info = _tagInfos[indexPath.item];
        [tagLabel setWidth:cell.width-orginX-_itemSpace];
        tagLabel.text = info.value;
        tagLabel.textColor = [UIColor colorWithHexString:info.titleColor];
        if (img) {
            UIImage *icon = [UIImage imageNamed:info.iconName];
            [img setImage:icon];
        }
        cell.contentView.backgroundColor = info.bgColor ?info.bgColor :[UIColor colorWithHexString:@"f4f4f4"];
    }
    return cell;
}

- (void)addNewTag:(NSString *)title {
    CCEvaluateTagInfo *info = [CCEvaluateTagInfo new];
    info.type = 1;
    info.value = title;
    info.color = @"f4f4f4";
    if (_style == CCSVEditorMarkType) {
        info.bgColor = [UIColor colorWithHexString:@"212429" alpha:.5f];
        info.titleColor = @"ffffff";
        info.iconName = @"sv_tag";
    } else {
        info.bgColor = [UIColor colorWithHexString:@"fffdef"];
        info.titleColor = @"333333";
        info.iconName = @"room_del_tag";
    }
    [_tagInfos insertObject:info atIndex:(_tagInfos.count-1)];
    [self refreshTagsInfo];
}

- (void)removeOldTag:(NSInteger)index {
    [_tagInfos removeObjectAtIndex:index];
    [self refreshTagsInfo];
}

- (CCEvaluateTagInfo *)editorInfo {
    if (!_editorInfo) {
        _editorInfo = [CCEvaluateTagInfo new];
        _editorInfo.value = @"添加标签";
        _editorInfo.type = 0;
        if (_style == CCSVEditorMarkType) {
            _editorInfo.color = @"f4f4f4";
            _editorInfo.bgColor = [UIColor colorWithHexString:@"212429" alpha:.5f];
            _editorInfo.titleColor = @"ffffff";
            _editorInfo.iconName = @"sv_tag";
        } else {
            _editorInfo.color = @"f4f4f4";
            _editorInfo.bgColor = [UIColor colorWithHexString:@"fffdef"];
            _editorInfo.titleColor = @"999999";
            _editorInfo.iconName = @"room_editor_tag";
        }
    }
    return _editorInfo;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CCEvaluateTagInfo *info = _tagInfos[indexPath.item];
    if (_tapAction) {
        _tapAction(info.type, info);
    }
    if (_style==CCRoomEditorMarkType || _style==CCSVEditorMarkType) {
        if (info.type != 0) {
            [self removeOldTag:indexPath.item];
        }
    }
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_tagInfos.count) {
        CCEvaluateTagInfo *info = _tagInfos[indexPath.item];
        float width = [CCTool getWidth:info.value font:kHelveticaFont(12)];
//        float otherWidth = ((_style!=CCNormalMarkType ||_style!=CCSearchMarkType) ?(16+_itemSpace*2+5) :_itemSpace*2);
        float otherWidth = (_style==CCNormalMarkType||_style==CCSearchMarkType) ?_itemSpace*2 :(16+_itemSpace*2+5);
        width += otherWidth;
        //限制最大宽
        width = MIN(self.width-_leftSpace*2, width);
        return CGSizeMake(width, _itemHeight);
    }
    return CGSizeMake(30, _itemHeight);
}

- (void)setTagInfos:(NSMutableArray *)tagInfos {
    _tagInfos = tagInfos;
    [self refreshTagsInfo];
}

- (void)refreshTagsInfo {
    if (!_tagInfos) {
        _tagInfos = [NSMutableArray arrayWithCapacity:0];
    }
    NSInteger fullCount =_tagInfos.count;
    if (_tagInfos.count) {
        CCEvaluateTagInfo *info = _tagInfos.lastObject;
        if (info.type == 0) {
            fullCount -= 1;
        }
    }
    if (_style==CCRoomEditorMarkType || _style==CCSVEditorMarkType) {
        if (fullCount == _tagInfos.count || _tagInfos == 0) {
            if (fullCount < _maxCount) {
                [_tagInfos insertObject:self.editorInfo atIndex:_tagInfos.count];
            }
        } else if (fullCount == _maxCount) {
            [_tagInfos removeLastObject];
        }
    }
    [self reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    float height = self.contentSize.height;
    [self setHeight:height];
    if (_updateFrameComplete) {
        _updateFrameComplete(height);
    }
}

- (NSString *)tagListForStr {
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
    [_tagInfos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CCEvaluateTagInfo *info = (CCEvaluateTagInfo *)obj;
        if (info.type != 0) {
            [tempArray addObject:info.value];
        }
    }];
    return [tempArray componentsJoinedByString:@","];
}

@end
