//
//  CCMainTabVC.m
//  CCDemo
//
//  Created by Chenggd on 2018/11/14.
//  Copyright © 2018 Chenggd. All rights reserved.
//

#import "CCMainTabVC.h"

@interface CCMainTabVC ()

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;

@end

@implementation CCMainTabVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CCDemo";
    
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    
    [self addCell:@"Banner视图" class:@"CCBannerVC"];
    [self addCell:@"菜单栏" class:@"CCSegmentVC"];
    [self addCell:@"不规则等宽瀑布流" class:@"CCWaterfallFlowVC"];
    [self addCell:@"ScrollView多级嵌套" class:@"CCScrollVC"];
    [self addCell:@"弹幕" class:@"CCGiftAnimationsExample"];
    [self addCell:@"直播动效" class:@"CCGiftAnimationsExample"];
    
    [self.tableView reloadData];
    
}

- (void)addCell:(NSString *)title class:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CCDemo"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CCDemo"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *vc = class.new;
        vc.title = _titles[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
