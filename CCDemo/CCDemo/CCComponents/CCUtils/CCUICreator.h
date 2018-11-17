//
//  CCUICreator.h
//  CCComponent
//
//  Created by Cheng on 2017/3/7.
//  Copyright © 2017年 Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+CCImage.h"
#import "UIView+Additions.h"
#import "CCHexColor.h"
#import "CCConfig.h"

#define HLine(color,point,width)  [UIImageView createHLineBC:color SP:point L:width]
#define VLine(color,point,height) [UIImageView createVLineBC:color SP:point L:height]
#define HLineCustomBW(color,point,width,borderWidth)  [UIImageView createHLineBC:color SP:point L:width BW:borderWidth]
#define VLineCustomBW(color,point,height,borderWidth) [UIImageView createVLineBC:color SP:point L:height BW:borderWidth]
#define NullImageDefaultFrame CGRectMake((kGSize.width - 110)/2, 72, 110, 110)
typedef enum {
    //白底红字
    kCCBtnNormalRedTxt    = 0,
    //白底黑字
    kCCBtnNormalBlackTxt    = 1,
    //红底白字
    kCCBtnRed       = 2,
    //不可用
    kCCBtnDisabled  = 3,
    //右边排序筛选之类
    kCCCondition = 4,
    kCCBtnClear = 6,
    
} CCBtnType;

@interface UIButton (CCUICreator)

/**
 *  创建系统中常用的按钮
 *  T:Title F:frame TP:type（CCBtnType）
 */
+ (UIButton *)createCCBtnT:(NSString *)title F:(CGRect)frame TP:(CCBtnType)type;

/**
 *  创建系统中常用的按钮
 *  T:Title F:frame TP:type（CCBtnType）TG:(id)target selector:(SEL)sel
 */
+ (UIButton *)createCCBtnT:(NSString *)title F:(CGRect)frame TP:(CCBtnType)type TG:(id)target selector:(SEL)sel;

/**
 *  创建系统中常用的按钮
 *  T:Title F:frame CR:cornerRadius TP:type（CCBtnType）
 */
+ (UIButton *)createCCBtnT:(NSString *)title F:(CGRect)frame CR:(float)radius TP:(CCBtnType)type;

/**
 *  创建系统中常用的按钮
 *  T:Title F:frame FT:font TP:type（CCBtnType）
 */
+ (UIButton *)createCCBtnT:(NSString *)title F:(CGRect)frame FT:(UIFont*)font TP:(CCBtnType)type;

/**
 *  创建系统中常用的按钮
 *  T:Title F:frame FT:font CR:cornerRadius TP:type（CCBtnType）
 */
+ (UIButton *)createCCBtnT:(NSString *)title F:(CGRect)frame FT:(UIFont*)font CR:(float)radius TP:(CCBtnType)type;

/**
 *  圆角button构造器
 *  T:Title C:Color F:frame
 */
+ (UIButton *)createRadiusT:(NSString *)title C:(UIColor *)color F:(CGRect)frame;
/**
 *  圆角button构造器
 *  T:Title C:Color CR:cornerRadius F:frame
 */
+ (UIButton *)createRadiusT:(NSString *)title C:(UIColor *)color CR:(CGFloat)cr F:(CGRect)frame;
/**
 *  button构造器
 *  为了书写简短
 *  T:Title C:Color
 */
+ (UIButton *)createT:(NSString *)title C:(UIColor *)color;

/**
 *  button构造器
 *  为了书写简短
 *  T:Title C:Color ST:SelectedTitle SC:SelectedColor
 */
+ (UIButton *)createT:(NSString *)title C:(UIColor *)color ST:(NSString *)stitle SC:(UIColor *)scolor;

/**
 *  button构造器
 *  为了书写简短
 *  T:Title C:Color
 */
+ (UIButton *)createT:(NSString *)title C:(UIColor *)color frame:(CGRect)frame;

/**
 *  button构造器
 *  为了书写简短
 *  T:Title C:Color ST:SelectedTitle SC:SelectedColor
 */
+ (UIButton *)createT:(NSString *)title C:(UIColor *)color ST:(NSString *)stitle SC:(UIColor *)scolor frame:(CGRect)frame;

/**
 *  将按钮设置成红色
 */
- (void)setRedBtn;
/**
 *  白底黑字
 */
- (void)setNormalBlackTxtBtn;
/**
 *  白底红字
 */
- (void)setNormalRedTxtBtn;
/**
 *  设置按钮不可用
 */
- (void)setDisabledBtn;
/**
 * 设置条件按钮
 */
- (void)setConditionBtn;
/**
 * 设置条件按钮选中
 */
- (void)setConditionBtnSelected:(UIColor *)color;
@end

@interface UIScrollView (CCUICreator)

/**
 *  scrollView构造器
 *  F:frame CS:contentSize
 */
+ (UIScrollView *)createF:(CGRect)frame CS:(CGSize)contentSize;

/**
 *  scrollView构造器
 *  F:frame CS:contentSize BC:backgroundColor
 */
+ (UIScrollView *)createF:(CGRect)frame CS:(CGSize)contentSize BC:(UIColor *)backgoundColor;
@end

@interface UITableView (CCUICreator)
/**
 *  tableview构造器
 *  F:frame BC:backgroundColor D:delegate DS:dataSource
 */
+ (UITableView *)createF:(CGRect)frame BC:(UIColor *)bgClr D:(id<UITableViewDelegate>)d DS:(id<UITableViewDataSource>)ds;
/**
 *  tableview构造器
 *  F:frame BC:backgroundColor D:delegate DS:dataSource SepStyle:UITableViewCellSeparatorStyle
 */
+ (UITableView *)createF:(CGRect)frame BC:(UIColor *)bgClr D:(id<UITableViewDelegate>)d DS:(id<UITableViewDataSource>)ds sepStyle:(UITableViewCellSeparatorStyle)sstyle;

/**
 *  tableview构造器
 *  F:frame BC:backgroundColor D:delegate DS:dataSource style:UITableViewCellSeparatorStyle
 */
+ (UITableView *)createF:(CGRect)frame BC:(UIColor *)bgClr D:(id<UITableViewDelegate>)d DS:(id<UITableViewDataSource>)ds Style:(UITableViewStyle)style;

+ (UITableView *)createF:(CGRect)frame BC:(UIColor *)bgClr D:(id<UITableViewDelegate>)d DS:(id<UITableViewDataSource>)ds Style:(UITableViewStyle)style sepStype:(UITableViewCellSeparatorStyle)sstyle;
@end
typedef UIView *(^OtherViewBlock)(void);
@interface UIView (CCUICreator)

//+ (UIView *)createLoadingMoreView;

/**
 *  用来创建带按钮的空态界面
 *  target 可以为nil
 *  sel    可以为nil
 *  imgFrame 可以为CGRectZero的时候默认居中显示图片
 *  otherView 显示在文案下方用来显示其他的想显示的任何控件
 */
+ (UIView *)createBtnNullViewWithF:(CGRect)frame img:(UIImage *)image imgFrm:(CGRect)imgFrm txt:(NSString*)txt attrTxt:(NSMutableAttributedString *)attrTxt btn:(NSString *)btnName btnTarget:(id)target btnSel:(SEL)sel otherView:(OtherViewBlock)block;

/**
 *  用来创建空态界面
 *  target 可以为nil
 *  sel    可以为nil
 *  imgFrame 可以为CGRectZero的时候默认居中显示图片
 *  otherView 显示在文案下方用来显示其他的想显示的任何控件
 */
+ (UIView *)createNullViewWithF:(CGRect)frame img:(UIImage *)image imgFrm:(CGRect)imgFrm txt:(NSString*)txt  target:(id)target sel:(SEL)sel otherView:(OtherViewBlock)block;
/**
 *  用来创建空态界面
 *  target 可以为nil
 *  sel    可以为nil
 *  imgFrame 可以为CGRectZero的时候默认居中显示图片
 *  otherView 显示在文案下方用来显示其他的想显示的任何控件
 */
+ (UIView *)createNullViewWithF:(CGRect)frame img:(UIImage *)image imgFrm:(CGRect)imgFrm attrTxt:(NSAttributedString*)attrTxt  target:(id)target sel:(SEL)sel otherView:(OtherViewBlock)block;

/**
 *  view构造器
 *  F:frame
 */
+ (instancetype)createF:(CGRect)frame;
+ (instancetype)createF:(CGRect)frame Tag:(NSInteger)tag;

/**
 *  view构造器
 *  F:frame BC:backgroundColor
 */
+ (instancetype)createF:(CGRect)frame BC:(UIColor *)backgroundColor;
+ (instancetype)createF:(CGRect)frame BC:(UIColor *)backgroundColor Tag:(NSInteger)tag;

/**
 *  view构造器
 *  F:frame BC:backgroundColor Tap:触摸事件
 */
+ (instancetype)createF:(CGRect)frame BC:(UIColor *)backgroundColor Tap:(UITapGestureRecognizer *)tapGes;
+ (instancetype)createF:(CGRect)frame BC:(UIColor *)backgroundColor Tap:(UITapGestureRecognizer *)tapGes Tag:(NSInteger)tag;

+ (instancetype)createLoadingViewWithF:(CGRect)frame;
@end

@interface UILabel (CCUICreator)
/**
 *  label构造器
 *  F:frame TC:textColor FT:font
 */
+ (UILabel *)createF:(CGRect)frame TC:(UIColor *)textColor FT:(UIFont *)font;
/**
 *  label构造器
 *  F:frame TC:textColor FT:font T:labelText
 */
+ (UILabel *)createF:(CGRect)frame TC:(UIColor *)textColor FT:(UIFont *)font T:(NSString *)text;
/**
 *  label构造器
 *  F:frame TC:textColor FT:font T:labelText AL:align
 */
+ (UILabel *)createF:(CGRect)frame TC:(UIColor *)textColor FT:(UIFont *)font T:(NSString *)text AL:(NSTextAlignment)align;
/**
 *  label构造器
 *  F:frame TC:textColor FT:font T:labelText Attr:NSAttributedString
 */
+ (UILabel *)createF:(CGRect)frame TC:(UIColor *)textColor FT:(UIFont *)font Attr:(NSAttributedString *)attr;

+ (UILabel *)createF:(CGRect)frame Attr:(NSAttributedString *)attr;
@end

@interface UIImageView (CCUICreator)
/**
 *  创建一条横线
 *  BC:backgroundColor SP:startPoint W:width L:length
 */
+ (UIImageView *)createHLineBC:(UIColor *)backgroundColor SP:(CGPoint)point L:(CGFloat)width;
/**
 *  创建一条竖线
 *  BC:backgroundColor SP:startPoint W:width L:length
 */
+ (UIImageView *)createVLineBC:(UIColor *)backgroundColor SP:(CGPoint)point L:(CGFloat)height;

/**
 *  创建一条横线
 *  BC:backgroundColor SP:startPoint W:width L:length BW:borderwidth
 */
+ (UIImageView *)createHLineBC:(UIColor *)backgroundColor SP:(CGPoint)point L:(CGFloat)width BW:(CGFloat)borderWidth;
/**
 *  创建一条竖线
 *  BC:backgroundColor SP:startPoint W:width L:length BW:borderwidth
 */
+ (UIImageView *)createVLineBC:(UIColor *)backgroundColor SP:(CGPoint)point L:(CGFloat)height BW:(CGFloat)borderWidth;
+ (UIImageView *)createF:(CGRect)frame Img:(UIImage *)img;

+ (UIImageView *)createF:(CGRect)frame Img:(UIImage *)img CM:(UIViewContentMode)contentMode;

@end



@interface UIBarButtonItem (CCUICreator)
+ (UIBarButtonItem *)createWithTitle:(NSString *)title target:(id)target selector:(SEL)sel;
+ (UIBarButtonItem *)createWithImage:(UIImage *)image secImage:(UIImage *)secImage target:(id)target selector:(SEL)sel ;
@end
