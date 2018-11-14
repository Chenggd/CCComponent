//
//  CCLiveAreaDanmakuView.m
//  BeautyBeeTravel
//
//  Created by Dong on 2018/9/6.
//  Copyright © 2018年 美蜂. All rights reserved.
//

#import "CCLiveAreaDanmakuView.h"
#import "CCDanmakuView.h"
#import "UIView+WhenTappedBlocks.h"

@interface CCLiveAreaDanmakuView ()<CAAnimationDelegate>

@property (nonatomic, strong) UIImageView *hornImg;
@property (nonatomic, strong) UIImageView *arrowImg;
@property (nonatomic, strong) UIView *scrollBgView;
@property (nonatomic, strong) NSMutableArray *iconTimes;
/** 在显示中的弹幕视图数组 */
@property (nonatomic, strong) NSMutableArray *normalDanmakuViews;
/** next弹幕展示索引 */
@property (nonatomic, assign) NSInteger normalIndex;
//渐变背景
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
//形变目标宽度
@property (nonatomic, assign) CGFloat targetWidth;

@end

static NSTimeInterval deformationDuration = 0.3f;

@implementation CCLiveAreaDanmakuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //初始大小
        [self setWidth:24];
        [self setHeight:24];
        self.layer.cornerRadius = 24/2.f;
        self.layer.masksToBounds = YES;
        _runDuration = 10.f;
        _normalDanmakuViews = [NSMutableArray arrayWithCapacity:0];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self.layer addSublayer:self.gradientLayer];
    [self addSubview:self.hornImg];
    [self addSubview:self.scrollBgView];
    [self addSubview:self.arrowImg];
}

- (UIView *)scrollBgView {
    if (!_scrollBgView) {
        _scrollBgView = [UIView createF:(CGRect){self.height,0,self.width,self.height} BC:[UIColor clearColor]];
        _scrollBgView.layer.masksToBounds = YES;
        _scrollBgView.userInteractionEnabled = NO;
    }
    return _scrollBgView;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"3ee6f3" alpha:1].CGColor,
                                  (__bridge id)[UIColor colorWithHexString:@"38b0ea" alpha:1].CGColor];
        //    gradientLayer.locations = @[@0.0,@0.5,@1.0];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 0);
    }
    return _gradientLayer;
}

- (UIImageView *)hornImg {
    if (!_hornImg) {
        UIImage *icon = [UIImage imageNamed:@"live_danmaku_horn"];
        _hornImg = [UIImageView createF:(CGRect){(self.width-icon.size.width)/2,(self.height-icon.size.height)/2,icon.size.width,icon.size.height} Img:icon];
    }
    return _hornImg;
}

- (UIImageView *)arrowImg {
    if (!_arrowImg) {
        UIImage *icon = [[UIImage imageNamed:@"calendar_advance"] imageWithTintColor:[UIColor colorWithHexString:@"ffffff"]];
        _arrowImg = [UIImageView createF:(CGRect){self.height,(self.height-icon.size.height)/2,icon.size.width,icon.size.height} Img:icon];
    }
    return _arrowImg;
}

- (void)setDanmakuMsgInfo:(CCDanmuGiftInfo *)danmakuMsgInfo {
    _danmakuMsgInfo = danmakuMsgInfo;
    //设置展示区域,且展示区域在文字宽度基础上加30,用于显示后缀留空
    float danmakuWidth = [CCTool getWidth:_danmakuMsgInfo.content font:kBoldHelvetica(12)];
    danmakuWidth = MIN((danmakuWidth+30), (kScreenWidth*0.8-self.height*2));
    //设置滚动展示区域
    [self.scrollBgView setWidth:danmakuWidth];
    danmakuWidth += (self.height*2);
    
    _targetWidth = danmakuWidth;
    [self.arrowImg setX:_targetWidth-self.arrowImg.width-8];
//    self.width = danmakuWidth;
//    //设置箭头位置
//    [self.arrowImg setX:self.width-self.arrowImg.width-8];
}

- (void)startAreaDanmakuAnimation {
    //开始形变动画(CABasicAnimation方式)
//    CABasicAnimation *aniBounds = [CABasicAnimation animationWithKeyPath:@"bounds"];
//    aniBounds.fromValue = [NSValue valueWithCGRect:(CGRect){0, 0, self.height, self.height}];
//    aniBounds.toValue = [NSValue valueWithCGRect:(CGRect){0, 0, self.width, self.height}];
//    CABasicAnimation *aniPosition = [CABasicAnimation animationWithKeyPath:@"position"];
//    aniPosition.fromValue = [NSValue valueWithCGPoint:self.layer.position];
//    aniPosition.toValue = [NSValue valueWithCGPoint:CGPointMake(self.layer.position.x+(self.width-self.height)/2,self.layer.position.y)];
//    CAAnimationGroup *anis = [CAAnimationGroup animation];
//    anis.animations = @[aniBounds,aniPosition];
//    anis.duration = deformationDuration;
//    anis.delegate = self;
//    anis.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    anis.removedOnCompletion = NO;
//    anis.fillMode = kCAFillModeForwards;
//    [self.layer addAnimation:anis forKey:@"transfChange"];
    
    [UIView animateWithDuration:0.15 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [self beginDeformationAnimation];
        }];
    }];
}

//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    if ([self.layer animationForKey:@"transfChange"] == anim) {
//        //形变结束开始弹幕动画
//        [self creatDanmakuViewByTrajectory:3];
//        [self performSelector:@selector(stopAreaDanmakuAnimation) withObject:nil afterDelay:self.runDuration];
//    }
//}

- (void)beginDeformationAnimation {
    //形变同时改变渐变背景
    CCWS(weakSelf)
    [UIView animateWithDuration:deformationDuration animations:^{
        [self setWidth:self.targetWidth];
        self.gradientLayer.frame = self.bounds;
    } completion:^(BOOL finished) {
        //添加点击手势
        [self whenTapped:^{
            if (weakSelf.dmTapActionBlock) {
                weakSelf.dmTapActionBlock(weakSelf.danmakuMsgInfo);
            }
        }];
        //形变结束开始弹幕动画
        [self creatDanmakuViewByTrajectory:3];
        [self performSelector:@selector(stopAreaDanmakuAnimation) withObject:nil afterDelay:self.runDuration];
    }];
}

- (void)creatDanmakuViewByTrajectory:(NSInteger)trajectory {
    if ([CCTool isNotBlank:_danmakuMsgInfo]) {
        CCDanmakuView *danmakuView = [CCDanmakuView creatDanmakuView:_danmakuMsgInfo inView:self.scrollBgView speed:65 trajectory:trajectory];
        [danmakuView setX:self.scrollBgView.width];
        [danmakuView setY:(self.scrollBgView.height-danmakuView.height)/2.f];
        CCWS(weakSelf)
        [danmakuView setMoveAnimationBlock:^(CCDanmakuMoveStatus status) {
            if (status == CCDanmakuMoveStart) {
                DebugLog(@"开始");
            } else if (status == CCDanmakuMoveEnter) {
                DebugLog(@"出现下一个");
                [weakSelf creatDanmakuViewByTrajectory:trajectory];
            } else if (status == CCDanmakuMoveEnd) {
                DebugLog(@"结束");
            }
        }];
        [self.scrollBgView addSubview:danmakuView];
        [_normalDanmakuViews addObject:danmakuView];
        [danmakuView startDanmakuAnimation];
    }
}

- (void)stopAreaDanmakuAnimation {
    [_normalDanmakuViews makeObjectsPerformSelector:@selector(stopDanmakuAnimation)];
    [_normalDanmakuViews removeAllObjects];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopAreaDanmakuAnimation) object:nil];
    [UIView animateWithDuration:deformationDuration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.dmFinishedBlock) {
            self.dmFinishedBlock(self.danmakuMsgInfo);
        }
    }];
}

@end
