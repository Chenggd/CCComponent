//
//  CCBannerVC.m
//  CCDemo
//
//  Created by Chenggd on 2018/11/17.
//  Copyright © 2018 Chenggd. All rights reserved.
//

#import "CCBannerVC.h"
#import "CCCircleBannerView.h"
#import "CCLiveScrollBanner.h"

@interface CCBannerVC ()

@property (nonatomic, strong) CCCircleBannerView *oneBanner;
@property (nonatomic, strong) CCLiveScrollBanner *twoBanner;

@end

@implementation CCBannerVC

- (void)dealloc
{
    [_twoBanner clearAllBanner];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.oneBanner];
    
    [self.view addSubview:self.twoBanner];
    
    //模拟Banner数据
    NSMutableArray *oneBanners = @[].mutableCopy;
    NSArray *oneBannerArray = @[@"http://pic.qiantucdn.com/58pic/22/72/01/57c6578859e1e_1024.jpg",@"http://img18.3lian.com/d/file/201709/21/d8768c389b316e95ef29276c53a1e964.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542464885504&di=2efc5059c026c4f4dacabf53ebb8cd4b&imgtype=0&src=http%3A%2F%2Fimg07.tooopen.com%2Fimages%2F20180112%2Ftooopen_sy_232099918494.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542464885502&di=69e33f67cae8c5604197666c85ae48e5&imgtype=0&src=http%3A%2F%2Fimg.juimg.com%2Ftuku%2Fyulantu%2F140816%2F330658-140Q612004054.jpg"];
    for (int i=0; i<oneBannerArray.count; i++) {
        NSDictionary *dic = @{@"image":oneBannerArray[i]};
        CCHomeBannerInfo *info = [dic returnBannerInfo];
        [oneBanners addObject:info];
    }
    
    [self.oneBanner reloadCircleBannerData:oneBanners];
    
    [self.twoBanner setBannerData:oneBanners];
}

- (CCCircleBannerView *)oneBanner {
    if (!_oneBanner) {
        _oneBanner = [CCCircleBannerView creatCircleBannerView:(CGRect){0,kIPhoneXFitHeight(30),kScreenWidth,180} dataSource:nil scrollItemHandler:^(NSInteger index) {
            
        } scrollDidHandler:^(CGFloat contentOffsetX, CGFloat width) {
            
        }];
        [_oneBanner setTapCirBannerHandler:^(CCHomeBannerInfo *info) {
            
        }];
        _oneBanner.backgroundColor = [UIColor whiteColor];
    }
    return _oneBanner;
}

- (CCLiveScrollBanner *)twoBanner {
    if (!_twoBanner) {
        _twoBanner = [[CCLiveScrollBanner alloc] initWithFrame:(CGRect){(kScreenWidth-300)/2,_oneBanner.bottom+50,300,180}];
        [_twoBanner setTapLiveBannerBlock:^(CCHomeBannerInfo *info) {
            if ([CCTool isNotBlank:info.linkUrl]) {
                NSLog(@"点击");
            }
        }];
    }
    return _twoBanner;
}

@end
