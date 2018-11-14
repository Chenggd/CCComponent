//
//  ViewController.m
//  CCDemo
//
//  Created by Chenggd on 2018/11/14.
//  Copyright © 2018 Chenggd. All rights reserved.
//

#import "ViewController.h"
#import "CCMainTabVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CCMainTabVC *vc = [CCMainTabVC new];
    [self pushViewController:vc animated:NO];
    
}


@end
