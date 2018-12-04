//
//  CCSomeScrollVC.m
//  CCDemo
//
//  Created by Chenggd on 2018/12/4.
//  Copyright © 2018 Chenggd. All rights reserved.
//

#import "CCSomeScrollVC.h"
#import "CCHookScrollView.h"
#import "CCPageScrollView.h"
#import "CCSegmentView.h"
#import "CCSomeListTab.h"
#import "CCCircleShareView.h"
#import "CCLiveScrollBanner.h"

@interface CCSomeScrollVC ()<CCPageScrollViewDelegate>

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *headTopView;
@property (nonatomic, strong) CCLiveScrollBanner *topBanner;
@property (nonatomic, weak) NSMutableArray *bannerArray;

@property (nonatomic, strong) NSArray *segmentItems;
@property (nonatomic, strong) NSMutableArray *itemTabs;
@property (nonatomic, strong) CCSegmentView *segmentView;
@property (nonatomic, strong) CCHookScrollView *bgScrollView;
@property (nonatomic, strong) CCPageScrollView *pageScrollView;
@property (nonatomic, strong) CCSomeListTab *listTabView;
@property (nonatomic, strong) CCCircleShareView *collectionView;

@property (nonatomic, assign) NSInteger curIndex;
@property (nonatomic, strong) UIView *emptyView;

@end

@implementation CCSomeScrollVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    _itemTabs = @[].mutableCopy;
    _curIndex = -1;
    [self.view addSubview:self.bgScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_curIndex == -1) {
        [self scrollToIndex:0];
    }
}

- (UIView *)emptyView {
    if (!_emptyView) {
        UIImage *noDataIcon = [UIImage imageNamed:@"empty_focus"];
        _emptyView = [UIView createNullViewWithF:CGRectMake(0, 0, self.bgScrollView.width, self.bgScrollView.height) img:noDataIcon imgFrm:(CGRect){(kGSize.width-noDataIcon.size.width)/2,kIPhoneXFitHeight(100),noDataIcon.size.width,noDataIcon.size.height} txt:@"快去关注您欣赏的人吧" target:self sel:nil otherView:nil];
    }
    return _emptyView;
}

- (CCHookScrollView *)bgScrollView {
    if (!_bgScrollView) {
        _bgScrollView = [[CCHookScrollView alloc] initWithFrame:(CGRect){0,kIPhoneXFitHeight(0),kScreenWidth,kGSize.height-kIPhoneXFitHeight(0)}];
        [_bgScrollView addSubview:self.headView];
        [_bgScrollView addSubview:self.segmentView];
        [_segmentView setOutScrollView:_bgScrollView];
        _bgScrollView.contentSize = (CGSize){0,_bgScrollView.height+self.headView.height};
        _bgScrollView.openTouchHook = YES;
        _bgScrollView.hookAreaTop = self.segmentView.top;
        CCWS(weakSelf)
        _bgScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf pressCCnWithIndex:weakSelf.curIndex force:YES];
        }];
        [self creatContentView];
    }
    return _bgScrollView;
}

- (void)endRefresh {
    if ([_bgScrollView.mj_header isRefreshing]) {
        [_bgScrollView.mj_header endRefreshing];
    }
}

#pragma mark - 设置headView
- (UIView *)headView {
    if (!_headView) {
        _headView = [UIView createF:(CGRect){0,0,kScreenWidth,167+8} BC:[UIColor colorWithHexString:@"f7f7f7"]];
        [_headView addSubview:self.headTopView];
        [_headView addSubview:self.topBanner];
    }
    return _headView;
}

- (UIView *)headTopView {
    if (!_headTopView) {
        _headTopView = [UIView createF:(CGRect){0,0,kScreenWidth,43}];
        UILabel *lbl = [UILabel createF:(CGRect){kLeftSpace,12,80,20} TC:[UIColor colorWithHexString:@"757575"] FT:kHelveticaFont(14) T:@"栏目" AL:NSTextAlignmentLeft];
        [_headTopView addSubview:lbl];
    }
    return _headTopView;
}

- (CCLiveScrollBanner *)topBanner {
    if (!_topBanner) {
        _topBanner = [[CCLiveScrollBanner alloc] initWithFrame:(CGRect){0,_headTopView.bottom,kScreenWidth,220}];
        [_topBanner setTapLiveBannerBlock:^(CCHomeBannerInfo *info) {
            if ([CCTool isNotBlank:info.linkUrl]) {
                NSLog(@"点击");
            }
        }];
    }
    return _topBanner;
}

#pragma mark - 设置contentView
- (CCSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentItems = @[@"分享",@"游记"];
        _segmentView = [[CCSegmentView alloc] initWithItems:nil style:1];
        _segmentView.backgroundColor = [UIColor whiteColor];
        _segmentView.itemWidth = kScreenWidth/_segmentItems.count;
        _segmentView.itemFont = 15.f;
        _segmentView.itemSelectFont = 15.f;
        _segmentView.lineColor = [UIColor colorWithHexString:@"ff3b42"];
        _segmentView.hasBottomLine = YES;
        [_segmentView setItems:_segmentItems];
        [_segmentView setX:0];
        [_segmentView setY:self.headView.bottom];
        [_segmentView setLineHeight:2];
        CCWS(weakSelf)
        [_segmentView setClickItemBlock:^(NSInteger index) {
            if (weakSelf.pageScrollView.curPageIndex != index) {
                [weakSelf.pageScrollView scrllToIndexPage:index];
                weakSelf.curIndex = index;
                [weakSelf refreshItemStatus];
            }
        }];
    }
    return _segmentView;
}

- (void)creatContentView {
    [_itemTabs removeAllObjects];
    for (int i=0; i<_segmentItems.count; i++) {
        if (i==0) {
            [_itemTabs addObject:self.collectionView];
        } else if (i==1) {
            [_itemTabs addObject:self.listTabView];
        }
    }
    _pageScrollView = [[CCPageScrollView alloc] initWithFrame:(CGRect){0,self.segmentView.bottom,kScreenWidth,_bgScrollView.height-self.segmentView.height}];
    _pageScrollView.pageScrollDelegate = self;
    [_pageScrollView setPageViews:_itemTabs];
    [self.bgScrollView addSubview:_pageScrollView];
    
    //2.5设置
    [_segmentView setOutScrollView:_pageScrollView];
}

- (CCCircleShareView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[CCCircleShareView alloc] initWithFrame:(CGRect){0,0,kScreenWidth,_bgScrollView.height-self.segmentView.height}];
        _collectionView.openNestedHook = YES;
        _collectionView.shareType = 1;
        _collectionView.minContentHeight = _collectionView.height;
        CCWS(weakSelf)
        [_collectionView setTapCircleShareAction:^(CCMyCollectInfo * _Nonnull info, NSInteger index) {
            NSLog(@"tap info:%@",info.title);
        }];
        [_collectionView setRefreshShareEnd:^{
            [weakSelf endRefresh];
        }];
        [_collectionView setRefreshFoucsCSBlock:^(NSMutableArray * _Nonnull focusArray) {
            //只是head数据回调示例
            [weakSelf setupHeadContent];
        }];
    }
    return _collectionView;
}

//这里直接用了，一般通过继承用
- (CCSomeListTab *)listTabView {
    if (!_listTabView) {
        _listTabView = [[CCSomeListTab alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, _bgScrollView.height-self.segmentView.height)];
        _listTabView.openNestedHook = YES;
        _listTabView.minContentHeight = _listTabView.height;
        CCWS(weakSelf)
        [_listTabView setRefreshHeadBlock:^(NSMutableArray *headArray) {
            //只是head数据回调示例
            [weakSelf setupHeadContent];
        }];
        [_listTabView setRefreshSomeEnd:^{
            [weakSelf endRefresh];
        }];
    }
    return _listTabView;
}

#pragma mark - scrollViewGusterDelegate
- (void)scrollToIndex:(NSInteger)currentIndex {
    if (_curIndex != currentIndex) {
        _curIndex = currentIndex;
        [self.segmentView selectSegmentIndex:_curIndex];
        [self refreshItemStatus];
    }
}

- (void)refreshItemStatus {
    if (_curIndex == 0) {
        if (self.collectionView.needLoad) {
            [self.bgScrollView.mj_header beginRefreshing];
        }
    } else if (_curIndex == 1) {
        if (self.listTabView.needLoad) {
            [self.bgScrollView.mj_header beginRefreshing];
        }
    }
}

// 是否刷新数据
- (void)pressCCnWithIndex:(NSInteger)index force:(BOOL)force {
    id listView = nil;
    if (index < [_itemTabs count]) {
        if (index == 0) {
            listView = self.collectionView;
        } else if (index == 1) {
            listView = self.listTabView;
        }
        if (force) {
            [listView setValue:@(YES) forKey:@"needLoad"];
        }
        if ([listView respondsToSelector:@selector(desposeRefreshStatus)]) {
            [listView desposeRefreshStatus];
        }
    }
}

- (void)setupHeadContent {
    //模拟Banner数据
    NSMutableArray *oneBanners = @[].mutableCopy;
    NSArray *oneBannerArray = @[@"http://pic.qiantucdn.com/58pic/22/72/01/57c6578859e1e_1024.jpg",@"http://img18.3lian.com/d/file/201709/21/d8768c389b316e95ef29276c53a1e964.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542464885504&di=2efc5059c026c4f4dacabf53ebb8cd4b&imgtype=0&src=http%3A%2F%2Fimg07.tooopen.com%2Fimages%2F20180112%2Ftooopen_sy_232099918494.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542464885502&di=69e33f67cae8c5604197666c85ae48e5&imgtype=0&src=http%3A%2F%2Fimg.juimg.com%2Ftuku%2Fyulantu%2F140816%2F330658-140Q612004054.jpg"];
    for (int i=0; i<oneBannerArray.count; i++) {
        NSDictionary *dic = @{@"image":oneBannerArray[i]};
        CCHomeBannerInfo *info = [dic returnBannerInfo];
        [oneBanners addObject:info];
    }
    [self.topBanner setBannerData:oneBanners];
}

@end
