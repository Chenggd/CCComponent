//
//  CCCircleBannerView.m
//  CCCustomComponent
//
//  Created by Chenggd on 2018/9/27.
//  Copyright © 2018 Dong. All rights reserved.
//

#import "CCCircleBannerView.h"
#import "UIView+WhenTappedBlocks.h"

@interface CCCircleBannerView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) scrollItemHandler handle;
@property (nonatomic, copy) scrollDidHandler scrollHandle;

@end


@implementation CCCircleBannerView

+ (instancetype)creatCircleBannerView:(CGRect)frame
                           dataSource:(NSMutableArray *)dataSource
                    scrollItemHandler:(scrollItemHandler)handle
                     scrollDidHandler:(scrollDidHandler)scrollHandle {
    return [[self alloc] initWithFrame:frame dataSource:dataSource scrollItemHandler:handle scrollDidHandler:scrollHandle];
}

- (instancetype)initWithFrame:(CGRect)frame
                   dataSource:(NSMutableArray *)dataSource
            scrollItemHandler:(scrollItemHandler)handle
             scrollDidHandler:(scrollDidHandler)scrollHandle {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        _dataSource = dataSource;
        _handle = handle;
        _scrollHandle = scrollHandle;
        _space = 30;
        _ratioBySpace = 4;
        [self configUI];
    }
    return self;
}

- (void)configUI {
    CGRect frame = self.frame;
    frame.origin.y = 0;
    
    CCTouchView *bgView = [[CCTouchView alloc] initWithFrame:frame];
    [self addSubview:bgView];
    UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(_space/4*3, 0, self.width-_space/4*3*2, self.height)];
    bgScrollView.showsHorizontalScrollIndicator = NO;
    bgScrollView.delegate = self;
    bgScrollView.pagingEnabled = YES;
    bgScrollView.clipsToBounds = NO;
    [bgView addSubview:bgScrollView];
    _bgScrollView = bgScrollView;
    bgView.receiver = bgScrollView;
    
    [self reloadItemView];
}

- (void)reloadItemView {
    [_bgScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    float space = 0;
    float width = 0;
    float viewWidth = 0;
    CCWS(weakSelf)
    for (int i =0; i<(_dataSource.count ?_dataSource.count :1); i++) {
        CCHomeBannerInfo *info = nil;
        if (_dataSource.count) {
            info = (CCHomeBannerInfo *)_dataSource[i];
        } else {
            info = [[CCHomeBannerInfo alloc] init];
        }
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_home_banner"]];
        [image whenTapped:^{
            if (weakSelf.tapCirBannerHandler) {
                weakSelf.tapCirBannerHandler(info);
            }
        }];
        if (i == 0) {
            viewWidth = self.width-_space*2;
        }
        space = self.width - viewWidth;
        image.layer.cornerRadius = 5.0f;
        width = viewWidth + space/4;
        [image setFrame:CGRectMake(viewWidth*i+space/4*i+_space/4, 10, viewWidth, self.height-10-20)];
        CGFloat y = i * width;
        CGFloat value = (0-y)/width;
        CGFloat scale = fabs(cos(fabs(value)*M_PI/_ratioBySpace));
        image.transform = CGAffineTransformMakeScale(1.0, scale);
        [_bgScrollView addSubview:image];
        [image yy_setImageWithURL:[NSURL URLWithString:info.imgUrl] placeholder:[UIImage imageNamed:@"live_home_banner"]];
    }
    
    [_bgScrollView setContentSize:CGSizeMake((self.width-_space/4*3*2)*(_dataSource.count?_dataSource.count:1), 0)];
    [_bgScrollView setContentOffset:(CGPoint){0,0} animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    if (offset < 0) {
        return;
    }
    _scrollHandle(scrollView.contentOffset.x, (self.width-_space/4*3*2));
    
    float space = 0;
    float viewWidth = 0;
    for (UIImageView *view in _bgScrollView.subviews) {
        NSInteger index = [_bgScrollView.subviews indexOfObject:view];
        if (index == 0) {
            viewWidth = view.frame.size.width;
        }
        space = self.width- viewWidth;
        CGFloat width = viewWidth + space/4;
        CGFloat y = index * width;
        CGFloat value = (offset-y)/width;
        CGFloat scale = fabs(cos(fabs(value)*M_PI/_ratioBySpace));
        view.transform = CGAffineTransformMakeScale(1.0, scale);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x/(self.width-_space/4*3*2);
    _handle(index);
}

- (CGRect)newFrame:(CGRect)oldFrame height:(float)height {
    CGRect frame = oldFrame;
    frame.size.height = height;
    return frame;
}

- (void)reloadCircleBannerData:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    [self reloadItemView];
}

@end


@implementation CCTouchView
@synthesize receiver;

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        return self.receiver;
    }
    return nil;
}

@end
