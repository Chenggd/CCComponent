//
//  CCWaterfallFlowVC.m
//  CCDemo
//
//  Created by Chenggd on 2018/11/17.
//  Copyright © 2018 Chenggd. All rights reserved.
//

#import "CCWaterfallFlowVC.h"
#import "CCCircleShareView.h"

@interface CCWaterfallFlowVC ()
@property (nonatomic, strong) CCCircleShareView *cirShareView;
@end

@implementation CCWaterfallFlowVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self.view addSubview:self.cirShareView];
    [self.cirShareView desposeRefreshStatus];
}

- (CCCircleShareView *)cirShareView {
    if (!_cirShareView) {
        _cirShareView = [[CCCircleShareView alloc] initWithFrame:(CGRect){0,kIPhoneXFitHeight(0),kScreenWidth,kScreenHeight-kIPhoneXFitHeight(0)}];
        _cirShareView.openNestedHook = YES;
        _cirShareView.shareType = 1;
        _cirShareView.minContentHeight = _cirShareView.height;
        CCWS(weakSelf)
        [_cirShareView setTapCircleShareAction:^(CCMyCollectInfo * _Nonnull info, NSInteger index) {
            
        }];
        [_cirShareView setRefreshShareEnd:^{
            
        }];
        [_cirShareView setRefreshFoucsCSBlock:^(NSMutableArray * _Nonnull focusArray) {
            
        }];
    }
    return _cirShareView;
}

@end
