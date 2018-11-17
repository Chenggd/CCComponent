//
//  CCSegmentVC.m
//  CCDemo
//
//  Created by Chenggd on 2018/11/17.
//  Copyright © 2018 Chenggd. All rights reserved.
//

#import "CCSegmentVC.h"
#import "CCSegmentView.h"
#import "CCChoseMenu.h"
#import "CCRoomMarkView.h"

@interface CCSegmentVC ()

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) CCSegmentView *segmentView;

@property (nonatomic, strong) NSMutableArray *choseMenuItems;
@property (nonatomic, strong) CCChoseMenu *choseMenu;

@property (nonatomic, strong) CCRoomMarkView *markView;

@end

@implementation CCSegmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.segmentView];
    //模拟segmentView数据
    _menuItems = @[@"菜单1",@"菜单2",@"菜单3",@"菜单4"];
    [_segmentView setItems:_menuItems];
    [_segmentView setX:(kScreenWidth-_segmentView.width)/2];
    [_segmentView setY:kIPhoneXFitHeight(30)];
  
    [self.view addSubview:self.markView];
    //模拟标签数据
    NSArray *array = @[@"天下无敌",@"今天天气很不错😯",@"红烧肉",@"西红柿鸡蛋面",@"糖醋鲤鱼",@"清蒸鲈鱼",@"九曲十八弯",@"快使用双截棍哼哼哈嘿"];
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<array.count; i++) {
        CCEvaluateTagInfo *info = [CCEvaluateTagInfo new];
        info.value = [NSString stringWithFormat:@"%@",array[i]];
        info.txtWidth = [CCTool getWidth:info.value font:kHelveticaFont(12)]+28;
        info.titleColor = @"757575";
        info.bgColor = [UIColor colorWithHexString:@"f7f7f7"];
        [tempArray addObject:info];
    }
    [self.markView setTagInfos:tempArray];
    
    
    //模拟chose数据
    _choseMenuItems = @[].mutableCopy;
    CCWS(weakSelf)
    void(^setupMenuInfoByItem)(NSInteger, NSArray *) = ^(NSInteger index, NSArray *array) {
        NSMutableArray *menuItem = @[].mutableCopy;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CCMenuInfo *info = [CCMenuInfo new];
            info.itemName = obj;
            info.itemId = [NSString stringWithFormat:@"%zd",idx+1];
            info.selected = NO;
            [menuItem addObject:info];
        }];
        [weakSelf.choseMenuItems addObject:menuItem];
    };
    for (int i=0; i<_menuItems.count; i++) {
        NSArray *array = nil;
        if (i == 0) {
            array = @[@"长沙",@"广州",@"杭州",@"北京",@"深圳",@"上海"];
        } else if (i == 1) {
            array = @[@"男",@"女",@"未知"];
        } else if (i == 2) {
            array = @[@"5星",@"4星",@"3星",@"2星",@"1星"];
        } else if (i == 3) {
            array = @[@"默认排序",@"向导等级"];
        }
        setupMenuInfoByItem(i, array);
    }
    
    [self.view addSubview:self.choseMenu];
}

- (CCRoomMarkView *)markView {
    if (!_markView) {
        _markView = [[CCRoomMarkView alloc] initWithFrame:(CGRect){0,_segmentView.bottom+30,kScreenWidth,50} style:CCSearchMarkType];
        CCWS(weakSelf)
        [_markView setUpdateFrameComplete:^(CGFloat curHeight) {
            [weakSelf refreshFrame];
        }];
        [_markView setTapAction:^(NSInteger type, CCEvaluateTagInfo *info) {
//            if ([weakSelf.searchDelegate respondsToSelector:@selector(tapMarkAction:)]) {
//                [weakSelf.searchDelegate tapMarkAction:info];
//            }
        }];
    }
    return _markView;
}

- (void)refreshFrame {
    _choseMenu.y = self.markView.bottom+30;
    [UIView animateWithDuration:0.2 animations:^{
        self.choseMenu.y = self.markView.bottom+30;
    } completion:^(BOOL finished) {

    }];
}

- (CCSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[CCSegmentView alloc] initWithItems:nil style:1];
        _segmentView.lineColor = [UIColor colorWithHexString:@"ff3b42"];
        _segmentView.itemHeight = 44;
        _segmentView.needChange = YES;
        _segmentView.itemFont = 18;
        _segmentView.itemSelectFont = 18;
        _segmentView.lineSpaceForBottom = 3;
        [_segmentView setLineHeight:4];
        [_segmentView setItems:_menuItems];
        //        CCWS(weakSelf)
        [_segmentView setClickItemBlock:^(NSInteger index) {
            //            if (weakSelf.currentIndex != index) {
            //                weakSelf.currentIndex = index;
            //                [weakSelf.bgScrollView scrllToIndexPage:index];
            //                [weakSelf refreshItemStatus];
            //            }
        }];
    }
    return _segmentView;
}

- (CCChoseMenu *)choseMenu {
    if (!_choseMenu) {
        _choseMenu = [[CCChoseMenu alloc] initWithFrame:(CGRect){0,_markView.bottom+30,kScreenWidth,50} menus:_choseMenuItems];
    }
    return _choseMenu;
}

@end
