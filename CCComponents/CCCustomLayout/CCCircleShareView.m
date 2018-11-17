//
//  CCCircleShareView.m
//  CCCustomComponent
//
//  Created by Chenggd on 2018/9/26.
//  Copyright © 2018 Dong. All rights reserved.
//

#import "CCCircleShareView.h"
#import "CCFlexibleLayout.h"
#import "CCCircleShareCell.h"
#import "CCFocusUserInfo.h"

@interface CCCircleShareView ()<UICollectionViewDelegate,UICollectionViewDataSource,CCFlexibleDataSource>

@property (nonatomic, assign) NSInteger curIndex;
@property (nonatomic, strong) UIView *emptyView;

@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) BOOL loadMore;

//顶部用
@property (nonatomic, strong) NSMutableArray *focusArray;

@end

@implementation CCCircleShareView

- (void)dealloc {
    [CCNotiYCenter removeObserver:self];
}

static NSString *shareCellId = @"shareCellId";

- (instancetype)initWithFrame:(CGRect)frame {
    CCFlexibleLayout *shareLayout = [CCFlexibleLayout new];
    if (self = [super initWithFrame:frame collectionViewLayout:shareLayout]) {
        shareLayout.dataSource = self;
        shareLayout.contentMinHeight = 300;
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
        _needLoad = YES;
        _shareData = [NSMutableArray arrayWithCapacity:0];
        self.minContentHeight = 300;
        [self initRefreshRow];
        [self registerClass:[CCCircleShareCell class] forCellWithReuseIdentifier:shareCellId];
        [self addSubview:self.emptyView];
    }
    return self;
}

- (void)setShareType:(NSInteger)shareType {
    _shareType = shareType;
    if (_shareType == 1) {
         _focusArray = [NSMutableArray arrayWithCapacity:0];
    }
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.loadMore = YES;
        if (self.shareType == 0) {
            [self loadShareListData];
        } else if (self.shareType == 1) {
            [self loadShareFollowListData];
        }
    }];
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)endRefresh {
    if ([self.mj_footer isRefreshing]) {
        [self.mj_footer endRefreshing];
    }
    if (self.refreshShareEnd) {
        self.refreshShareEnd();
    }
}

- (void)initRefreshRow {
    _page = 1;
    _page_size = 5;
    self.loadMore = NO;
}

- (void)desposeRefreshStatus {
    if (self.needLoad) {
        [self initRefreshRow];
        if (_shareType == 0) {
            [self loadShareListData];
        } else {
            [self loadShareFollowListData];
        }
    }
}

- (UIView *)emptyView {
    if (!_emptyView) {
        UIImage *noDataIcon = [UIImage imageNamed:@"empty_common"];
        _emptyView = [UIView createNullViewWithF:CGRectMake(0, 0, self.width, self.minContentHeight) img:noDataIcon imgFrm:(CGRect){(kGSize.width-noDataIcon.size.width)/2,kIPhoneXFitHeight(0),noDataIcon.size.width,noDataIcon.size.height} txt:@"暂无分享" target:self sel:nil otherView:nil];
    }
    return _emptyView;
}

- (void)setMinContentHeight:(CGFloat)minContentHeight {
    _minContentHeight = minContentHeight;
    self.emptyView.height = minContentHeight;
}

#pragma mark - 嵌套监听
- (void)setOpenNestedHook:(BOOL)openNestedHook {
    _openNestedHook = openNestedHook;
    if (_openNestedHook) {
        self.delegate = self;
        //子控制器视图到达/离开顶部的通知
        [CCNotiYCenter addObserver:self selector:@selector(acceptMsg:) name:kNotifScrollGoTop object:nil];
        [CCNotiYCenter addObserver:self selector:@selector(acceptMsg:) name:kNotifScrollLeaveTop object:nil];
    }
}

- (void)acceptMsg:(NSNotification *)notification {
    if (_openNestedHook) {
        NSString *notificationName = notification.name;
        NSDictionary *userInfo = notification.userInfo;
        BOOL canScroll = [userInfo[@"canScroll"] boolValue];
        if ([notificationName isEqualToString:kNotifScrollGoTop]) {
            self.canScroll = canScroll;
        } else if ([notificationName isEqualToString:kNotifScrollLeaveTop]) {
            self.canScroll = NO;
            self.contentOffset = CGPointZero;
        }
        self.showsVerticalScrollIndicator = self.canScroll;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_openNestedHook) {
        if (!self.canScroll) {
            [scrollView setContentOffset:CGPointZero];
        }
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY <= 0) {
            [scrollView setContentOffset:CGPointZero];
            [CCNotiYCenter postNotificationName:kNotifScrollGoTop object:nil userInfo:@{@"canScroll":@YES}];
        }
    }
}

#pragma mark UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _shareData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CCCircleShareCell *cell = [self dequeueReusableCellWithReuseIdentifier:shareCellId forIndexPath:indexPath];
    CCMyCollectInfo *info = _shareData[indexPath.item];
    [cell setCollShareInfo:info];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CCMyCollectInfo *info = _shareData[indexPath.item];
    if (self.tapCircleShareAction) {
        self.tapCircleShareAction(info, indexPath.item);
    }
}

#pragma mark - CCFlexibleDataSource
//控制对应section的瀑布流列数
- (NSInteger)numberOfColsInSection:(NSInteger)section {
    return 2;
}

//控制每个cell的尺寸，实际上就是获取宽高比
- (CGSize)sizeOfItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_shareData.count) {
        CCMyCollectInfo *info = _shareData[indexPath.item];
        return CGSizeMake((kScreenWidth-10*3)/2, info.cellHeight);
    }
    return CGSizeZero;
}

//控制瀑布流cell的间距
- (CGFloat)spaceOfCells:(NSInteger)section {
    return 10;
}

//内边距
- (UIEdgeInsets)sectionInsets:(NSInteger)section {
    return UIEdgeInsetsMake(17, 10, 10, 10);
}

//每个section的header尺寸
- (CGSize)sizeOfHeader:(NSInteger)section {
    return CGSizeMake(0, 0);
}

//每个cell的额外高度
- (CGFloat)heightOfAdditionalContent:(NSIndexPath *)indexPath {
    return 0;
}

#pragma mark - loadAction
- (void)loadShareListData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshTempData];
    });
    /*
    CCWS(weakSelf)
    [[CCController shareCCController] loadPHCirShareData:_page page_size:_page_size uid:_userId success:^(CCServiceStatus stautus, CCRequestBodyInfo *requestBodyInfo) {
        [weakSelf endRefresh];
        if (stautus == kCCServiceStatusNormal) {
            if (!self.loadMore) {
                [weakSelf.shareData removeAllObjects];
            }
            NSArray *array = requestBodyInfo.bodyData[@"list"];
            if ([CCTool isNotBlank:array]) {
                for (int i =0; i<array.count; i++) {
                    CCMyCollectInfo *shareInfo = [CCMyCollectInfo mj_objectWithKeyValues:((NSDictionary *)array[i])];
                    shareInfo.style = 1;
                    [weakSelf.shareData addObject:shareInfo];
                };
                self.page += 1;
            }
            self.needLoad = NO;
            if (array.count < self.page_size) {
                [weakSelf.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.mj_footer resetNoMoreData];
            }
            [weakSelf reloadShareData];
        } else {
            [kWindow makeToast:requestBodyInfo.errorMessage];
        }
    } failure:^(CCServiceStatus serviceCode, NSError *error) {
        [weakSelf endRefresh];
        [kWindow makeToast:CCLocalString(@"app_neterror")];
    }];
     */
}

- (void)loadShareFollowListData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshTempData];
    });
    /*
    CCWS(weakSelf)
    [[CCController shareCCController] loadFocusUserCirShareData:_page page_size:_page_size success:^(CCServiceStatus stautus, CCRequestBodyInfo *requestBodyInfo) {
        [weakSelf endRefresh];
        if (stautus == kCCServiceStatusNormal) {
            self.needLoad = NO;
            if (!self.loadMore) {
                [weakSelf.shareData removeAllObjects];
                [weakSelf.focusArray removeAllObjects];
            }
            //关注的人
            NSArray *focusArray = requestBodyInfo.bodyData[@"follows_list"];
            if ([CCTool isNotBlank:focusArray] && weakSelf.focusArray.count==0) {
                [focusArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    CCFocusUserInfo *info = [(NSDictionary *)obj returnFocusUserInfo];
                    [weakSelf.focusArray addObject:info];
                }];
            }
            if (!self.loadMore) { //下拉刷新才更新头部数据
                if (weakSelf.refreshFoucsCSBlock) {
                    weakSelf.refreshFoucsCSBlock(weakSelf.focusArray);
                }
            }
            //关注的人发布的分享列表
            NSArray *array = requestBodyInfo.bodyData[@"list"];
            if ([CCTool isNotBlank:array]) {
                for (int i =0; i<array.count; i++) {
                    CCMyCollectInfo *shareInfo = [CCMyCollectInfo mj_objectWithKeyValues:((NSDictionary *)array[i])];
                    shareInfo.style = 1;
                    [weakSelf.shareData addObject:shareInfo];
                };
                self.page += 1;
            }
            [weakSelf reloadShareData];
            if (array.count < self.page_size) {
                [weakSelf.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.mj_footer resetNoMoreData];
            }
        } else {
            [kWindow makeToast:requestBodyInfo.errorMessage];
        }
    } failure:^(CCServiceStatus serviceCode, NSError *error) {
        [weakSelf endRefresh];
        [kWindow makeToast:CCLocalString(@"app_neterror")];
    }];
     */
}


/**
 刷新模拟数据
 */
- (void)refreshTempData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"waterfallFlow.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    id reqData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (reqData != nil && error == nil){
        NSLog(@"%@",reqData);
    }
    NSDictionary *bodyData = reqData[@"data"];
    
    [self endRefresh];
    if (!self.loadMore) {
        [self.shareData removeAllObjects];
    }
    NSArray *array = bodyData[@"list"];
    if ([CCTool isNotBlank:array]) {
        for (int i =0; i<array.count; i++) {
            CCMyCollectInfo *shareInfo = [CCMyCollectInfo mj_objectWithKeyValues:((NSDictionary *)array[i])];
            shareInfo.style = 1;
            [self.shareData addObject:shareInfo];
        };
        self.page += 1;
    }
    self.needLoad = NO;
    if (array.count < self.page_size) {
        [self.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.mj_footer resetNoMoreData];
    }
    [self reloadShareData];
  
}

- (void)reloadShareData {
    [self reloadData];
    if (self.shareData.count > 0) {
        self.emptyView.hidden = YES;
    } else {
        self.emptyView.hidden = NO;
        if (self.minContentHeight > 0) {
            [self setContentSize:(CGSize){0,self.minContentHeight}];
        }
    }
}

- (void)clearOldData {
    self.needLoad = YES;
    [self initRefreshRow];
    [self.shareData removeAllObjects];
    [self.focusArray removeAllObjects];
    [self reloadShareData];
}

- (void)removeInfoByShareId:(NSString *)shareId {
    NSInteger indexRow = -1;
    for (int i=0; i<self.shareData.count; i++) {
        CCMyCollectInfo *info = self.shareData[i];
        if ([info.share_id isEqualToString:shareId]) {
            indexRow = i;
            break;
        }
    }
    if (indexRow!=-1 && self.shareData.count>indexRow) {
        [self.shareData removeObjectAtIndex:indexRow];
        [self reloadShareData];
    }
}

@end
