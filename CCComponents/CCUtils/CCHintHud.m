//
//  CCHintManager.m
//  BeautyBeePro
//
//  Created by Cheng on 2017/11/7.
//  Copyright © 2017年 Chenggd. All rights reserved.
//

#import "CCHintHud.h"
#import "UIView+WhenTappedBlocks.h"

@interface CCHintHud()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic, strong) UIView *inView;
@property (nonatomic, strong) UIImageView *arrowImg;

@end

@implementation CCHintHud

+ (instancetype)creatCCHintHudOrgin:(CGPoint)orgin {
    return [[self alloc] initWithFrame:(CGRect){orgin.x,orgin.y,kScreenWidth,50}];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _msgFont = kHelveticaFont(14);
        _msgHintTitle = @"";
        _bgColor = [UIColor colorWithHexString:@"fd5739" alpha:0.1];
        _msgColor = [UIColor colorWithHexString:@"fd5739"];
        _duration = 0.5;
        _autoHide = NO;
        _onSuperView = NO;
        [self configUI];
    }
    return self;
}

//其实原点位置不需要的，看后面业务吧
+ (instancetype)creatHintInView:(UIView *)view msg:(NSString *)msg orgin:(CGPoint)orgin autoHide:(BOOL)autoHide duration:(NSTimeInterval)duration onSuperView:(BOOL)onSuperView tapAction:(hintTapAciton)tapAction {
    return [[self alloc] initWithInView:view msg:msg orgin:orgin autoHide:autoHide duration:duration onSuperView:onSuperView tapAction:tapAction];
}

- (instancetype)initWithInView:(UIView *)view msg:(NSString *)msg orgin:(CGPoint)orgin autoHide:(BOOL)autoHide duration:(NSTimeInterval)duration onSuperView:(BOOL)onSuperView tapAction:(hintTapAciton)tapAction {
    if (self = [super init]) {
        _hintTapAciton = tapAction;
        _onSuperView = onSuperView;
        float height = [CCTool getTextHeight:msg linebreakMode:NSLineBreakByCharWrapping font:kHelveticaFont(14) width:kScreenWidth-kLeftSpace*2];
        height = (height<(kLeftSpace+10) ?kLeftSpace+10 :height);
        [self configUI];
        [self setTag:kHintHudTag];
        [self setDuration:duration];
        [self setFrame:(CGRect){orgin.x,orgin.y,kScreenWidth,height+kLeftSpace}];
        [self setSubViewHeight:self.height msg:msg];
//        //显示位置
//        [self showView:view autoHide:autoHide];
        CCWS(weakSelf)
        [self whenTapped:^{
            if (weakSelf.hintTapAciton) {
                weakSelf.hintTapAciton();
            }
        }];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.arrowImg];
    [self.bgView addSubview:self.msgLabel];
    CCWS(weakSelf)
    [self whenTapped:^{
        if (weakSelf.hintTapAciton) {
            weakSelf.hintTapAciton();
        }
    }];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView createF:(CGRect){0,0,self.width,50} BC:_bgColor];
        [_bgView addSubview:self.arrowImg];
        [_bgView addSubview:self.msgLabel];
    }
    return _bgView;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [UILabel createF:(CGRect){kLeftSpace,0,self.bgView.width-kLeftSpace*2,_bgView.height} TC:_msgColor FT:_msgFont T:_msgHintTitle AL:NSTextAlignmentCenter];
        _msgLabel.numberOfLines = 0;
    }
    return _msgLabel;
}
- (UIImageView *)arrowImg {
    if (!_arrowImg) {
        UIImage *icon = [UIImage imageNamed:@"focus_enter_arrow"];
        _arrowImg = [UIImageView createF:(CGRect){_bgView.width-icon.size.width-kLeftSpace,(_bgView.height-icon.size.height)/2,icon.size.width,icon.size.height} Img:icon];
        _arrowImg.hidden = YES;
    }
    return _arrowImg;
}

- (void)setHasArrow:(BOOL)hasArrow {
    _hasArrow = hasArrow;
    [_arrowImg setHidden:hasArrow?NO :YES];
    float width = _bgView.width-kLeftSpace*2;
    [_msgLabel setWidth:(_hasArrow ?width-_arrowImg.width :width)];
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    [_bgView setBackgroundColor:_bgColor];
}

- (void)setMsgColor:(UIColor *)msgColor {
    _msgColor = msgColor;
    [_msgLabel setTextColor:_msgColor];
}

- (void)setMsgFont:(UIFont *)msgFont {
    _msgFont = msgFont;
    [_msgLabel setFont:_msgFont];
}

- (void)setMsgAlignment:(NSTextAlignment)msgAlignment {
    _msgAlignment = msgAlignment;
    [_msgLabel setTextAlignment:_msgAlignment];
}

- (void)setMsgHintTitle:(NSString *)msgHintTitle {
    _msgHintTitle = msgHintTitle;
    float height = [CCTool getTextHeight:_msgHintTitle linebreakMode:NSLineBreakByCharWrapping font:_msgFont width:_msgLabel.width];
    height = (height<40 ?40 :height);
    [self setSubViewHeight:height msg:_msgHintTitle];
}

- (void)setSubViewHeight:(CGFloat)height msg:(NSString *)msg {
    self.height = height;
    self.bgView.height = height;
    self.msgLabel.height = height;
    self.msgLabel.text = msg;
    [self.arrowImg setY:(_bgView.height-_arrowImg.height)/2];
    if (_onSuperView && _showStatus) { //在父试图需要调整总高度
        CCWS(weakSelf)
        [UIView animateWithDuration:self.duration animations:^{
            weakSelf.y = 0;
            if (weakSelf.onSuperView) {
                [weakSelf.inView setY:weakSelf.height];
            }
        }];
    }
}

- (void)showView:(UIView *)view autoHide:(BOOL)autoHide {
    _autoHide = autoHide;
    _inView = view;
    self.y = -self.height;
    if (_onSuperView) {
        _showStatus = YES;
        [view.superview addSubview:self];
        [view setHeight:(view.height-self.height)];
    } else {
        [view addSubview:self];
    }
    [UIView animateWithDuration:self.duration animations:^{
        if (self.onSuperView) {
            [view setY:self.height];
        }
        self.y = 0;
    } completion:^(BOOL finished) {
        if (autoHide) {
            [self hideView:view after:2];
        }
    }];
}

- (void)hideView:(UIView *)view after:(NSTimeInterval)after {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.onSuperView) {
            [view setHeight:(view.height+self.height)];
        }
        [UIView animateWithDuration:self.duration animations:^{
            self.y = -self.height;
            if (self.onSuperView) {
                [view setY:0];
            }
        } completion:^(BOOL finished) {
            self.showStatus = NO;
            [self removeFromSuperview];
            if (self.dissmissHudBlock) {
                self.dissmissHudBlock();
            }
        }];
    });
}

- (void)refreshTitle:(NSString *)title {
    [self.msgLabel setText:title];
}

@end
