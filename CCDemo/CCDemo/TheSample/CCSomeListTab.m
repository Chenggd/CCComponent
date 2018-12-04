//
//  CCSomeListTab.m
//  CCDemo
//
//  Created by Chenggd on 2018/12/4.
//  Copyright © 2018 Chenggd. All rights reserved.
//

#import "CCSomeListTab.h"
#import "CCPopoverMenuView.h"

@interface CCSomeListTab ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *emptyTNView;
@property (nonatomic, strong) CCPopoverMenuView *msgHintHub;
@property (nonatomic, assign) BOOL loadMore;

@end

static NSString *cellId = @"someListCell";

@implementation CCSomeListTab

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame style:UITableViewStylePlain]) {
        self.needLoad = YES;
        self.loadMore = NO;
        [self initRefreshRow];
        _focusArray = @[].mutableCopy;
        self.listData = @[].mutableCopy;
        self.delegate = self;
        self.dataSource = self;
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return self;
}

- (void)initRefreshRow {
    self.loadMore = NO;
    self.startrow = 1;
    self.loadRow = 10;
    self.endrow = self.loadRow;
}

- (void)addRefresh {
    CCWS(weakSelf)
    if (!self.mj_footer) {
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.loadMore = YES;
            [weakSelf loadListData];
        }];
    }
}

- (void)endRefresh {
    if ([self.mj_footer isRefreshing]) {
        [self.mj_footer endRefreshing];
    }
    if (self.refreshHeadBlock) {
        self.refreshHeadBlock(nil);
    }
    if (self.refreshSomeEnd) {
        self.refreshSomeEnd();
    }
    self.loadMore = NO;
}

- (void)desposeRefreshStatus {
    if (self.needLoad) {
        [self initRefreshRow];
        [self loadListData];
    }
}

#pragma mark - UITableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.listData.count) {
        return self.listData.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (self.listData.count) {
        cell.textLabel.text = self.listData[indexPath.row];
    }
    [cell whenTapped:^{
        NSLog(@"tap %@",cell.textLabel.text);
    }];
    return cell;
}

//#warning 该方法在UIScrollView嵌套多个子UITableView时，下拉回弹操作会造成第一次点击失效,而嵌套的子UICollectionView则不会有此问题,这个bug猜测可能是多嵌套多手势或系统版本问题，qq也有此问题，故这里暂时采用添加手势响应而不用delegate方法
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    if (self.listData.count) {
//        CCTravelNoteInfo *info = self.listData[indexPath.row];
//        if (_readTNoteBlock) {
//            _readTNoteBlock(info, indexPath.row);
//        }
//    }
//}

- (void)loadListData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshTempData];
    });
}

/**
 刷新模拟数据
 */
- (void)refreshTempData {
    if (!self.loadMore) {
        [self.listData removeAllObjects];
        [self.focusArray removeAllObjects];
    }
    //设置数据
    self.needLoad = NO;
    for (int i=0; i<100; i++) {
        [self.listData addObject:[NSString stringWithFormat:@"第%d行",i]];
    }
    //下拉刷新才更新头部数据
    if (self.refreshHeadBlock && !self.loadMore) {
        self.refreshHeadBlock(self.focusArray);
    }
    if (self.refreshSomeEnd) {
        self.refreshSomeEnd();
    }
    [self reloadData];
    
    if (self.listData.count > 0) {
        [self.emptyTNView removeFromSuperview];
        [self addRefresh];
    } else { //无关注的人则也没有游记更新数据
        [self addSubview:self.emptyTNView];
        if (self.minContentHeight > 0) {
            [self setContentSize:(CGSize){0,self.minContentHeight}];
        }
    }
}


@end
