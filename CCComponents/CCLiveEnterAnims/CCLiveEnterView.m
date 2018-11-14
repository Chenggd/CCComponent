//
//  CCLiveEnterView.m
//  BeautyBeeTravel
//
//  Created by Dong on 2018/8/8.
//  Copyright © 2018年 美蜂. All rights reserved.
//

#import "CCLiveEnterView.h"
#import "NTESTimerHolder.h"
#import "CCGradientView.h"
#import "CCGiftFloatView.h"
#import "CCLiveGiftMsgInfo.h"

@interface CCLiveEnterView ()<NTESTimerHolderDelegate>

@property (nonatomic, assign) float bgWidth;
@property (nonatomic, assign) float bgHeight;
@property (nonatomic, assign) float headHeight;
@property (nonatomic, strong) UIColor *firstColor;
@property (nonatomic, strong) UIColor *secondColor;
@property (nonatomic, strong) UIColor *contentColor;
@property (nonatomic, strong) UIColor *desColor;
@property (nonatomic, strong) UIColor *rowsColor;
@property (nonatomic, strong) UIColor *rowsTitleColor;
@property (nonatomic, strong) NSString *contentStr;
@property (nonatomic, strong) NSString *desStr;

@property (nonatomic, strong) CCGradientView *bgView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *carView;
@property (nonatomic, strong) YYLabel *enterLbl;

@property (nonatomic, assign) BOOL isRunAnimation;
@property (nonatomic, assign) NSTimeInterval willApperaDuration;
@property (nonatomic, strong) NTESTimerHolder *willApperaTimer;

@end

#define LEnterShowDuration 0.3
#define LEnterHideDuration 0.3
#define LEnterWillApperaDuration 2

@implementation CCLiveEnterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgView];
        [self addSubview:self.contentView];
        _willApperaTimer = [[NTESTimerHolder alloc] init];
        _enterStatus = CCLiveEnterIdle;
    }
    return self;
}

- (CCGradientView *)bgView {
    if (!_bgView) {
        _bgView = [CCGradientView createF:self.bounds BC:[UIColor clearColor]];
    }
    return _bgView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView createF:self.bounds BC:[UIColor clearColor]];
    }
    return _contentView;
}

- (YYLabel *)enterLbl {
    if (!_enterLbl) {
        _enterLbl = [YYLabel new];
    }
    return _enterLbl;
}

- (void)setEnterInfo:(CCLiveAudienceInfo *)enterInfo {
    if (_enterInfo != enterInfo) {
        _enterInfo = enterInfo;
        //若用户有座驾/VIp/上榜 则展示进场特效 并存时展示优先级为上榜>vip>座驾
        if (_enterInfo) {
            //清除旧图层
            [self.contentView removeAllSubViews];
            [self.contentView addSubview:self.enterLbl];
            //配置参数
            BOOL needBorder = NO;
            self.desStr = @" 来了";
            self.contentStr = [self transfromContentStr];
            self.desColor = [UIColor colorWithHexString:@"ffffff" alpha:0.7];
            self.contentColor = [UIColor colorWithHexString:@"ffffff" alpha:1];
            [self.bgView.layer setMasksToBounds:NO];
            self.style = CCLELeftToRight;
            if (_enterInfo.use_car ||
                _enterInfo.role_id == 1 ||
                _enterInfo.rows > 0) {
                if (_enterInfo.rows > 0) { //上榜+（是否有座驾）
                    self.bgHeight = 24;
                    self.headHeight = 28;
                    self.desStr = @" 进入直播间";
                    self.style = CCLERightToLeft;
                    if (_enterInfo.rows == 1) {
                        self.desColor = [UIColor colorWithHexString:@"685501" alpha:0.7];
                        self.contentColor = [UIColor colorWithHexString:@"685501" alpha:1];
                        self.rowsColor = [UIColor colorWithHexString:@"ffd817" alpha:1];
                        self.rowsTitleColor = [UIColor colorWithHexString:@"746103" alpha:1];
                        self.firstColor = [UIColor colorWithHexString:@"ffec00" alpha:1];
                        self.secondColor = [UIColor colorWithHexString:@"ffec00" alpha:1];
                    } else if (_enterInfo.rows == 2) {
                        self.rowsColor = [UIColor colorWithHexString:@"cccfe5" alpha:1];
                        self.rowsTitleColor = [UIColor colorWithHexString:@"414351" alpha:1];
                        self.firstColor = [UIColor colorWithHexString:@"d8d4dd" alpha:1];
                        self.secondColor = [UIColor colorWithHexString:@"959db4" alpha:1];
                    } else if (_enterInfo.rows == 3) {
                        self.rowsColor = [UIColor colorWithHexString:@"ffbe97" alpha:1];
                        self.rowsTitleColor = [UIColor colorWithHexString:@"93705f" alpha:1];
                        self.firstColor = [UIColor colorWithHexString:@"caa28d" alpha:1];
                        self.secondColor = [UIColor colorWithHexString:@"e29573" alpha:1];
                    } else {
                        self.rowsColor = [UIColor colorWithHexString:@"f0c57d" alpha:1];
                        self.rowsTitleColor = [UIColor colorWithHexString:@"7c530c" alpha:1];
                        self.firstColor = [UIColor colorWithHexString:@"caa28d" alpha:1];
                        self.secondColor = [UIColor colorWithHexString:@"d29e43" alpha:1];
                    }
                    
                    UIView *headBg = [UIView createF:(CGRect){0,0,self.headHeight,self.headHeight} BC:self.firstColor];
                    kViewRadius(headBg, headBg.height/2.f);
                    [self.contentView addSubview:headBg];
                    UIImage *icon = [UIImage imageNamed:@"live_default_head"];
                    UIImageView *headImg = [UIImageView createF:(CGRect){1,1,headBg.height-2,headBg.height-2} Img:icon];
                    kViewRadius(headImg, headImg.height/2.f);
                    [headBg addSubview:headImg];
                    
                    [self.bgView setX:headBg.height/2];
                    [self.bgView setY:self.headHeight-self.bgHeight];
                    
                    NSString *str = [NSString stringWithFormat:@"%@%zd",_enterInfo.row_content,_enterInfo.rows];
                    UILabel *lbl = [UILabel createF:(CGRect){headBg.right+5,self.bgView.top+(self.bgHeight-13)/2,32,13} TC:self.rowsTitleColor FT:kBoldHelvetica(9) T:str AL:NSTextAlignmentCenter];
                    [lbl setBackgroundColor:self.rowsColor];
                    [self.contentView addSubview:lbl];
                    [self setUpContentLblText];
                    [_enterLbl setX:lbl.right+5];
                    self.bgWidth = _enterLbl.right+20-self.headHeight/2;
                    
                    //加载头像
                    [headImg yy_setImageWithURL:[NSURL URLWithString:_enterInfo.avatar] placeholder:icon];
                    //重绘背景
                    [self.bgView setWidth:self.bgWidth];
                    [self.bgView setHeight:self.bgHeight];
                    kViewRadius(self.bgView, 3.f);
                    [self setHeight:self.headHeight];
                } else if (_enterInfo.role_id == 1) { //VIP+（是否有座驾）
                    needBorder = YES;
                    self.bgHeight = 24;
                    self.bgView.bordColor = [UIColor colorWithHexString:@"ffd500" alpha:1];
                    self.bgView.bordTColor = [UIColor colorWithHexString:@"ffd500" alpha:0.3];
                    self.firstColor = [UIColor colorWithHexString:@"000000" alpha:0.7];
                    self.secondColor = [UIColor colorWithHexString:@"000000" alpha:0];
                    self.contentColor = [UIColor colorWithHexString:@"ffd500" alpha:1];
                    
                    UIImage *icon = [UIImage imageNamed:@"live_enter_vip"];
                    UIImageView *vipImg = [UIImageView createF:(CGRect){0,0,30,self.bgHeight} Img:icon];
                    [self.contentView addSubview:vipImg];
                    
                    [self.bgView setX:vipImg.right-1];
                    [self.bgView setY:0];
                    if ([CCTool isNotBlank:_contentStr]) {
                        _contentStr = [@"尊贵的" stringByAppendingString:_contentStr];
                    }
                    [self setUpContentLblText];
                    [_enterLbl setX:vipImg.right+5];
                    UIImage *starIcon = [UIImage imageNamed:@"live_enter_star"];
                    UIImageView *starImg = [UIImageView createF:(CGRect){_enterLbl.right+20,(self.bgHeight-15)/2,36,15} Img:starIcon];
                    [self.contentView addSubview:starImg];
                    self.bgWidth = starImg.right-25;
                    
                    //重绘背景
                    [self.bgView setWidth:self.bgWidth];
                    [self.bgView setHeight:self.bgHeight];
                    [self setHeight:self.bgHeight];
                } else if ([CCTool isNotBlank:_enterInfo.use_car]) { //仅有座驾
                    self.bgHeight = 24;
                    self.headHeight = 24-2;
                    self.firstColor = [UIColor colorWithHexString:@"ff5100" alpha:1];
                    self.secondColor = [UIColor colorWithHexString:@"ff9800" alpha:1];
                    
                    UIImage *icon = [UIImage imageNamed:@"live_default_head"];
                    UIImageView *headImg = [UIImageView createF:(CGRect){1,1,self.headHeight,self.headHeight} Img:icon];
                    [self.contentView addSubview:headImg];
                    kViewRadius(headImg, self.headHeight/2.f);
                    [self.bgView setX:0];
                    [self.bgView setY:0];
                    
                    [self setUpContentLblText];
                    [_enterLbl setX:headImg.right+1+5];
                    self.bgWidth = _enterLbl.right+20+self.bgHeight/2.f;
                    //加载头像
                    [headImg yy_setImageWithURL:[NSURL URLWithString:_enterInfo.avatar] placeholder:icon];
                    //重绘背景
                    [self.bgView setWidth:self.bgWidth];
                    [self.bgView setHeight:self.bgHeight];
                    kViewRadius(self.bgView, self.bgHeight/2.f);
                    [self setHeight:self.bgHeight];
                }
            }
            
            [self setWidth:self.bgView.right];
            
            self.contentView.frame = self.bounds;
            self.bgView.needBorder = needBorder;
            self.bgView.firstColor = self.firstColor;
            self.bgView.secondColor = self.secondColor;
//            [self.bgView setNeedsLayout];
//            [self.bgView layoutIfNeeded];
            [self.bgView refreshLayer];
        }
    }
}

//文案信息
- (NSString *)transfromContentStr {
    NSString *car = @"";
    if ([CCTool isNotBlank:_enterInfo.use_car]) {
        car = _enterInfo.use_car[@"car_name"];
    }
    NSString *content = [NSString stringWithFormat:@"%@",_enterInfo.nickname];
    if ([CCTool isNotBlank:car]) {
        content = [NSString stringWithFormat:@"%@乘坐%@",_enterInfo.nickname,car];
    }
    return content;
}

- (void)setUpContentLblText {
    NSString *content = [NSString stringWithFormat:@"%@%@",_contentStr,_desStr];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:content];
    [attStr addAttribute:NSForegroundColorAttributeName value:_contentColor range:(NSRange){0,_contentStr.length}];
    [attStr addAttribute:NSForegroundColorAttributeName value:_desColor range:(NSRange){_contentStr.length,_desStr.length}];
    [attStr addAttribute:NSFontAttributeName value:kBoldHelvetica(12) range:NSMakeRange(0, content.length)];
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(CGFLOAT_MAX, self.bgHeight) text:attStr];
    _enterLbl.size = layout.textBoundingSize;
    _enterLbl.textLayout = layout;
    [_enterLbl setY:self.bgView.top+(self.bgHeight-_enterLbl.height)/2+1];
}

#pragma mark - Animations
- (void)setEnterStatus:(CCLiveEnterStatus)enterStatus {
    _enterStatus = enterStatus;
    if (_enterStatus == CCLiveEnterIdle) {
        _enterInfo = nil;
    }  else if (_enterStatus == CCLiveEnterWillAppera) {
        _willApperaDuration = LEnterWillApperaDuration;
        [_willApperaTimer startTimer:1 delegate:self repeats:YES];
    } else if (_enterStatus == CCLiveEnterShow) {
        [self showEnterAnimation];
    } else if (_enterStatus == CCLiveEnterAppera) {
        [self hideEnterAnimation];
    }
}

//开始显示动画
- (void)showEnterAnimation {
    if (!_isRunAnimation) {
        _isRunAnimation = YES;
        if (_style == CCLELeftToRight) {
            self.x = -self.width;
        } else if (_style == CCLERightToLeft) {
            self.x = self.screenView.width;
        } else if (_style == CCLEScattered) {
            self.x = self.screenView.width;
        }
        self.alpha = 1;
        [UIView animateWithDuration:LEnterShowDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.x = 10;
        } completion:^(BOOL finished) {
            self.isRunAnimation = NO;
            [self desposeShowCarAnimation];
        }];
    }
}

//处理座驾动画
- (void)desposeShowCarAnimation {
    NSInteger car_id = [_enterInfo.use_car[@"car_id"] integerValue];
    if ([CCTool isNotBlank:_enterInfo.use_car] && car_id != 0) {
        CCLiveGiftMsgInfo *info = [CCLiveGiftMsgInfo new];
        info.giftId = [_enterInfo.use_car[@"car_id"] integerValue];
        info.type = AnimaCarTypeKey;
        info.gift_number = 1;
        [self showFloatView:info];
    } else {
        self.enterStatus = CCLiveEnterWillAppera;
    }
}

//开始消失动画
- (void)hideEnterAnimation {
    if (!_isRunAnimation) {
        _isRunAnimation = YES;
        [UIView animateWithDuration:LEnterHideDuration animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            self.isRunAnimation = NO;
            self.enterStatus = CCLiveEnterIdle;
            if (self.liveEnterStatusBlock) {
                self.liveEnterStatusBlock(CCLiveEnterIdle);
            }
        }];
    }
}

/**
 还原状态
 */
- (void)restoreToOrginStatus {
    [_willApperaTimer stopTimer];
    [self.layer removeAllAnimations];
    [self stopAllGiftAnimations];
    
    _isRunAnimation = NO;
    [self setX:-self.width];
    [self setY:0];
}

- (void)showFloatView:(CCLiveGiftMsgInfo *)giftInfo {
    //    NSLog(@"enenen： %zd",giftInfo.gift_number);
    CCGiftFloatView *floatView = [[CCGiftFloatView alloc] initWithFrame:_animaScreenView.bounds];
    [floatView setGiftInfo:[giftInfo mutableCopy]];
    CCWS(weakSelf)
    [floatView setFloatFinishedBlock:^(BOOL needGoon, CCLiveGiftMsgInfo *curGiftInfo) {
        NSLog(@"动画结束～");
        if (weakSelf.willApperaTimer) {
            [weakSelf.willApperaTimer stopTimer];
            weakSelf.enterStatus = CCLiveEnterAppera;
        }
    }];
    //展示进房特效
    if (floatView.hasAnimCache) {
        //本地特效资源已下载成功
        [_animaScreenView addSubview:floatView];
        [floatView startGiftAnimation];
    } else {
        self.enterStatus = CCLiveEnterWillAppera;
        NSLog(@"本地无资源");
    }
}

#pragma mark - NTESTimerHolderDelegate
- (void)onNTESTimerFired:(NTESTimerHolder *)holder {
    if (_willApperaTimer == holder) {
        //检测礼物弹幕即将消失的倒计时
        _willApperaDuration -= 1;
        if (_willApperaDuration <= 0) {
            NSLog(@"即将消失");
            [_willApperaTimer stopTimer];
            self.enterStatus = CCLiveEnterAppera;
        }
    }
}

- (void)stopAllGiftAnimations {
    //清除特效
    [_animaScreenView.subviews makeObjectsPerformSelector:@selector(stopGiftAnimation)];
}

@end
