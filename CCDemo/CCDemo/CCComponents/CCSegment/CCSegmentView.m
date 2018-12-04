//
//  CCSegmentView.m
//  BeautyBeePro
//
//  Created by Chenggd on 2018/1/30.
//  Copyright © 2018年 Chenggd. All rights reserved.
//

#import "CCSegmentView.h"
#import "UIView+CCBadge.h"

#define itemDefaultWidth 77
#define itemDefaultHeight 44
#define itemDefaultLineWidth 20
#define itemDefaultLineHeight 4
#define itemDefaultFont 15
#define itemDefaultSFont 15
#define itemSpaceLineWidth 1
#define itemDefaultColor [UIColor colorWithHexString:@"81807B" alpha:1]
#define itemDefaultSColor [UIColor colorWithHexString:@"cc120e" alpha:1]
#define itemLucencyColor [UIColor colorWithHexString:@"ffffff" alpha:0.7]
#define itemLucencySColor [UIColor colorWithHexString:@"ffffff" alpha:1]
#define itemLineSColor [UIColor colorWithHexString:@"ffd500" alpha:1]

typedef NS_ENUM(NSInteger, CCSegmentScrollDirection) {
    CCSegmentScrollNotChange = 0,
    CCSegmentScrollToLeft,
    CCSegmentScrollToRight
};

@interface CCSegmentView ()

@property (nonatomic, strong) NSMutableArray *itemBtns;
@property (nonatomic, strong) UIButton *lastSelectItem;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, assign) NSInteger style;

@property (nonatomic, strong) NSArray *itemColorRGB;
@property (nonatomic, strong) NSArray *itemSelectColorRGB;
@property (nonatomic, strong) NSArray *colorDelta;
@property (nonatomic, strong) NSArray *colorDivideDelta;
@property (nonatomic, assign) BOOL startByOutScroll;

@property (nonatomic, assign) float newOffsetX;
@property (nonatomic, assign) float oldOffsetX;

@end

@implementation CCSegmentView

- (void)dealloc
{
    [CCNotiYCenter removeObserver:self];
}

- (instancetype)initWithItems:(NSArray *)items style:(NSInteger)style {
    if (self = [super init]) {
        self.itemWidth = itemDefaultWidth;
        self.itemHeight = itemDefaultHeight;
        self.lineWidth = itemDefaultLineWidth;
        self.lineHeight = itemDefaultLineHeight;
        self.itemFont = itemDefaultFont;
        self.itemSelectFont = itemDefaultSFont;
        //示例:UIColor需使用colorWithRed/colorWithHexString,否则渐变不起效,后续用渐变层优化
        self.itemColor = [UIColor colorWithRed:129/255.f green:128/255.f blue:123/255.f alpha:1];
//        self.itemColor = itemDefaultColor;
        self.itemSelectColor = itemDefaultSColor;
        self.lineColor = itemLineSColor;
        self.lineSpaceForBottom = 0;
        self.style = style;
        self.itemBtns = [NSMutableArray arrayWithCapacity:0];
        self.items = [NSMutableArray arrayWithArray:items];
        self.backgroundColor = [UIColor clearColor];
        
        _colorTransition = YES;
    }
    return self;
}

/**
 获取UIColor的rgb数值
 @param color color
 @return rgb数值
 */
- (NSArray *)colorRGBNumsByColor:(UIColor *)color {
    CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor));
    NSArray *colorArray = nil;
    if (colorSpaceModel == kCGColorSpaceModelRGB ||
        colorSpaceModel == kCGColorSpaceModelMonochrome) {
        CGFloat r = 0.0,g = 0.0,b = 0.0,a;
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        switch (colorSpaceModel) {
                //单色图
            case kCGColorSpaceModelMonochrome:
                r = g = b = components[0];
                a = components[1];
                break;
            case kCGColorSpaceModelRGB:
                r = components[0];
                g = components[1];
                b = components[2];
                a = components[3];
                break;
            default:
                break;
        }
        colorArray = @[@(r*255.f),@(g*255.f),@(b*255.f)];
    }
    return colorArray;
}

- (void)refreshColorDelta {
    //计算变化的范围差值（选中-normal）
    _colorDelta = @[@([_itemSelectColorRGB[0] floatValue]-[_itemColorRGB[0] floatValue]),
                   @([_itemSelectColorRGB[1] floatValue]-[_itemColorRGB[1] floatValue]),
                   @([_itemSelectColorRGB[2] floatValue]-[_itemColorRGB[2] floatValue])];
    _colorDivideDelta = @[@([_colorDelta[0] floatValue]/self.outScrollView.width),
                          @([_colorDelta[1] floatValue]/self.outScrollView.width),
                          @([_colorDelta[2] floatValue]/self.outScrollView.width)];
}

- (void)setItemColor:(UIColor *)itemColor {
    _itemColor = itemColor;
    _itemColorRGB = [self colorRGBNumsByColor:_itemColor];
}

- (void)setItemSelectColor:(UIColor *)itemSelectColor {
    _itemSelectColor = itemSelectColor;
    _itemSelectColorRGB = [self colorRGBNumsByColor:_itemSelectColor];
}

- (void)setItems:(NSArray *)items {
    if (_items != items) {
        _items = items;
        [self configItem];
    }
}

- (void)configItem {
    [self.itemBtns removeAllObjects];
    [self removeAllSubViews];
    [self setFrame:(CGRect){0,0,self.itemWidth*self.items.count+(self.items.count-itemSpaceLineWidth)*itemSpaceLineWidth,self.itemHeight}];
    [self addSubview:self.lineView];
    for (int i=0; i<self.items.count; i++) {
        UIButton *btn = [UIButton createT:self.items[i] C:self.itemColor ST:self.items[i] SC:self.itemSelectColor];
        btn.titleLabel.backgroundColor = [UIColor clearColor];
        [btn setTag:200+i];
        btn.titleLabel.font = kBoldHelvetica(self.itemFont);
        [btn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:(CGRect){i*(self.itemWidth+itemSpaceLineWidth),0,self.itemWidth,self.height}];
        //shadowOffset阴影偏移
        btn.titleLabel.layer.shadowColor = [UIColor colorWithHexString:@"cc120e" alpha:0.9].CGColor;
        btn.titleLabel.layer.shadowOffset = CGSizeMake(0,0);
        btn.titleLabel.layer.shadowRadius = 2;
        btn.titleLabel.layer.shadowOpacity = 0;
        [self addSubview:btn];
        [self.itemBtns addObject:btn];
//        if (i != (self.items.count-1)) {
//            UIView *spaceLine = [UIView createF:(CGRect){Btn.right,(self.height-7)/2,itemSpaceLineWidth,7} BC:[UIColor colorWithHexString:@"ffffff" alpha:0.5]];
//            [self addSubview:spaceLine];
//        }
        if (i == 0) {
            _selectIndex = 0;
            btn.selected = YES;
            btn.titleLabel.font = kBoldHelvetica(self.itemSelectFont);
            self.lastSelectItem = btn;
        }
    }
    [self refreshLineCenter];
    [self addSubview:self.bottomLineView];
    
}

- (void)refreshLineCenter {
    if (self.style == 0) {
        [self.lineView setCenter:self.lastSelectItem.center];
    } else if (self.style == 1) {
        [self.lineView setCenter:CGPointMake(self.lastSelectItem.center.x, self.lastSelectItem.height-self.lineView.height/2-self.bottomLineView.height-self.lineSpaceForBottom)];
    }
}

- (void)setLineHeight:(float)lineHeight {
    _lineHeight = lineHeight;
    [self.lineView setHeight:_lineHeight];
    [_lineView setY:(self.itemHeight-_lineHeight)/2];
    _lineView.layer.cornerRadius = _lineHeight/2.f;
    [self refreshLineCenter];
}

- (UIView *)lineView {
    if (!_lineView) {
        float width = _style==0 ?45 :60;
        float height = _style==0 ?4 :2;
        _lineView = [UIView createF:(CGRect){0,(self.itemHeight-height)/2,width,height} BC:_lineColor];
        _lineView.layer.cornerRadius = height/2.f;
    }
    return _lineView;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [UIView createF:(CGRect){0,self.height-0.5,self.width,0.5} BC:[UIColor colorWithHexString:@"efefef"]];
        _bottomLineView.hidden = YES;
    }
    return _bottomLineView;
}

- (void)setHasBottomLine:(BOOL)hasBottomLine {
    _hasBottomLine = hasBottomLine;
    [self.bottomLineView setHidden:!_hasBottomLine];
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    self.lineView.backgroundColor = lineColor;
}

- (void)setLineWidth:(float)lineWidth {
    _lineWidth = lineWidth;
    [self.lineView setWidth:_lineWidth];
}

- (void)clickItem:(UIButton *)sender {
    self.startByOutScroll = NO;
    [self refreshItemStatus:sender];
    if (_clickItemBlock) {
        _clickItemBlock((sender.tag-200));
    }
}

- (void)refreshItemStatus:(UIButton *)sender {
    if (self.lastSelectItem.tag == sender.tag) {
        return;
    }
    self.lastSelectItem.selected = NO;
    self.lastSelectItem.titleLabel.font = kBoldHelvetica(self.itemFont);
    sender.selected = !sender.selected;
    sender.titleLabel.font = kBoldHelvetica(self.itemSelectFont);
    self.lastSelectItem = sender;
//    [self.lineView setCenter:self.lastSelectItem.center];
    [self refreshLineCenter];
    _selectIndex = self.lastSelectItem.tag-200;
   //刷新样式
    if (self.needChange) {
        [self.itemBtns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *Btn = (UIButton *)obj;
            if ((self.lastSelectItem.tag-200) != 2) {
                [Btn setTitleColor:self.itemColor forState:UIControlStateNormal];
                [Btn setTitleColor:self.itemSelectColor forState:UIControlStateSelected];
                Btn.titleLabel.layer.shadowOpacity = 0;
            } else {
                Btn.titleLabel.layer.shadowOpacity = 0.6;
                [Btn setTitleColor:itemLucencyColor forState:UIControlStateNormal];
                [Btn setTitleColor:itemLucencySColor forState:UIControlStateSelected];
            }
        }];
    }
}

- (void)setOutScrollView:(UIScrollView *)outScrollView {
    _outScrollView = outScrollView;
    if (_itemColorRGB.count && _itemSelectColorRGB.count && _colorTransition) {
        [self refreshColorDelta];
        /** 监听outScrollView contentOffset */
        [outScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [outScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //点击无动画～否则不相邻的item过渡太丑
    BOOL beginDrag = NO;
    if (_outScrollView.panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (!self.startByOutScroll) {
            self.startByOutScroll = YES;
        }
        beginDrag = YES;
    }
    if (self.startByOutScroll) {
        if ([change.allKeys containsObject:NSKeyValueChangeNewKey]) {
            _newOffsetX = ([(NSValue *)change[NSKeyValueChangeNewKey] CGPointValue]).x;
        }
        if ([change.allKeys containsObject:NSKeyValueChangeOldKey]) {
            _oldOffsetX = ([(NSValue *)change[NSKeyValueChangeOldKey] CGPointValue]).x;
        }
        
        if (beginDrag) { //手势开始时，new还是无值状态
            return;
        }
        //计算当前滑动视图所在区间与滑动方向
        NSInteger leftIndex = _newOffsetX/_outScrollView.width;
        NSInteger rightIndex = 0;
        if (_newOffsetX-leftIndex*_outScrollView.width == 0) { //分界点
            rightIndex = leftIndex;
        } else if (_newOffsetX-leftIndex*_outScrollView.width > 0) { //+1
            rightIndex = leftIndex+1;
        } else if (_newOffsetX-leftIndex*_outScrollView.width < 0) { //-1
            leftIndex = leftIndex -1;
        }
        leftIndex = MIN(leftIndex, rightIndex);
        rightIndex = MAX(rightIndex, rightIndex);
        CCSegmentScrollDirection direction = CCSegmentScrollNotChange;
        if (_newOffsetX-_oldOffsetX > 0) {
            direction = CCSegmentScrollToLeft;
        } else if (_newOffsetX-_oldOffsetX < 0) {
            direction = CCSegmentScrollToRight;
        }
        //在bounds范围内
        if (MIN(leftIndex, rightIndex)>=0 && MAX(leftIndex, rightIndex)<self.items.count
            && direction != CCSegmentScrollNotChange) {
            NSInteger relIndex = direction==CCSegmentScrollToLeft ?MIN(leftIndex, rightIndex) :MAX(leftIndex, rightIndex);
            NSInteger nextIndex = direction==CCSegmentScrollToLeft ?MAX(leftIndex, rightIndex) :MIN(leftIndex, rightIndex);
            float moveX = 0;
            if (direction == CCSegmentScrollToLeft) {
                moveX = _newOffsetX-relIndex*self.outScrollView.width;
            } else {
                moveX = _newOffsetX-nextIndex*self.outScrollView.width;
            }
            //颜色渐变动画
            UIButton *Btn = _itemBtns[relIndex];
            UIButton *nextBtn = _itemBtns[nextIndex];
            float haha0 = ([_itemSelectColorRGB[0] floatValue]-[_colorDivideDelta[0] floatValue]*moveX)/255.f;
            float haha1 = ([_itemSelectColorRGB[1] floatValue]-[_colorDivideDelta[1] floatValue]*moveX)/255.f;
            float haha2 = ([_itemSelectColorRGB[2] floatValue]-[_colorDivideDelta[2] floatValue]*moveX)/255.f;
            float color0 = ([_itemColorRGB[0] floatValue]+[_colorDivideDelta[0] floatValue]*moveX)/255.f;
            float color1 = ([_itemColorRGB[1] floatValue]+[_colorDivideDelta[1] floatValue]*moveX)/255.f;
            float color2 = ([_itemColorRGB[2] floatValue]+[_colorDivideDelta[2] floatValue]*moveX)/255.f;
            UIColor *indexColor = [UIColor colorWithRed:haha0 green:haha1 blue:haha2 alpha:1];
            UIColor *nextIndexColor = [UIColor colorWithRed:color0 green:color1 blue:color2 alpha:1];
            if (relIndex != nextIndex) { //到达分界线后颜色的问题
                if (direction == CCSegmentScrollToLeft) {
                    Btn.titleLabel.textColor = indexColor;
                    nextBtn.titleLabel.textColor = nextIndexColor;
                } else {
                    nextBtn.titleLabel.textColor = indexColor;
                    Btn.titleLabel.textColor = nextIndexColor;
                }
            }
            //线动画
            float targetTx = _itemWidth/_lineWidth;
            if (moveX > _outScrollView.width/2) {
                float relMoveX = moveX-_outScrollView.width/2;
                float relfangda = relMoveX*targetTx/(_outScrollView.width/2);
                //#warning 使用transform的话cornerRadius不为隐式动画会有拉伸问题
//                _lineView.transform = CGAffineTransformMakeScale((1+targetTx)-relfangda, 1);
                [_lineView setWidth:((1+targetTx)-relfangda)*_lineWidth];
                if (direction == CCSegmentScrollToLeft) {
                    [_lineView setRight:nextBtn.center.x+_lineWidth/2];
                } else {
                    [_lineView setRight:Btn.center.x+_lineWidth/2];
                }
            } else {
                float relMoveX = moveX;
                float relfangda = relMoveX*targetTx/(_outScrollView.width/2);
//                _lineView.transform = CGAffineTransformMakeScale(1+relfangda, 1);
                [_lineView setWidth:(1+relfangda)*_lineWidth];
                if (direction == CCSegmentScrollToLeft) {
                    [_lineView setX:Btn.center.x-_lineWidth/2];
                } else {
                    [_lineView setX:nextBtn.center.x-_lineWidth/2];
                }
            }
        }
        
    }
}

- (void)selectSegmentIndex:(NSInteger)index {
    if (_itemBtns.count) {
        UIButton *itemBtn = (UIButton *)_itemBtns[index];
        [self refreshItemStatus:itemBtn];
    }
}

- (void)refreshBadgeForIndex:(NSInteger)index {
//    if (_itemBtns.count>index) {
//        UIButton *itemBtn = (UIButton *)_itemBtns[index];
//        CCModel *model = [CCModel shareCCModel];
//        if (model.travelUnreadNum>0) {
//            [itemBtn showBadge];
//        } else {
//            [itemBtn hidenBadge];
//        }
//    }
}

@end
