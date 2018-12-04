//
//  CCDanmakuVC.m
//  CCDemo
//
//  Created by Chenggd on 2018/12/4.
//  Copyright © 2018 Chenggd. All rights reserved.
//

#import "CCDanmakuVC.h"
#import "CCDanmakuManager.h"

@interface CCDanmakuVC ()

//last/fist参数无关紧要，原始的业务需求
@property (nonatomic, assign) BOOL lastDanmakuStatus;
@property (nonatomic, assign) BOOL firstOpenDanmaku;

@property (nonatomic, strong) NSMutableArray *normalDanmakus;
@property (nonatomic, strong) NSMutableArray *giftDanmakus;
@property (nonatomic, strong) CCDanmakuManager *danmakuManager;
@property (nonatomic, strong) UIButton *barrageBtn;

@end

@implementation CCDanmakuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _firstOpenDanmaku = YES;
    _normalDanmakus = [NSMutableArray arrayWithCapacity:0];
    _giftDanmakus = [NSMutableArray arrayWithCapacity:0];
    
    [self.view addSubview:self.barrageBtn];
    
    [self loadDanmuList];
    [self switchBarrage];
}

/**
 模拟数据
 */
- (void)loadDanmuList {
    NSArray *danmuList = @[@{@"content":@"这个人有点闷"}
                           ,@{@"content":@"在坐的的都是Vip会员嚣张点"}
                           ,@{@"content":@"我是会员"}
                           ,@{@"content":@"非凡座驾"}
                           ,@{@"content":@"了不起的盖茨比～"}];
    if (danmuList.count) {
        [danmuList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CCDanmuGiftInfo *info = [CCDanmuGiftInfo mj_objectWithKeyValues:(NSDictionary *)obj];
            [self.normalDanmakus addObject:info];
        }];
        [self.danmakuManager addDanmakuDataSource:_normalDanmakus type:0];
    }

    NSArray *danmu_gift_list = @[@{@"from_nickname":@"哼哼哈哈",@"gift_name":@"凯迪拉克"}
                                 ,@{@"from_nickname":@"飞鸟",@"gift_name":@"棒棒糖"}
                                 ,@{@"from_nickname":@"似水流年",@"gift_name":@"面包车"}];
    if (danmu_gift_list.count) {
        [danmu_gift_list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CCDanmuGiftInfo *info = [CCDanmuGiftInfo mj_objectWithKeyValues:(NSDictionary *)obj];
            [self.giftDanmakus addObject:info];
        }];
        [self.danmakuManager addDanmakuDataSource:_giftDanmakus type:1];
    }
}

- (UIButton *)barrageBtn {
    if (!_barrageBtn) {
        _barrageBtn = [UIButton createT:@"弹幕" C:[UIColor colorWithHexString:@"ffffff"] ST:@"弹幕" SC:[UIColor colorWithHexString:@"38362a"]];
        _barrageBtn.titleLabel.font = kHelveticaFont(18);
        //默认关闭
        _barrageBtn.selected = NO;
        [_barrageBtn setBackgroundColor:[UIColor colorWithHexString:@"c8c8c8"]];
        [_barrageBtn setFrame:(CGRect){kLeftSpace,kScreenHeight-kIPhoneXBottomHeight(100),50,50}];
        [_barrageBtn addTarget:self action:@selector(switchBarrage) forControlEvents:UIControlEventTouchUpInside];
        kViewRadius(_barrageBtn, _barrageBtn.height/2.f);
    }
    return _barrageBtn;
}

- (void)switchBarrage {
    _barrageBtn.selected = !_barrageBtn.selected;
    [_barrageBtn setBackgroundColor:[UIColor colorWithHexString:_barrageBtn.selected ?@"ffd500" :@"c8c8c8"]];
    if (_firstOpenDanmaku) {
        _firstOpenDanmaku = NO;
    } else {
        NSString *log = [NSString stringWithFormat:@"弹幕%@",_barrageBtn.selected ?@"开 启":@"关闭"];
        NSLog(@"%@",log);
    }
    if (_barrageBtn.selected) {
        [self.danmakuManager startDanmaku];
    } else {
        [self.danmakuManager stopDanmaku];
    }
}

- (CCDanmakuManager *)danmakuManager {
    if (!_danmakuManager) {
        _danmakuManager = [[CCDanmakuManager alloc] initWithInView:self.view];
        _danmakuManager.danmakuScreenView.y = kIPhoneXFitHeight(50);
    }
    return _danmakuManager;
}


@end
