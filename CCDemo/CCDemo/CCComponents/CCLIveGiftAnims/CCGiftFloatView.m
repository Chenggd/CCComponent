//
//  CCGiftFloatView.m
//  CCCustomComponent
//
//  Created by Chenggd on 2018/7/4.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import "CCGiftFloatView.h"

@interface CCGiftFloatView ()<CAAnimationDelegate,YYAnimatedImage>

@property (nonatomic, strong) YYAnimatedImageView *animaView;
@property (nonatomic, strong) NSMutableArray *iconPaths;
@property (nonatomic, strong) NSMutableArray *iconTimes;

@end

@implementation CCGiftFloatView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _iconPaths = [NSMutableArray arrayWithCapacity:0];
        _iconTimes = [NSMutableArray arrayWithCapacity:0];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.animaView];
}

- (void)setGiftInfo:(CCLiveGiftMsgInfo *)giftInfo {
    _giftInfo = giftInfo;
    [self matchGiftCacheAssets];
}

- (void)matchGiftCacheAssets {
    [_iconPaths removeAllObjects];
    [_iconTimes removeAllObjects];
    //查找本地对应的礼物
    NSString *cacheKey = [NSString stringWithFormat:@"%@%ld",_giftInfo.type,_giftInfo.giftId];
    BOOL hasCache = NO;
    id cacheVer = [[CCController shareCCController] getDataByKey:cacheKey];
    if ([CCTool isNotBlank:cacheVer] && [cacheVer floatValue] >0) { //有资源
        hasCache = YES;
    }
    
    if (hasCache) {
        NSString *documentPath = GiftPathFile(cacheKey);
        NSString *iconNamePrefix = @"";
        NSTimeInterval animDuration = 0.f;
        int fromIconNum = 0;
        int endIconNum = 0;
        CGFloat relWidth = self.width;
        CGFloat relHeight = self.height;
        NSData *data = [NSData dataWithContentsOfFile:GiftVerInfoFile(documentPath)];
        if ([CCTool isNotBlank:data]) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"资源版本信息:%@",dic);
            NSDictionary *giftConfig = dic[@"gift"];
            if ([CCTool isNotBlank:giftConfig]) {
                NSDictionary *animConfig = giftConfig[@"animation"];
                fromIconNum = [animConfig[@"from"] intValue];
                endIconNum = [animConfig[@"end"] intValue];
                animDuration = [animConfig[@"duration"] floatValue]/(endIconNum+1);
                iconNamePrefix = [NSString stringWithFormat:@"%@_",giftConfig[@"giftImageIdentity"]];
                float tempWidth = [giftConfig[@"imageWidth"] floatValue];
                float tempHeight = [giftConfig[@"imageHeight"] floatValue];
                float ratio = tempWidth/tempHeight;
                //先等比例改变高,高完全放下了，宽不一定放下
                if (tempHeight > self.height) {
                    relHeight = self.height;
                } else {
                    relHeight = tempHeight;
                }
                relWidth = relHeight*ratio;
                //再对比宽
                if (relWidth > self.width) {
                    relWidth = self.width;
                }
                //自适应高
                relHeight = relWidth/ratio;
//                //依高为基准方案～
//                relHeight = MIN(tempHeight, self.height);
//                relWidth = relHeight*ratio;
            }
        }
//        //解码
//        YYImageEncoder *webpEncoder = [[YYImageEncoder alloc] initWithType:YYImageTypeWebP];
//        webpEncoder.loopCount = 1;
        if ([CCTool isNotBlank:iconNamePrefix]) {
            for (int i=fromIconNum; i<(endIconNum+1); i++) {
                NSString *path = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@%d.png",iconNamePrefix,i]];
//                NSString *path = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@%d.webp",iconNamePrefix,i]];
//                NSData *data = [NSData dataWithContentsOfFile:path];
                if ([CCTool isNotBlank:path]) {
                    [_iconPaths addObject:path];
                    [_iconTimes addObject:@(animDuration)];
//                    //解码转换为UIImage data
//                    YYImageDecoder *decoder = [YYImageDecoder decoderWithData:data scale:2.0];
//                    UIImage *img = [decoder frameAtIndex:0 decodeForDisplay:YES].image;
//                    NSData *data1 = UIImagePNGRepresentation(img);
//                    [_iconPaths addObject:data1];
                } else {
                    break;
                }
            }
            //配置动画帧图片
            YYFrameImage *image = [[YYFrameImage alloc] initWithImagePaths:_iconPaths frameDurations:_iconTimes loopCount:1];
//            [self.animaView setAnimationImages:_iconPaths];
//            YYFrameImage *image = [[YYFrameImage alloc] initWithImageDataArray:_iconPaths frameDurations:_iconTimes loopCount:1];
            [self.animaView setImage:image];
            [self.animaView setFrame:(CGRect){0,0,relWidth,relHeight}];
            [self.animaView setCenter:self.center];
            _hasAnimCache = YES;
        } else {
            NSLog(@"服务端配置出错～");
            _hasAnimCache = NO;
        }
    } else {
        _hasAnimCache = NO;
        NSLog(@"本地没有该特效礼物～");
    }
}

- (YYAnimatedImageView *)animaView {
    if (!_animaView) {
        _animaView = [[YYAnimatedImageView alloc] initWithFrame:self.bounds];
        _animaView.autoPlayAnimatedImage = NO;
        [_animaView addObserver:self forKeyPath:@"currentAnimatedImageIndex" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _animaView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentAnimatedImageIndex"]) {
        NSInteger curIndex = [change[@"new"] integerValue];
        NSInteger sumCount = _iconPaths.count;
//        NSLog(@"curIndex:%zd",curIndex);
        if (curIndex == sumCount-1) {
            [self stopGiftAnimation];
        }
    }
}

//展示礼物特效
- (void)startGiftAnimation {
    _giftInfo.gift_number -= 1;
    //缩放动画 (暂时废弃～)
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    [animation setFromValue:[NSNumber numberWithFloat:0]];
//    [animation setToValue:[NSNumber numberWithFloat:1]];
//    [animation setDuration:0.2];
//    animation.removedOnCompletion = NO;
//    animation.autoreverses = NO;
//    animation.fillMode = kCAFillModeForwards;
//    animation.delegate = self;
//    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//    //    [animation setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.4f :1.3f :1.f :1.f]];
//    [_animaView.layer addAnimation:animation forKey:@"float_gift_scale"];
    
    [_animaView startAnimating];
}

//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    if ([_animaView.layer animationForKey:@"float_gift_scale"] == anim) {
//        [_animaView startAnimating];
//    }
//}

- (void)stopGiftAnimation {
    
    [_animaView.layer removeAllAnimations];
    [_animaView removeObserver:self forKeyPath:@"currentAnimatedImageIndex"];
    
    [_animaView stopAnimating];
    [self removeFromSuperview];
    if (_floatFinishedBlock) {
        _floatFinishedBlock(_giftInfo.gift_number>0, _giftInfo);
    }
}

@end
