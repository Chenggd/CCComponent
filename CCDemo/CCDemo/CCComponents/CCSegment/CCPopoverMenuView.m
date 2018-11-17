//
//  CCPopoverMenuView.m
//  CCCustomComponent
//
//  Created by Dong on 2018/5/2.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import "CCPopoverMenuView.h"

#define defaultPopMenuFont kHelveticaFont(14)

@interface CCPopoverMenuView()<CAAnimationDelegate>

@property (nonatomic, strong) UIImageView *arrowImg;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *lbl;
@property (nonatomic, strong) UIButton *closedCCn;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL hasArrow;

@property (nonatomic, assign) CGPoint fromPoint;
@property (nonatomic, assign) CGPoint toPoint;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation CCPopoverMenuView

+ (instancetype)creatPopoverMenuText:(NSString *)text hasArrow:(BOOL)hasArrow {
    return [[self alloc] initWithFrame:(CGRect){0,0,100,36} text:text hasArrow:hasArrow];
}

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text hasArrow:(BOOL)hasArrow {
    if (self = [super initWithFrame:frame]) {
        _text = text;
        _hasArrow = hasArrow;
        [self refreshFrame];
        [self configUI];
        [self refreshSubView];
        CCWS(weakSelf)
        [self whenTapped:^{
            [self closedMenu];
            if (weakSelf.tapMenuAction) {
                weakSelf.tapMenuAction();
            }
        }];
    }
    return self;
}

- (void)refreshFrame {
    UIImage *icon = [UIImage imageNamed:@"arrow_triangle_orange"];
    UIImage *closedIcon = [UIImage imageNamed:@"gidts_closed"];
    float width = [CCTool getWidth:_text font:defaultPopMenuFont];
    width = width<60 ?60 :width;
    float sumWidth = width+(8*2+closedIcon.size.width+5);
    [self setFrame:(CGRect){self.x,self.y,sumWidth,35+(_hasArrow ?(icon.size.height-1) :0)}];
}

- (void)refreshSubView {
    UIImage *closedIcon = [UIImage imageNamed:@"gidts_closed"];
    UIImage *icon = [UIImage imageNamed:@"arrow_triangle_orange"];
    _bgView.width = self.width;
    self.gradientLayer.frame = _bgView.bounds;
    [self.gradientLayer setNeedsDisplay];
    
    kViewRadius(_bgView, _bgView.height/2);
    [_lbl setWidth:self.width-(8*2+closedIcon.size.width+5)];
    [_closedCCn setX:self.width-8-icon.size.width];
}

- (void)configUI {
    if (_hasArrow) {
        [self addSubview:self.arrowImg];
    } 
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.closedCCn];
    [self.bgView addSubview:self.lbl];
}

- (UIImageView *)arrowImg {
    if (!_arrowImg) {
        UIImage *icon = [UIImage imageNamed:@"arrow_triangle_orange"];
        _arrowImg = [UIImageView createF:(CGRect){self.width-17-icon.size.width,0,icon.size.width,icon.size.height} Img:icon];
    }
    return _arrowImg;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [UIView createF:(CGRect){0,_hasArrow ?_arrowImg.height-1 :0,self.width,35} BC:[UIColor clearColor]];
        [_bgView.layer addSublayer:self.gradientLayer];
    }
    return _bgView;
}

- (CAGradientLayer *)gradientLayer { //背景渐变
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = _bgView.bounds;
        _gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"ffec00" alpha:1].CGColor,
                                 (__bridge id)[UIColor colorWithHexString:@"ffd500" alpha:1].CGColor];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 0);
    }
    return _gradientLayer;
}

- (UILabel *)lbl {
    if (!_lbl) {
        _lbl = [UILabel createF:(CGRect){8,0,_bgView.width-8*2-_closedCCn.width-5,_bgView.height} TC:[UIColor colorWithHexString:@"38362b"] FT:kHelveticaFont(14) T:_text AL:NSTextAlignmentCenter];
    }
    return _lbl;
}

- (UIButton *)closedCCn {
    if (!_closedCCn) {
        UIImage *icon = [UIImage imageNamed:@"menu_hint_closed"];
        _closedCCn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closedCCn setImage:icon forState:UIControlStateNormal];
        [_closedCCn setFrame:(CGRect){self.width-8-icon.size.width,(self.bgView.height-icon.size.height)/2,icon.size.width,icon.size.height}];
        [_closedCCn addTarget:self action:@selector(closedMenu) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closedCCn;
}

#pragma mark - 带箭头的效果，类似缩放
- (void)showPopoverMenuInView:(UIView *)inView point:(CGPoint)point direction:(CCPopoverArrowDirection)direction {
    self.alpha = 0;
    CCPopoverArrowDirection relDirection = direction;
    if (direction == CCPopoverArrowDirectionUp) { //下间距加self高度大于边界需箭头朝下
        if (point.y+self.height > inView.height)  {
            relDirection = CCPopoverArrowDirectionDown;
        }
    } else if (direction == CCPopoverArrowDirectionDown) {
        if (point.y-self.height < 0) { //上间距加self高度小于边界需箭头朝上
             relDirection = CCPopoverArrowDirectionUp;
        }
    }
    float leftX = self.width-17-self.arrowImg.width/2;
    if (point.x >= leftX) { //可以向左
        [self setX:point.x-leftX];
        [self.arrowImg setX:leftX-self.arrowImg.width/2];
        _gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"ffec00" alpha:1].CGColor,
                                  (__bridge id)[UIColor colorWithHexString:@"ffd500" alpha:1].CGColor];
    } else { //向右
        [self setX:point.x-self.arrowImg.width/2-17];
        [self.arrowImg setX:17];
        _gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"ffd500" alpha:1].CGColor,
                                  (__bridge id)[UIColor colorWithHexString:@"ffec00" alpha:1].CGColor];
    }
    if (relDirection == CCPopoverArrowDirectionDown) {
        CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI);
        self.arrowImg.transform = transform;
    }
    [self.arrowImg setY:relDirection==CCPopoverArrowDirectionUp ?0 :self.bgView.height-1];
    [self.bgView setY:relDirection==CCPopoverArrowDirectionUp ?self.arrowImg.height-1 :0];
    [self setY:relDirection==CCPopoverArrowDirectionUp ?point.y :point.y-self.height];
    if (!self.superview) {
        [self.gradientLayer setNeedsDisplay];
        [inView addSubview:self];
    }

    CABasicAnimation *animationScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animationScale.duration = 0.2;
    animationScale.repeatCount = 1;
    animationScale.autoreverses = NO;
    animationScale.fromValue = [NSNumber numberWithFloat:0.0];
    animationScale.toValue = [NSNumber numberWithFloat:1.0];
    animationScale.removedOnCompletion = NO;
    animationScale.delegate = self;
    CGRect frame = self.frame;
    self.layer.anchorPoint = CGPointMake(1.0, 0.3);
    self.frame = frame;
    self.alpha = 1.0;
    [self.layer addAnimation:animationScale forKey:@"show_scale"];
}

- (void)closedMenu {
    if (_hasArrow) {
        [self dismissMenu:YES];
    } else {
        [self dismissNormalMenu:YES];
    }
}

- (void)dismissMenu:(BOOL)inside {
    if (!self.superview) {
        return;
    }
    CABasicAnimation *animationScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animationScale.duration = 0.2;
    animationScale.repeatCount = 1;
    animationScale.autoreverses = NO;
    animationScale.fromValue = [NSNumber numberWithFloat:1];
    animationScale.toValue = [NSNumber numberWithFloat:0];
    animationScale.fillMode = kCAFillModeForwards;
    animationScale.removedOnCompletion = NO;
    animationScale.delegate = self;
    CGRect frame = self.frame;
    self.layer.anchorPoint = CGPointMake(1, 0.3);
    self.frame = frame;
    [self.layer addAnimation:animationScale forKey:@"dismiss_scale"];
    
    if (_dismissMenuBlock) {
        _dismissMenuBlock(inside);
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([self.layer animationForKey:@"show_scale"] == anim) {

    } else if ([self.layer animationForKey:@"dismiss_scale"] == anim) {
        self.alpha = 0;
    }
    [self.layer removeAllAnimations];
}

#pragma mark - 不带箭头的效果，平移
- (void)showPopoverMenuInView:(UIView *)inView fromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint normalDirection:(NSInteger)normalDirection {
    _fromPoint = fromPoint;
    _toPoint = toPoint;
    self.x = fromPoint.x;
    self.y = fromPoint.y;
    [inView addSubview:self];
    [inView bringSubviewToFront:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.x = toPoint.x;
        self.y = toPoint.y;
    } completion:^(BOOL finished) {
       
    }];
}

- (void)dismissNormalMenu:(BOOL)inside {
    [UIView animateWithDuration:0.2 animations:^{
        self.x = self.fromPoint.x;
        self.y = self.fromPoint.y;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    if (_dismissMenuBlock) {
        _dismissMenuBlock(inside);
    }
}

- (void)refreshText:(NSString *)text {
    _text = text;
    [_lbl setText:_text];
    dispatch_async_main_safe(^{
        [self refreshFrame];
        [self refreshSubView];
    });

}

@end
