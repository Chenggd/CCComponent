//
//  UIView+WhenTappedBlocks.h
//  CCComponent
//
//  Created by Cheng on 2017/6/21.
//  Copyright © 2017年 Cheng. All rights reserved.
//

#if NS_BLOCKS_AVAILABLE

#import <UIKit/UIKit.h>

typedef void (^CCWhenTappedBlock)();

@interface UIView (CCWhenTappedBlocks) <UIGestureRecognizerDelegate>

- (void)whenTapped:(CCWhenTappedBlock)block;
- (void)whenDoubleTapped:(CCWhenTappedBlock)block;
- (void)whenTwoFingerTapped:(CCWhenTappedBlock)block;
- (void)whenTouchedDown:(CCWhenTappedBlock)block;
- (void)whenTouchedUp:(CCWhenTappedBlock)block;

@end

#endif

