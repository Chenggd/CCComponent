//
//  CCConfig.h
//  TestDemo
//
//  Created by Cheng on 2017/9/19.
//  Copyright © 2017年 Cheng. All rights reserved.
//

#ifndef CCConfig_h
#define CCConfig_h

#pragma mark 屏幕相关
//得到屏幕高度
#define kGSize                      [[UIScreen mainScreen] bounds].size
#define kScreenWidth                kGSize.width
#define kScreenHeight               [[UIScreen mainScreen] applicationFrame].size.height
#define kIOS7FitHeight(x)           (kIOS7 ? x + 64 : x)
#define kNavHeight                  (kIOS7 ? 0 : 64.f)
#define kNavStatusHeight            (kIPhoneX ? 44 : 20.f)
#define kNavStatusFitHeight(x)      (kIPhoneX ? x + 44 : x + 20.f)
#define kGetHeightByNumber568(a)    ((a / 568.f) * kGSize.height)
#define kGetWidthByNumber568(a)     ((a / 375.f) * kGSize.width)
#define kPhone6Plus(a)              ((kIPhone6 || kIPhone6Plus) ? kGetHeightByNumber568(a) : a)

// 判断iphone5
#define kIPhone5                    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断iphone4  ipad上跑iphone 共用
#define kIPhone4                    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断iphone6
#define kIPhone6                    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
// 判断iphone6 plus
#define kIPhone6PlusZoomIn          ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIPhone6Plus                ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIPhoneX                    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIPhoneXFitHeight(x) (kIPhoneX ? x + 88 : x + 64)
#define kIPhoneXBottomHeight(x) (kIPhoneX ? x + 34 : x + 0)


#define kLiveSpace 10.f
#define kLeftSpace 16.f

#pragma mark 对系统一些方法或属性的简单封装
// Helvetica字体相关
#define kHelveticaFont(x)           [UIFont fontWithName:@"Helvetica" size:x]
#define kBoldHelvetica(x)           [UIFont boldSystemFontOfSize:x]
#define kOtherHelvetica(fontName,x)    [UIFont fontWithName:fontName size:x]
// 颜色相关
#define CCColorRGB(rgbValue)        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define CCColorRGBA(rgbValue,alpha)     [CCColorRGB(rgbValue) colorWithAlphaComponent:(alpha?alpha:1.f)]

//ui规范颜色
#define BlackColor                  [UIColor blackColor]    // 0.0 white
#define DarkGrayColor               [UIColor darkGrayColor] // 0.333 white
#define LightGrayColor              [UIColor lightGrayColor]// 0.667 white
#define WhiteColor                  [UIColor whiteColor]    // 1.0 white
#define GrayColor                   [UIColor grayColor]     // 0.5 white
#define RedColor                    [UIColor redColor]      // 1.0, 0.0, 0.0 RGB
#define GreenColor                  [UIColor greenColor]    // 0.0, 1.0, 0.0 RGB
#define BlueColor                   [UIColor blueColor]     // 0.0, 0.0, 1.0 RGB
#define CyanColor                   [UIColor cyanColor]     // 0.0, 1.0, 1.0 RGB
#define YellowColor                 [UIColor yellowColor]   // 1.0, 1.0, 0.0 RGB
#define MagentaColor                [UIColor magentaColor]  // 1.0, 0.0, 1.0 RGB
#define OrangeColor                 [UIColor orangeColor]   // 1.0, 0.5, 0.0 RGB
#define PurpleColor                 [UIColor purpleColor]   // 0.5, 0.0, 0.5 RGB
#define BrownColor                  [UIColor brownColor]    // 0.6, 0.4, 0.2 RGB
#define ClearColor                  [UIColor clearColor]    // 0.0 white, 0.0 alpha

#define CCBgColor                CCColorRGB(0xF6F6F6)     //背景色
#define CCTabLineColor           CCColorRGB(0xEEEEEE)     //tab底下分割线的颜色
#define CCSelectorColor          CCColorRGB(0xEEEEEE)     //cell或者其他选中时候的颜色
#define CCLineColor              CCColorRGB(0xDEDEDE)     //通用分割线的颜色
#define CCDisableColor           CCColorRGB(0xDEDEDE)     //通用分割线的颜色
#define CCTextCFColor            CCColorRGB(0xCFCFCF)
#define CCText43Color            CCColorRGB(0x434343)
#define CCText66Color            CCColorRGB(0x666666)
#define CCText99Color            CCColorRGB(0x999999)
#define CCF0594EColor            CCColorRGB(0xF0594E)
#define CCLinkTextColor          CCColorRGB(0x478FEC)
#define CCDownTextColor          CCColorRGB(0x318D11)
#define CCOrangeColor            CCColorRGB(0xF87D2F)


//tag
#define kHintHudTag           89757



// UserDefault 相关
#define CCUserDefault                  [NSUserDefaults standardUserDefaults]
#define CCNotiYCenter                  [NSNotificationCenter defaultCenter]
#define CCSetUserDefaults(id,key)      [[NSUserDefaults standardUserDefaults] setObject:id forKey:key]
#define CCGetUserDefaults(key)         [[NSUserDefaults standardUserDefaults] objectForKey:key]

#pragma 通知
#define kNotifScrollGoTop                     @"goTop"
#define kNotifScrollLeaveTop                  @"leaveTop"
#define kNotifScrollEnableMainView            @"enableMainScrollView"
#define kNotifScrollBackToTop                 @"childBackToTop"


//weakSelf
#define CCWS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define CCWeakObj(o) try{}@finally{} __weak typeof(o) o##Weak = o;
#define CCSS typeof(weakSelf) __strong strongSelf = weakSelf;

// View 圆角
#define kViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]



#define dispatch_sync_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_async_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}


#endif /* CCConfig_h */
