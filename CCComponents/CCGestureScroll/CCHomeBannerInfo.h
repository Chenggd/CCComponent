//
//  CCHomeBannerInfo.h
//  CCCommunity
//
//  Created by Chenggd on 2017/9/16.
//  Copyright © 2017年 Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCHomeBannerInfo : NSObject

@property (nonatomic, assign) NSInteger bannerId;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *linkUrl;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *type;

@end

@interface NSDictionary (returnBannerInfo)

- (CCHomeBannerInfo *)returnBannerInfo;

@end
