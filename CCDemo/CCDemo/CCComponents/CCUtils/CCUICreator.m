//
//  CCUICreator.m
//  CCComponent
//
//  Created by Cheng on 2017/3/7.
//  Copyright © 2017年 Cheng. All rights reserved.
//

#import "CCUICreator.h"

@implementation UIButton (CCUICreator)
+ (UIButton *)createCCBtnT:(NSString *)title F:(CGRect)frame TP:(CCBtnType)type{
    UIButton * btn = [UIButton createRadiusT:title C:WhiteColor CR:0.f F:frame];
    btn.backgroundColor = [UIColor colorWithHexString:@"F0594E"];
    btn.layer.masksToBounds = YES;
    [self setBtnWithType:type btn:btn];
    return btn;
}

+ (UIButton *)createCCBtnT:(NSString *)title F:(CGRect)frame TP:(CCBtnType)type TG:(id)target selector:(SEL)sel{
    UIButton * btn = [UIButton createRadiusT:title C:WhiteColor CR:0.f F:frame];
    btn.backgroundColor = CCF0594EColor;
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    btn.layer.masksToBounds = YES;
    [self setBtnWithType:type btn:btn];
    return btn;
}

+ (UIButton *)createCCBtnT:(NSString *)title F:(CGRect)frame CR:(float)radius TP:(CCBtnType)type{
    UIButton * btn = [UIButton createRadiusT:title C:WhiteColor CR:radius F:frame];
    btn.backgroundColor = CCF0594EColor;
    btn.layer.masksToBounds = YES;
    [self setBtnWithType:type btn:btn];
    btn.layer.cornerRadius = radius;
    return btn;
}
+ (UIButton *)createCCBtnT:(NSString *)title F:(CGRect)frame FT:(UIFont *)font TP:(CCBtnType)type{
    UIButton * btn = [UIButton createCCBtnT:title F:frame TP:type];
    btn.titleLabel.font = font;
    [self setBtnWithType:type btn:btn];
    return btn;
}
+ (UIButton *)createCCBtnT:(NSString *)title F:(CGRect)frame FT:(UIFont*)font CR:(float)radius TP:(CCBtnType)type {
    UIButton * btn = [UIButton createCCBtnT:title F:frame TP:type];
    btn.titleLabel.font = font;
    [self setBtnWithType:type btn:btn];
    btn.layer.cornerRadius = radius;
    btn.layer.masksToBounds = YES;
    return btn;
}
+ (void)setBtnWithType:(CCBtnType)type btn:(UIButton *)btn{
    switch (type) {
        case kCCBtnNormalRedTxt:
            [btn setNormalRedTxtBtn];
            break;
        case kCCBtnNormalBlackTxt:
            [btn setNormalBlackTxtBtn];
            break;
        case kCCBtnRed:
            [btn setRedBtn];
            break;
        case kCCBtnDisabled:
            [btn setDisabledBtn];
            break;
        case kCCCondition:
            [btn setConditionBtn];
            break;
        case kCCBtnClear:
            [btn setClearBtn];
        default:
            break;
    }
}
+ (UIButton *)createRadiusT:(NSString *)title C:(UIColor *)color F:(CGRect)frame   {
    return [UIButton createRadiusT:title C:color CR:frame.size.height/2 F:frame];
}

+ (UIButton *)createRadiusT:(NSString *)title C:(UIColor *)color CR:(CGFloat)cr F:(CGRect)frame {
    UIButton * btn = [UIButton createT:title C:color ST:title SC:color frame:frame];
    btn.layer.cornerRadius = cr;
    btn.layer.borderWidth  = .5f;
    btn.layer.borderColor  = color.CGColor;
    return btn;
}


+ (UIButton *)createT:(NSString *)title C:(UIColor *)color {
    return [self createT:title C:color ST:title SC:color frame:CGRectZero];
}

+ (UIButton *)createT:(NSString *)title C:(UIColor *)color ST:(NSString *)stitle SC:(UIColor *)scolor {
    return [self createT:title C:color ST:stitle SC:scolor frame:CGRectZero];
}

+ (UIButton *)createT:(NSString *)title C:(UIColor *)color frame:(CGRect)frame {
    return  [self createT:title C:color ST:title SC:color frame:frame];
}

+ (UIButton *)createT:(NSString *)title C:(UIColor *)color ST:(NSString *)stitle SC:(UIColor *)scolor frame:(CGRect)frame {
    return [UIButton createT:title attr:nil sattr:nil C:color ST:stitle SC:scolor frame:frame];
}
+ (UIButton *)createT:(NSString *)title attr:(NSAttributedString*)attr sattr:(NSAttributedString *)sattr C:(UIColor *)color ST:(NSString *)stitle SC:(UIColor *)scolor frame:(CGRect)frame {
    UIButton * btn        = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title ) [btn setTitle:title         forState:UIControlStateNormal];
    if (stitle) [btn setTitle:stitle        forState:UIControlStateSelected];
    if (color ) [btn setTitleColor:color    forState:UIControlStateNormal];
    if (scolor) [btn setTitleColor:scolor   forState:UIControlStateSelected];
    if (attr  ) [btn setAttributedTitle:attr forState:UIControlStateNormal];
    if (sattr)  [btn setAttributedTitle:sattr forState:UIControlStateSelected];
    btn.frame = frame;
    return btn;
}

- (void)setRedBtn {
    self.enabled = YES;
    
    [self setTitleColor:WhiteColor forState:UIControlStateNormal];
    
    [self setBackgroundImage:[UIImage imageWithColor:CCF0594EColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:CCColorRGB(0xB23330)] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageWithColor:CCF0594EColor] forState:UIControlStateSelected];
    [self setBackgroundImage:[UIImage imageWithColor:CCColorRGB(0xDEDEDE)] forState:UIControlStateDisabled];
    [self setTitleColor:WhiteColor forState:UIControlStateDisabled];
}

- (void)setNormalBlackTxtBtn {
    [self setTitleColor:CCText43Color forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:WhiteColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:CCText99Color] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageWithColor:WhiteColor] forState:UIControlStateSelected];
}

- (void)setNormalRedTxtBtn {
    [self setTitleColor:CCF0594EColor forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:WhiteColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:CCText99Color] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageWithColor:WhiteColor] forState:UIControlStateSelected];
    
    [self setBackgroundImage:[UIImage imageWithColor:WhiteColor] forState:UIControlStateDisabled];
    
    [self setTitleColor:CCColorRGB(0xDEDEDE) forState:UIControlStateDisabled];
}


- (void)setDisabledBtn {
    [self setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:CCF0594EColor] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:CCColorRGB(0xB23330)] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageWithColor:CCF0594EColor] forState:UIControlStateSelected];
    [self setBackgroundImage:[UIImage imageWithColor:CCColorRGB(0xDEDEDE)] forState:UIControlStateDisabled];
    [self setTitleColor:WhiteColor forState:UIControlStateDisabled];
    self.enabled = NO;
}

- (void)setConditionBtn {
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = kHelveticaFont(14);
    [self setTitleEdgeInsets:UIEdgeInsetsMake(4, 0, 0, 0)];
    [self setTitleColor:CCText66Color forState:UIControlStateNormal];
    UIImageView * imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"foud_sort"]];
    imgV.tag = 99;
    imgV.frame = CGRectMake(self.width - 5, self.height - 17, 5, 5);
    [self  addSubview:imgV];
}

- (void)setClearBtn {
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = kHelveticaFont(14);
    [self setTitleEdgeInsets:UIEdgeInsetsMake(4, 0, 0, 0)];
    [self setTitleColor:CCText66Color forState:UIControlStateNormal];
}

- (void)setConditionBtnSelected:(UIColor *)color{
    [self setTitleColor:color forState:UIControlStateNormal];
    UIImageView * imgV = [self viewWithTag:99];
    imgV.image = [imgV.image imageWithTintColor:color];
}

@end


@implementation UIScrollView (CCUICreator)
+ (instancetype)createF:(CGRect)frame {
    UIScrollView * sclView = [super createF:frame];
    sclView.showsVerticalScrollIndicator = NO;
    sclView.showsHorizontalScrollIndicator = NO;
    return sclView;
}

+ (instancetype)createF:(CGRect)frame BC:(UIColor *)backgroundColor {
    UIScrollView * sclView = [super createF:frame BC:backgroundColor];
    [sclView setNormalSclView:backgroundColor];
    return sclView;
}
+ (instancetype)createF:(CGRect)frame BC:(UIColor *)backgroundColor Tap:(UITapGestureRecognizer *)tapGes {
    UIScrollView * sclView = [super createF:frame BC:backgroundColor Tap:tapGes];
    [sclView setNormalSclView:[UIColor whiteColor]];
    return sclView;
}

+ (instancetype)createF:(CGRect)frame CS:(CGSize)contentSize {
    return [self createF:frame CS:contentSize BC:[UIColor clearColor]];
}

+ (instancetype)createF:(CGRect)frame CS:(CGSize)contentSize BC:(UIColor*)backgoundColor {
    UIScrollView * scl = [[[self class] alloc] initWithFrame:frame];
    scl.contentSize = contentSize;
    [scl setNormalSclView:backgoundColor];
    return scl;
}
- (void)setNormalSclView:(UIColor *)clr {
    self.backgroundColor = clr;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
}
@end

@implementation UITableView (CCUICreator)
+ (UITableView *)createF:(CGRect)frame BC:(UIColor *)bgClr D:(id<UITableViewDelegate>)d DS:(id<UITableViewDataSource>)ds {
    return [self createF:frame BC:bgClr D:d DS:ds sepStyle:UITableViewCellSeparatorStyleSingleLine];
}
+ (UITableView *)createF:(CGRect)frame BC:(UIColor *)bgClr D:(id<UITableViewDelegate>)d DS:(id<UITableViewDataSource>)ds sepStyle:(UITableViewCellSeparatorStyle)sstyle{
    return [self createF:frame BC:bgClr D:d DS:ds Style:UITableViewStylePlain sepStype:sstyle];
}

+ (UITableView *)createF:(CGRect)frame BC:(UIColor *)bgClr D:(id<UITableViewDelegate>)d DS:(id<UITableViewDataSource>)ds Style:(UITableViewStyle)sstyle {
    return [self createF:frame BC:bgClr D:d DS:ds Style:sstyle sepStype:UITableViewCellSeparatorStyleSingleLine];
}

+ (UITableView *)createF:(CGRect)frame BC:(UIColor *)bgClr D:(id<UITableViewDelegate>)d DS:(id<UITableViewDataSource>)ds Style:(UITableViewStyle)style sepStype:(UITableViewCellSeparatorStyle)sstyle {
    UITableView * table = [[UITableView alloc] initWithFrame:frame style:style];
    if (bgClr) table.backgroundColor = bgClr;
    if (d) table.delegate = d;
    if (ds) table.dataSource = ds;
    table.separatorStyle = sstyle;
    return table;
}
@end


@implementation UIView (CCUICreator)

//+ (UIView *)createLoadingMoreView {
//    UIView * _loadingView = [[UIView alloc] init];
//    _loadingView.frame = CGRectMake(0, 0, kScreenWidth, 44);
//    _loadingView.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
//    NSMutableArray *arrayRefImg = [[NSMutableArray alloc] init];
//    for (int i = 1; i<= 8; i++) {
//        [arrayRefImg addObject:[UIImage imageNamed:[NSString stringWithFormat:@"refreshGray_%d.png",i]]];
//    }
//
//    CGFloat width = [CCTool getWidth:CCLocalString(@"assets_trade_log_loading") font:kHelveticaFont(13)];
//
//    float offset = 8.f;
//    UIImageView *refreshImgView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refreshGray_1"]];
//    refreshImgView.animationImages = arrayRefImg;
//    refreshImgView.animationDuration = 0.64;
//    refreshImgView.animationRepeatCount = 0;
//    refreshImgView.frame = CGRectMake((kGSize.width - width - offset - [UIImage imageNamed:@"refreshGray_1"].size.width) / 2, 1.f, [UIImage imageNamed:@"refreshGray_1"].size.width, 50.f);
//    refreshImgView.contentMode = UIViewContentModeCenter;
//    refreshImgView.tag = 101;
//    [_loadingView addSubview:refreshImgView];
//    [refreshImgView startAnimating];
//
//    CCDefaltLabel *loadingTitleLab = [[CCDefaltLabel alloc] init];
//    loadingTitleLab.frame = CGRectMake(CGRectGetMaxX(refreshImgView.frame) + offset, 1, width, 50);
//    loadingTitleLab.text = CCLocalString(@"assets_trade_log_loading");
//    loadingTitleLab.textAlignment = KTextAlignmentLeft;
//    loadingTitleLab.font = kHelveticaFont(13);
//    loadingTitleLab.tag = 102;
//    loadingTitleLab.textColor = [UIColor colorWithHexString:@"#898989"];
//    [_loadingView addSubview:loadingTitleLab];
//    
//
//    return _loadingView;
//
//}

+ (UIView *)createBtnNullViewWithF:(CGRect)frame img:(UIImage *)image imgFrm:(CGRect)imgFrm txt:(NSString*)txt attrTxt:(NSMutableAttributedString *)attrTxt btn:(NSString *)btnName btnTarget:(id)target btnSel:(SEL)sel otherView:(OtherViewBlock)block {
    return [self createNullViewWithF:frame img:image imgFrm:imgFrm txt:txt attrTxt:attrTxt btnName:btnName target:target sel:sel otherView:block];
}

+ (UIView *)createNullViewWithF:(CGRect)frame img:(UIImage *)image imgFrm:(CGRect)imgFrm txt:(NSString*)txt  target:(id)target sel:(SEL)sel otherView:(OtherViewBlock)block{
    return [self createNullViewWithF:frame img:image imgFrm:imgFrm txt:txt attrTxt:nil btnName:nil target:target sel:sel otherView:block];
}
+ (UIView *)createNullViewWithF:(CGRect)frame img:(UIImage *)image imgFrm:(CGRect)imgFrm txt:(NSString*)txt attrTxt:(NSAttributedString *)attrTxt btnName:(NSString *)btnName target:(id)target sel:(SEL)sel otherView:(OtherViewBlock)block{
    CGFloat bottomTmp = 0;
    UIView * v = [UIView createF:frame BC:CCBgColor];
    CGFloat imgW =  110;
    UIImageView * imgV = [UIImageView createF:CGRectMake(0, (v.height/2 - imgW/2) - (38 * (txt.length > 0) - 20), v.width, imgW) Img:image];
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    imgV.tag = 100;
    if (!CGRectEqualToRect(CGRectZero, imgFrm) && !CGRectEqualToRect(CGRectNull, imgFrm)) {
        imgV.frame = imgFrm;
    }
    bottomTmp = imgV.bottom;
    [v addSubview:imgV];
    if (txt.length > 0 || attrTxt.length > 0) {
        UILabel * lbl = [UILabel createF:CGRectZero TC:CCText99Color FT:kHelveticaFont(16) T:txt];
        if (attrTxt.length > 0) {
            lbl.attributedText = attrTxt;
        }
        lbl.numberOfLines = 0;
        [lbl sizeToFit];
        lbl.frame = CGRectMake(0, imgV.bottom + 24, v.width, lbl.height);
        
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.tag = 101;
        bottomTmp = lbl.bottom;
        [v addSubview:lbl];
    }
    if (target && sel && (!btnName || btnName.length == 0)) {
        UIButton * btn = [UIButton createT:@"" C:ClearColor frame:v.bounds];
        
        [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:btn];
    }
    if (btnName && btnName.length > 0) {
        UIButton * btn = [UIButton createT:btnName C:ClearColor frame:CGRectZero];
        [btn sizeToFit];
        btn.frame = CGRectMake((v.width - btn.width - 32)/2, bottomTmp + 32, btn.width + 32, 44);
        btn.layer.borderColor  = CCLineColor.CGColor;
        btn.layer.borderWidth  = 1;
        btn.layer.cornerRadius = 4;
        btn.titleLabel.font = kHelveticaFont(16);
        [btn setTitleColor:CCText66Color forState:UIControlStateNormal];
        [btn setTitleColor:CCText66Color forState:UIControlStateSelected];
        [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:btn];
    }
    if (block) {
        UIView * view = block();
        view.top = imgV.bottom + 36 * (txt.length != 0 || attrTxt.length != 0) + 40;
        view.center = CGPointMake(frame.size.width/2, view.top + view.height/2);
        [v addSubview:view];
    }
    return v;
}
+ (UIView *)createNullViewWithF:(CGRect)frame img:(UIImage *)image imgFrm:(CGRect)imgFrm attrTxt:(NSAttributedString*)attrTxt  target:(id)target sel:(SEL)sel otherView:(OtherViewBlock)block{
    return [self createNullViewWithF:frame img:image imgFrm:imgFrm txt:@"" attrTxt:attrTxt btnName:nil target:target sel:sel otherView:block];
}

+ (instancetype)createF:(CGRect)frame {
    return [[self class] createF:frame BC:[UIColor whiteColor]];
}

+ (instancetype)createF:(CGRect)frame Tag:(NSInteger)tag {
    UIView * v = [self createF:frame];
    v.tag = tag;
    return v;
}

+ (instancetype)createF:(CGRect)frame BC:(UIColor *)backgroundColor {
    return [[self class] createF:frame BC:backgroundColor Tap:nil];
}
+ (instancetype)createF:(CGRect)frame BC:(UIColor *)backgroundColor Tag:(NSInteger)tag {
    UIView * v = [self createF:frame BC:backgroundColor];
    v.tag = tag;
    return v;
}

+ (instancetype)createF:(CGRect)frame BC:(UIColor *)backgroundColor Tap:(UITapGestureRecognizer *)tapGes {
    UIView * v = [[[self class] alloc] initWithFrame:frame];
    v.backgroundColor = backgroundColor;
    if (tapGes) {
        [v addGestureRecognizer:tapGes];
    }
    return v;
}
+ (instancetype)createF:(CGRect)frame BC:(UIColor *)backgroundColor Tap:(UITapGestureRecognizer *)tapGes Tag:(NSInteger)tag {
    UIView * v = [self createF:frame BC:backgroundColor Tap:tapGes];
    v.tag = tag;
    return v;
}

+ (instancetype)createLoadingViewWithF:(CGRect)frame {
    UIView * loadingView = [[UIView alloc] initWithFrame:frame];
    loadingView.layer.masksToBounds = YES;
    loadingView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_white.png"]];
    imageView.center = CGPointMake(imageView.width / 2 + 14.f, loadingView.height / 2);
    [loadingView addSubview:imageView];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.64;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = CGFLOAT_MAX;
    rotationAnimation.removedOnCompletion = NO;
    
    [imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_white_center.png"]];
    imageView.center = CGPointMake(imageView.width / 2 + 14.f, loadingView.height / 2);
    [loadingView addSubview:imageView];
    return loadingView;
}
@end

@implementation UILabel (CCUICreator)
+ (UILabel *)createF:(CGRect)frame TC:(UIColor *)textColor FT:(UIFont *)font {
    UILabel * lbl = [super createF:frame BC:[UIColor clearColor]];
    lbl.textColor = textColor;
    lbl.font      = font;
    return lbl;
}
+ (UILabel *)createF:(CGRect)frame TC:(UIColor *)textColor FT:(UIFont *)font T:(NSString *)text {
    UILabel * lbl = [self createF:frame TC:textColor FT:font];
    lbl.text  = text;
    return lbl;
}
+ (UILabel *)createF:(CGRect)frame TC:(UIColor *)textColor FT:(UIFont *)font T:(NSString *)text AL:(NSTextAlignment)align {
    UILabel * lbl = [self createF:frame TC:textColor FT:font];
    lbl.text  = text;
    lbl.textAlignment = align;
    return lbl;
}
+ (UILabel *)createF:(CGRect)frame TC:(UIColor *)textColor FT:(UIFont *)font Attr:(NSAttributedString *)attr {
    UILabel * lbl = [self createF:frame TC:textColor FT:font];
    lbl.attributedText = attr;
    return lbl;
}
+ (UILabel *)createF:(CGRect)frame Attr:(NSAttributedString *)attr {
    UILabel * lbl = [self createF:frame];
    lbl.attributedText = attr;
    return lbl;
}

@end
@implementation UIImageView (CCUICreator)
+ (UIImageView *)createHLineBC:(UIColor *)backgroundColor SP:(CGPoint)point L:(CGFloat)width {
    UIImageView * line = [UIImageView createF:CGRectMake(point.x, point.y, width, .5f) BC:backgroundColor];
    return line;
}
+ (UIImageView *)createVLineBC:(UIColor *)backgroundColor SP:(CGPoint)point L:(CGFloat)height {
    UIImageView * line = [UIImageView createF:CGRectMake(point.x, point.y, .5f, height) BC:backgroundColor];
    return line;
}

/**
 *  创建一条横线
 *  BC:backgroundColor SP:startPoint W:width L:length BW:borderwidth
 */
+ (UIImageView *)createHLineBC:(UIColor *)backgroundColor SP:(CGPoint)point L:(CGFloat)width BW:(CGFloat)borderWidth {
    UIImageView * line = [UIImageView createF:CGRectMake(point.x, point.y, width, borderWidth) BC:backgroundColor];
    return line;
}
/**
 *  创建一条竖线
 *  BC:backgroundColor SP:startPoint W:width L:length BW:borderwidth
 */
+ (UIImageView *)createVLineBC:(UIColor *)backgroundColor SP:(CGPoint)point L:(CGFloat)height BW:(CGFloat)borderWidth {
    UIImageView * line = [UIImageView createF:CGRectMake(point.x, point.y, borderWidth, height) BC:backgroundColor];
    return line;
}

+ (UIImageView *)createF:(CGRect)frame Img:(UIImage *)img {
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.image = img;
    return imgView;
}
+ (UIImageView *)createF:(CGRect)frame Img:(UIImage *)img CM:(UIViewContentMode)contentMode {
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.image = img;
    imgView.contentMode = contentMode;
    return imgView;
}
@end


@implementation UIBarButtonItem (CCUICreator)
+ (UIBarButtonItem *)createWithTitle:(NSString *)title target:(id)target selector:(SEL)sel {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 44)];
    btn.exclusiveTouch = YES;
    //    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateSelected];
    [btn setTitleColor:CCText66Color forState:UIControlStateNormal];
    [btn setTitleColor:CCText66Color forState:UIControlStateHighlighted];
    [btn setTitleColor:CCText66Color forState:UIControlStateSelected];
    btn.titleLabel.font = kHelveticaFont(14);
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    UIBarButtonItem * btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return btnItem;
}
+ (UIBarButtonItem *)createWithImage:(UIImage *)image secImage:(UIImage *)secImage target:(id)target selector:(SEL)sel {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 29, 44)];
    btn.exclusiveTouch = YES;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:secImage?secImage:image forState:UIControlStateHighlighted];
    UIBarButtonItem * btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return btnItem;
}

@end
