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
    [self addCell:@"Animated Image" class:@"YYImageDisplayExample"];
    [self addCell:@"Progressive Image" class:@"YYImageProgressiveExample"];
    [self.tableView reloadData];
    
}

- (void)addCell:(NSString *)title class:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
