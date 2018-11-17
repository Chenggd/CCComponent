//
//  CCChoseMenu.h
//  BeautyBeePro
//
//  Created by Cheng on 2017/10/25.
//  Copyright © 2017年 Chenggd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCMenuInfo.h"

typedef NS_ENUM(NSInteger, CCChoseMenuType) { //向导顶部选择
    CCChoseMenuCity = 0,
    CCChoseMenuSex,
    CCChoseMenuStar,
    CCChoseMenuNormal
};

typedef NS_ENUM(NSInteger, CCItemSwitchType) { //向导顶部单个菜单栏打开／关闭
    CCItemOpenType = 0,
    CCItemClosedType
};

typedef void(^valueChangeBlock)(CCMenuInfo *curCityInfo,
                                CCMenuInfo *curSexInfo,
                                CCMenuInfo *curStarInfo,
                                CCMenuInfo *curFiltInfo);
typedef void(^itemSwitchBlock)(CCChoseMenuType type, CCItemSwitchType switchType);

/**
 二级预览菜单
 */
@interface CCChoseMenu : UIView

@property (nonatomic, copy) valueChangeBlock changeBlock;
//用于记录上一次选中的值
@property (nonatomic, strong) CCMenuInfo *curCityInfo;
@property (nonatomic, strong) CCMenuInfo *curSexInfo;
@property (nonatomic, strong) CCMenuInfo *curStarInfo;
@property (nonatomic, strong) CCMenuInfo *curFiltInfo;

- (instancetype)initWithFrame:(CGRect)frame menus:(NSMutableArray *)menus;

//根据缓存匹配不同类型上次选中的值～
- (void)matchType:(CCChoseMenuType)type block:(void(^)(CCMenuInfo *info, BOOL match))block;

@end

/**
 单个item
 */
@interface CCMenuItem : UIView

@property (nonatomic, strong) CCMenuInfo *curItemInfo;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImg;
@property (nonatomic, copy) itemSwitchBlock switchBlock;
@property (nonatomic, assign) CCItemSwitchType switchType;
- (instancetype)initWithFrame:(CGRect)frame curItemInfo:(CCMenuInfo *)curItemInfo;
- (void)reloadSelectMenuItem:(CCMenuInfo *)info type:(CCChoseMenuType)type;

@end
