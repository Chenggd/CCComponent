//
//  CCLiveScrollBanner.m
//  CCCustomComponent
//
//  Created by Dong on 2018/6/19.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import "CCLiveScrollBanner.h"
#import "UIView+WhenTappedBlocks.h"
#import "CCPageControl.h"

@interface CCLiveScrollBanner ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (nonatomic, strong) NSTimer *autoScrollTimer;
@property (nonatomic, strong) CCPageControl *pageControl;
@property (nonatomic, strong) UIImageView *centerImg;
@property (nonatomic, strong) UIImageView *leftImg;
@property (nonatomic, strong) UIImageView *rightImg;
@property (nonatomic, strong) UIImage *defaultIcon;

@property (nonatomic, assign) NSInteger leftImgIndex, rightImgIndex;
//独立的pageIndex,最多3页
@property (nonatomic, assign) NSInteger pageIndex;

@end

#define kAutoScrollInterval 3

@implementation CCLiveScrollBanner

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgScrollView];
        [self addSubview:self.pageControl];
        _defaultIcon = [UIImage imageWithColor:[UIColor colorWithHexString:@"f4f4f4"]];
    }
    return self;
}

- (UIScrollView *)bgScrollView {
    if (!_bgScrollView) {
        _bgScrollView = [UIScrollView createF:CGRectMake(0, 0, self.width, self.height-20) CS:(CGSize){self.width,0} BC:[UIColor clearColor]];
        _bgScrollView.delegate = self;
        _bgScrollView.pagingEnabled = YES;
        _bgScrollView.bounces = YES;
        _bgScrollView.scrollsToTop = NO;
        CCWS(weakSelf)
        [_bgScrollView whenTapped:^{
            if (weakSelf.bannerData.count>weakSelf.curIndex) {
                CCHomeBannerInfo *info = weakSelf.bannerData[weakSelf.curIndex];
                if (weakSelf.tapLiveBannerBlock) {
                    weakSelf.tapLiveBannerBlock(info);
                }
            }
        }];
    }
    return _bgScrollView;
}

- (CCPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[CCPageControl alloc] initWithFrame:CGRectMake((self.width-100)/2, self.height-20, 100, 20) activeImgStr:@"live_banner_page_sel" inactiveImgStr:@"live_banner_page_normal"];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.pageIndicatorTintColor = [UIColor clearColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor clearColor];
        _pageControl.numberOfPages = 1;
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

- (void)setBannerData:(NSMutableArray *)bannerData {
    if (_bannerData != bannerData) {
        _bannerData = bannerData;
        [self setAutoScroll:NO];
        [self setupBanner];
        self.curIndex = 0;
        if (_bannerData.count > 1) {
            [self setAutoScroll:YES];
        }
    }
}

- (void)setupBanner {
    [_bgScrollView removeAllSubViews];
    if (_bannerData.count) {
        _pageControl.hidden = NO;
        NSInteger baseItem = _bannerData.count>1 ?3 :1;
        for (int i=0; i<baseItem; i++) {
            UIImageView *cycleImg = [UIImageView createF:(CGRect){i*_bgScrollView.width,0,_bgScrollView.width,_bgScrollView.height} Img:_defaultIcon];
            [cycleImg setBackgroundColor:[UIColor clearColor]];
            kViewRadius(cycleImg, 5.f);
            [_bgScrollView addSubview:cycleImg];
            if (baseItem == 1) {
                _centerImg = cycleImg;
            } else {
                if (i == 0) { _leftImg = cycleImg; }
                else if (i == 1) { _centerImg = cycleImg; }
                else if (i == 2) { _rightImg = cycleImg; }
            }
        }
        [_bgScrollView setContentSize:(CGSize){(baseItem>1 ?baseItem*_bgScrollView.width :0),0}];
        _pageControl.numberOfPages = (_bannerData.count>=3 ?baseItem :(baseItem-1));
        _pageIndex = 0;
        _pageControl.currentPage = _pageIndex;
    } else {
        _pageControl.hidden = YES;
    }
    [self bringSubviewToFront:_pageControl];
    
}

#pragma mark - UIScrollViewDelegate
//手势滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //重载图片
    [self reloadCycleImg];
    //移动至中间
    [_bgScrollView setContentOffset:(CGPoint){_bgScrollView.width,0} animated:NO];
    //设置分页
    [_pageControl setCurrentPage:_pageIndex];
}

//自动滚动
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    //重载图片
    [self reloadCycleImg];
    //移动至中间
    [_bgScrollView setContentOffset:(CGPoint){_bgScrollView.width,0} animated:NO];
    //设置分页
    [_pageControl setCurrentPage:_pageIndex];
}

//开始拖拽需禁止定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.autoScroll = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.autoScroll = YES;
}

- (void)reloadCycleImg {
    if (_bannerData.count >_curIndex) {
        if (_bannerData.count == 1) {
            //重新设置左右图片
            CCHomeBannerInfo *info = _bannerData[_curIndex];
            [_centerImg yy_setImageWithURL:[NSURL URLWithString:info.imgUrl] placeholder:_defaultIcon];
        } else {
            CGPoint offset = _bgScrollView.contentOffset;
            if (offset.x>_bgScrollView.width) { //向右滑动
                _curIndex = (_curIndex+1)%_bannerData.count;
                _pageIndex += 1;
                if (_pageIndex >= _pageControl.numberOfPages) {
                    _pageIndex = 0;
                }
            } else if(offset.x<_bgScrollView.width){ //向左滑动
                _curIndex = (_curIndex+_bannerData.count-1)%_bannerData.count;
                _pageIndex -= 1;
                if (_pageIndex < 0) {
                    _pageIndex = (_pageControl.numberOfPages-1);
                }
            }
            
            //重新设置左右图片
            _leftImgIndex = (_curIndex+_bannerData.count-1)%_bannerData.count;
            _rightImgIndex = (_curIndex+1)%_bannerData.count;
            CCHomeBannerInfo *info = _bannerData[_curIndex];
            [_centerImg yy_setImageWithURL:[NSURL URLWithString:info.imgUrl] placeholder:_defaultIcon];
            CCHomeBannerInfo *leftInfo = _bannerData[_leftImgIndex];
            [_leftImg yy_setImageWithURL:[NSURL URLWithString:leftInfo.imgUrl] placeholder:_defaultIcon];
            CCHomeBannerInfo *rightInfo = _bannerData[_rightImgIndex];
            [_rightImg yy_setImageWithURL:[NSURL URLWithString:rightInfo.imgUrl] placeholder:_defaultIcon];
        }
    }
}

- (void)setCurIndex:(NSInteger)curIndex {
    _curIndex = curIndex;
    if (_bannerData.count>1) {
        //移动至中间
        [_bgScrollView setContentOffset:(CGPoint){_bgScrollView.width, 0} animated:NO];
    } else {
        [_bgScrollView setContentOffset:(CGPoint){0, 0} animated:NO];
    }
    //重载图片
    [self reloadCycleImg];
    //设置分页
//    NSLog(@"zuo:%zd,you:%zd",_leftImgIndex,_rightImgIndex);
    [_pageControl setCurrentPage:_pageIndex];
}

- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    if (_autoScroll) {
        if (!_autoScrollTimer) {
            _autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:kAutoScrollInterval target:self selector:@selector(autoScrollToNext) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_autoScrollTimer forMode:NSRunLoopCommonModes];
        }
    } else {
        if (_autoScrollTimer) {
            [_autoScrollTimer invalidate];
            _autoScrollTimer = nil;
        }
    }
}

- (void)autoScrollToNext {
    [_bgScrollView setContentOffset:(CGPoint){_bgScrollView.width*2,0} animated:YES];
}

- (void)clearAllBanner {
    [self setAutoScroll:NO];
    [_bgScrollView removeAllSubViews];
    _bannerData = nil;
    _centerImg = nil;
    _leftImg = nil;
    _rightImg = nil;
}

@end
