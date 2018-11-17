//
//  CCChoseMenu.m
//  BeautyBeePro
//
//  Created by Cheng on 2017/10/25.
//  Copyright © 2017年 Chenggd. All rights reserved.
//

#import "CCChoseMenu.h"

@class CCMenuItem;
@interface CCChoseMenu()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *unfoldTab;
@property (nonatomic, strong) UIView *unfoldBgView;
@property (nonatomic, strong) NSMutableArray *menus;
@property (nonatomic, strong) NSMutableArray *menuItems;
@property (nonatomic, assign) CCChoseMenuType type;

@end

@implementation CCChoseMenu
// 配置
#define moveDuration 0.3
static CGFloat cellHeight = 50;
static NSString *itemSelectColor = @"3499FF";
static NSString *itemNormalColor = @"333333";
static NSString *cellId = @"cellId";

- (instancetype)initWithFrame:(CGRect)frame menus:(NSMutableArray *)menus {
    if (self = [super initWithFrame:frame]) {
        _menus = [menus mutableCopy];
        _menuItems = [NSMutableArray arrayWithCapacity:0];
        [self configMenus];
    }
    return self;
}

- (void)configMenus {
    CCWS(weakSelf)
    UIView *line = [UIView createF:(CGRect){0,self.height-0.5,self.width,0.5} BC:[UIColor colorWithHexString:@"d6e0ea"]];
    [self addSubview:line];
    float itemWidth = (self.width-1*(_menus.count-1))/_menus.count;
    [_menus enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *itemData = self->_menus[idx];
        CCMenuItem *item = [[CCMenuItem alloc] initWithFrame:(CGRect){(itemWidth+1)*idx,0,itemWidth,self.height-line.height} curItemInfo:itemData[0]];
        [weakSelf reloadSelectMenuItem:itemData[0] type:idx];
        item.tag = idx;
        [item setSwitchBlock:^(CCChoseMenuType type, CCItemSwitchType switchType) {
            self->_type = item.tag;
            [weakSelf refreshItemStatus:self->_type];
            [weakSelf.unfoldTab reloadData];
            if (switchType == CCItemOpenType) {
                [weakSelf showUnfoldTab];
            } else {
                [weakSelf hideUnfoldTab:nil];
            }
        }];
        [weakSelf addSubview:item];
        [weakSelf.menuItems addObject:item];
        if (idx != self->_menus.count-1) {
            UIView *spaceLine = [UIView createF:(CGRect){item.right,5,1,self.height-5*2} BC:[UIColor colorWithHexString:@"d6e0ea"]];
            [weakSelf addSubview:spaceLine];
        }
    }];
}

- (void)matchType:(CCChoseMenuType)type block:(void(^)(CCMenuInfo *info, BOOL match))block {
    //CCModel用于存储上次选中的值
//    CCModel *model = [CCModel shareCCModel];
//    __block BOOL match = NO;
//    __block CCMenuInfo *curInfo = nil;
//    NSArray *itemData = _menus[type];
//    CCWS(weakSelf)
//    [itemData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        CCMenuInfo *info = (CCMenuInfo *)obj;
//        if ([model.curCity isEqualToString:info.itemName]) {
//            match = YES;
//            info.selected = YES;
//            curInfo = info;
//            [weakSelf reloadSelectMenuItem:info type:type];
//        } else {
//            info.selected = NO;
//        }
//    }];
//    if (match && curInfo) {
//        CCMenuItem *curItem = (CCMenuItem *)self.menuItems[type];
//        [curItem setCurItemInfo:curInfo];
//    }
//    block(curInfo, match);
}

- (void)refreshItemStatus:(NSInteger)index {
    [_menuItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CCMenuItem *item = (CCMenuItem *)obj;
        if (index != item.tag && item.switchType == CCItemOpenType) {
            [item setSwitchType:CCItemClosedType];
        }
    }];
}

- (void)showUnfoldTab {
    float tabHeight = [self selectMenuItemTitles].count*cellHeight;
    [self.unfoldTab setHeight:tabHeight];
    [self.unfoldTab setY:-tabHeight];
    [self.unfoldBgView setY:self.bottom];
    [self.superview addSubview:self.unfoldBgView];
    self.unfoldBgView.alpha = 0;
    [UIView animateWithDuration:moveDuration animations:^{
        self.unfoldBgView.alpha = 1;
        [self.unfoldTab setY:0];
    }];
}

- (void)hideUnfoldTab:(void(^)(void))complete {
    self.unfoldBgView.alpha = 1;
    [self.unfoldTab setY:0];
    [UIView animateWithDuration:moveDuration animations:^{
        [self.unfoldTab setY:-self.unfoldTab.height];
        self.unfoldBgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.unfoldBgView removeFromSuperview];
        if (complete) {
            complete();
        }
    }];
}

- (UIView *)unfoldBgView {
    if (!_unfoldBgView) {
        CCWS(weakSelf)
        _unfoldBgView = [UIView createF:(CGRect){0,self.height,self.width,kGSize.height-self.height} BC:[UIColor colorWithHexString:@"333333" alpha:0.2]];
        //收起item的点击层
        UIView *maskView = [UIView createF:_unfoldBgView.bounds BC:[UIColor clearColor]];
        [_unfoldBgView addSubview:maskView];
        [_unfoldBgView addSubview:self.unfoldTab];
        _unfoldBgView.layer.masksToBounds = YES;
        [maskView whenTapped:^{
            [weakSelf hideUnfoldTab:^{
                CCMenuItem *curItem = (CCMenuItem *)weakSelf.menuItems[weakSelf.type];
                curItem.switchType = CCItemClosedType;
            }];
        }];
    }
    return _unfoldBgView;
}

#pragma mark item详细试图展示
- (UITableView *)unfoldTab {
    if (!_unfoldTab) {
        _unfoldTab = [UITableView createF:(CGRect){0,0,self.width,200} BC:[UIColor clearColor] D:self DS:self sepStyle:UITableViewCellSeparatorStyleNone];
        [_unfoldTab registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    }
    return _unfoldTab;
}

#pragma mark UITableViewDelegate & UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self selectMenuItemTitles].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    CCMenuInfo *info = [self selectMenuItemTitles][indexPath.row];
    cell.textLabel.text = info.itemName;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor colorWithHexString:info.selected ?@"3499ff" :@"464c56"];
    cell.textLabel.font = kHelveticaFont(15);
    
    UIView *line = [cell viewWithTag:200];
    if (!line) {
        line = [UIView createF:(CGRect){kLeftSpace,cellHeight-0.5,self.unfoldTab.width-kLeftSpace*2,0.5} BC:[UIColor colorWithHexString:@"f0f0f0" alpha:1]];
        [line setTag:200];
        [cell addSubview:line];
    }
    [line setHidden:([self selectMenuItemTitles].count-1)==indexPath.row ?YES :NO];
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CCWS(weakSelf)
    NSArray *items = [self selectMenuItemTitles];
    CCMenuItem *curItem = (CCMenuItem *)self.menuItems[_type];
    __block CCMenuInfo *curInfo = curItem.curItemInfo;
    __block BOOL isNewItem = NO;
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CCMenuInfo *info = (CCMenuInfo *)obj;
        if (indexPath.row == idx && curInfo != info) {
            info.selected = YES;
            curInfo = info;
            isNewItem = YES;
        } else {
            info.selected = NO;
        }
    }];
    [curItem setSwitchType:CCItemClosedType];
    [curItem setCurItemInfo:curInfo];
    [self reloadSelectMenuItem:curInfo type:_type];
    [self hideUnfoldTab:^{
        if (isNewItem && weakSelf.changeBlock) {
            weakSelf.changeBlock(_curCityInfo,_curSexInfo,_curStarInfo,_curFiltInfo);
        }
    }];
}

- (NSArray *)selectMenuItemTitles {
    return _menus[_type];
}

- (void)reloadSelectMenuItem:(CCMenuInfo *)info type:(CCChoseMenuType)type {
    if (type == CCChoseMenuCity) {
        _curCityInfo = info;
    } else if (type == CCChoseMenuSex) {
        _curSexInfo = info;
    } else if (type == CCChoseMenuStar) {
        _curStarInfo = info;
    } else if (type == CCChoseMenuNormal) {
        _curFiltInfo = info;
    }
}

@end

@implementation CCMenuItem

- (instancetype)initWithFrame:(CGRect)frame curItemInfo:(CCMenuInfo *)curItemInfo {
    if (self = [super initWithFrame:frame]) {
        [self configItem];
        self.curItemInfo = curItemInfo;
        self.switchType = CCItemClosedType;
    }
    return self;
}

- (void)configItem {
    CCWS(weakSelf)
    [self addSubview:self.titleLabel];
    [self addSubview:self.arrowImg];
    [self whenTapped:^{
        weakSelf.switchType = !weakSelf.switchType;
        weakSelf.switchBlock(0, weakSelf.switchType);
    }];
}

- (void)setSwitchType:(CCItemSwitchType)switchType {
    _switchType = switchType;
    [_titleLabel setTextColor:[self titleLabelOpen:!_switchType]];
    [_arrowImg setImage:[self arrowIconOpen:!_switchType]];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel createF:(CGRect){0,0,self.width,self.height-1} TC:[UIColor colorWithHexString:itemNormalColor] FT:kHelveticaFont(13) T:_curItemInfo.itemName AL:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (UIImageView *)arrowImg {
    if (!_arrowImg) {
        UIImage *icon = [self arrowIconOpen:NO];
        _arrowImg = [UIImageView createF:(CGRect){(self.width-icon.size.width-5),(self.height-icon.size.height)/2,icon.size.width,icon.size.height} Img:icon];
    }
    return _arrowImg;
}

- (UIImage *)arrowIconOpen:(BOOL)open {
    return [UIImage imageNamed:open ?@"menuArrowSelect" :@"menuArrowNormal"];
}

- (UIColor *)titleLabelOpen:(BOOL)open {
    return [UIColor colorWithHexString: open?itemSelectColor :itemNormalColor];
}

- (void)setCurItemInfo:(CCMenuInfo *)curItemInfo {
    _curItemInfo = curItemInfo;
    _curItemInfo.selected = YES;
    float width = [CCTool getWidth:_curItemInfo.itemName font:kHelveticaFont(13)];
    UIImage *icon = [self arrowIconOpen:NO];
    float titleOffsetX = (self.bounds.size.width-(width+5+icon.size.width))/2;
    [_titleLabel setX:titleOffsetX];
    [_titleLabel setWidth:width];
    [_titleLabel setText:_curItemInfo.itemName];
    [_arrowImg setX:_titleLabel.right+5];
}

@end
