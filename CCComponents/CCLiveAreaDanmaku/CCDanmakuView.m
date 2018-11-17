//
//  CCDanmakuView.m
//  Dong
//
//  Created by Dong on 2018/5/11.
//  Copyright © 2018年 Dong. All rights reserved.
//

#define kDanmakuNextSpace 50
#define kDanmakuHeight 38
////速率每秒50pt
//#define kDanmakuSpeed 50.f
//#define kDanmakuDuration 10

#import "CCDanmakuView.h"

@interface CCDanmakuView ()

@property (nonatomic, strong) YYLabel *titleLbl;
@property (nonatomic, strong) UIImageView *leftImg;
@property (nonatomic, strong) CCDanmuGiftInfo *info;
@property (nonatomic, strong) UIView *inView;
@property (nonatomic, assign) float speed;
@property (nonatomic, assign) NSInteger trajectory;

@end

@implementation CCDanmakuView

+ (instancetype)creatDanmakuView:(CCDanmuGiftInfo *)info inView:(UIView *)inView
                           speed:(float)speed trajectory:(NSInteger)trajectory {
    return [[self alloc] initWithInfo:info inView:inView speed:speed trajectory:trajectory];
}

- (instancetype)initWithInfo:(CCDanmuGiftInfo *)info inView:(UIView *)inView
                       speed:(float)speed trajectory:(NSInteger)trajectory {
    _inView = inView;
    _info = info;
    _speed = speed;
    _trajectory = trajectory;
    CGRect frame = CGRectMake(0,(_trajectory==3 ?(_inView.height-17)/2.f :0), 50, _trajectory<=2 ?kDanmakuHeight :17);
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.titleLbl];
    [_titleLbl setAttributedText:[self attContentStr]];
    float textWidth = 0;
    if (_trajectory == 3) {
        float danmakuWidth = [CCTool getWidth:_info.content font:kBoldHelvetica(12)];
        textWidth = danmakuWidth<30 ?30 :danmakuWidth;
    } else {
        //特殊字符计算会失败
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(CGFLOAT_MAX, self.height) text:_titleLbl.attributedText];
        textWidth = layout.textBoundingSize.width<30 ?30 :layout.textBoundingSize.width;
    }
    [_titleLbl setWidth:textWidth];

    float width = textWidth+self.height;
    BOOL hasIcon = NO;
    if ([CCTool isNotBlank:_info.avartar]) {
        hasIcon = YES;
        [self addSubview:self.leftImg];
        width += self.leftImg.width;
    }
    [_titleLbl setX:hasIcon ?_leftImg.right :kDanmakuHeight/2.f];
    [self setWidth:width];
    [self setX:_inView.width];
    
//    kViewRadius(self, kDanmakuHeight/2.f);
}

- (UIImageView *)leftImg {
    if (!_leftImg) {
        _leftImg = [UIImageView createF:(CGRect){0,0,30,self.height} Img:[UIImage imageWithColor:[UIColor colorWithHexString:@"efefef"]]];
        kViewRadius(_leftImg, self.height/2);
    }
    return _leftImg;
}

- (YYLabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[YYLabel alloc] initWithFrame:(CGRect){0,0,100,self.height}];
        _titleLbl.numberOfLines = 1;
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _titleLbl.backgroundColor = [UIColor clearColor];
        if (_trajectory != 3) {
            //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
            _titleLbl.layer.shadowColor = [UIColor colorWithHexString:@"38362a" alpha:1].CGColor;
            _titleLbl.layer.shadowOffset = CGSizeMake(0,0);
            _titleLbl.layer.shadowOpacity = 0.9;
            _titleLbl.layer.shadowRadius = 2;
        }
    }
    return _titleLbl;
}

- (NSMutableAttributedString *)attContentStr {
    NSMutableAttributedString *attr = nil;
    NSString *reltext = @"";
    if (_trajectory < 2) { //游记普通弹幕
        if ([CCTool isNotBlank:_info.content]) {
            reltext = _info.content;
        }
        attr = [[NSMutableAttributedString alloc] initWithString:reltext];
        attr.yy_font = kBoldHelvetica(18);
        attr.yy_color = [UIColor colorWithHexString:@"ffffff"];
    } else if (_trajectory == 2) { //礼物
        reltext = [NSString stringWithFormat:@"%@送了一个%@",_info.from_nickname,_info.gift_name];
        attr = [[NSMutableAttributedString alloc] initWithString:reltext];
        attr.yy_font = kBoldHelvetica(18);
        NSRange leftRange = [reltext rangeOfString:_info.from_nickname];
        NSRange rightRange = [reltext rangeOfString:_info.gift_name];
        [attr yy_setColor:[UIColor colorWithHexString:@"ffffff"] range:NSMakeRange(0, reltext.length)];
        [attr yy_setColor:[UIColor colorWithHexString:@"ffd500"] range:leftRange];
        [attr yy_setColor:[UIColor colorWithHexString:@"ffd500"] range:rightRange];
    } else if (_trajectory == 3) { //直播间全区弹幕
        if ([CCTool isNotBlank:_info.content]) {
            reltext = _info.content;
        }
        attr = [[NSMutableAttributedString alloc] initWithString:reltext];
        attr.yy_font = kBoldHelvetica(12);
        attr.yy_color = [UIColor colorWithHexString:@"ffffff"];
    }
//    NSShadow *shadow = [NSShadow new];
//    shadow.shadowColor = [UIColor colorWithHexString:@"38362a" alpha:1];
////    shadow.shadowColor = [UIColor colorWithHexString:@"ffd500" alpha:0.6];
//    shadow.shadowOffset = CGSizeMake(0,0);
//    shadow.shadowBlurRadius = 5;
//    attr.yy_shadow = shadow;
    return attr;
}


- (void)startDanmakuAnimation {
    if (_moveAnimationBlock) {
        _moveAnimationBlock(CCDanmakuMoveStart);
    }
    float moveSumWidth = 0; //总移动距离
    if (_trajectory < 3) {
        moveSumWidth = self.width+kScreenWidth;
    } else if (_trajectory == 3) {
        moveSumWidth = self.width+_inView.width;
    }
    /*
     速率 speed = w/t 宽度越大,速度越快
     float speed = moveSumWidth/kDanmakuDuration;
     NSTimeInterval enterDuration = (self.width+kDanmakuNextSpace)/speed;
     */
    //采用弹道随机速率
    NSTimeInterval relDuration =  moveSumWidth/_speed;
    NSTimeInterval enterDuration = (self.width+kDanmakuNextSpace)/_speed;
    [self performSelector:@selector(enterCallBack) withObject:nil afterDelay:enterDuration];
//    self.layer.timeOffset
    [UIView animateWithDuration:relDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.x = -self.width;
    } completion:^(BOOL finished) {
        [self stopDanmakuAnimation];
        if (self.moveAnimationBlock) {
            self.moveAnimationBlock(CCDanmakuMoveEnd);
        }
    }];
}

- (void)stopDanmakuAnimation {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

- (void)enterCallBack {
    if (_moveAnimationBlock) {
        _moveAnimationBlock(CCDanmakuMoveEnter);
    }
}

@end
