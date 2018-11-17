//
//  CCCircleShareCell.m
//  Dong
//
//  Created by Chenggd on 2018/9/21.
//  Copyright © 2018年 Dong. All rights reserved.
//

#import "CCCircleShareCell.h"

@interface CCCircleShareCell ()

@property (nonatomic, strong) YYAnimatedImageView *coverImg;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *headImg;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UIButton *praiseCCn;
@property (nonatomic, strong) UIImageView *videoImg;
@property (nonatomic, strong) CALayer *maskLayer;

@end


@implementation CCCircleShareCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.layer.cornerRadius = 8.f;
        self.contentView.clipsToBounds = YES;
        [self.contentView addSubview:self.coverImg];
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.headImg];
        [self.contentView addSubview:self.nameLbl];
        [self.contentView addSubview:self.praiseCCn];
        [self.coverImg addSubview:self.videoImg];
        [self.layer insertSublayer:self.maskLayer atIndex:0];
    }
    return self;
}

- (CALayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CALayer layer];
        _maskLayer.backgroundColor = [[UIColor whiteColor] CGColor];
        _maskLayer.frame = self.contentView.bounds;
        _maskLayer.cornerRadius = 8.f;
        _maskLayer.shadowColor = [UIColor colorWithHexString:@"efefef"].CGColor;
        _maskLayer.shadowOffset = CGSizeMake(0, 3);
        _maskLayer.shadowOpacity = 0.8;
        _maskLayer.shadowRadius = 3;
        _maskLayer.masksToBounds = NO;
    }
    return _maskLayer;
}

- (YYAnimatedImageView *)coverImg {
    if (!_coverImg) {
        _coverImg = [[YYAnimatedImageView alloc] initWithFrame:(CGRect){0, 0, self.width, self.height}];
        _coverImg.clipsToBounds = YES;
    }
    return _coverImg;
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [UILabel createF:(CGRect){8,0,(kScreenWidth-10*3)/2-8*2,38} TC:[UIColor colorWithHexString:@"3d3d3d"] FT:kBoldHelvetica(13) T:@"" AL:NSTextAlignmentLeft];
        _titleLbl.numberOfLines = 2;
    }
    return _titleLbl;
}

- (UIImageView *)headImg {
    if (!_headImg) {
        _headImg = [UIImageView createF:(CGRect){6, self.height, 16, 16} Img:[UIImage imageNamed:@"user_default_head"]];
        kViewRadius(_headImg, _headImg.height/2.f);
    }
    return _headImg;
}

- (UILabel *)nameLbl {
    if (!_nameLbl) {
        _nameLbl = [UILabel createF:(CGRect){_headImg.right+4,self.height,self.width-_headImg.right-4*2-70-6,34} TC:[UIColor colorWithHexString:@"757575"] FT:kHelveticaFont(11) T:@"" AL:NSTextAlignmentLeft];
    }
    return _nameLbl;
}

- (UIButton *)praiseCCn {
    if (!_praiseCCn) {
        _praiseCCn = [UIButton createT:@"" C:[UIColor colorWithHexString:@"b9b9b9"] frame:(CGRect){kScreenWidth-56-kLeftSpace,(82-28)/2,70,34}];
        UIImage *icon = [UIImage imageNamed:@"mycollect_praise"];
        [_praiseCCn setImage:icon forState:UIControlStateNormal];
        _praiseCCn.titleLabel.font = kHelveticaFont(11);
        [_praiseCCn setImageEdgeInsets:(UIEdgeInsets){0, -3, 0, 3}];
        [_praiseCCn addTarget:self action:@selector(praiseCircleShare) forControlEvents:UIControlEventTouchUpInside];
    }
    return _praiseCCn;
}

- (UIImageView *)videoImg {
    if (!_videoImg) {
        _videoImg = [UIImageView createF:(CGRect){self.coverImg.width-10-18, self.coverImg.height-10-18, 18, 18} Img:[UIImage imageNamed:@"circle_video"]];
    }
    return _videoImg;
}

- (void)praiseCircleShare {
    
    
}

- (void)setCollShareInfo:(CCMyCollectInfo *)collShareInfo {
    if (collShareInfo) {
        _collShareInfo = collShareInfo;
        
        self.contentView.frame = self.bounds;
        self.contentView.layer.cornerRadius = 8.f;
        self.maskLayer.frame = self.contentView.bounds;
        self.maskLayer.cornerRadius = 8.f;
        
        [_coverImg yy_setImageWithURL:[NSURL URLWithString:_collShareInfo.pic] placeholder:[UIImage imageWithColor:[UIColor colorWithHexString:@"efefef"]]];
        [_coverImg setWidth:self.width];
        [_coverImg setHeight:_collShareInfo.coverHeight];
        [_videoImg setY:_coverImg.height-10-18];
        [_videoImg setHidden:(_collShareInfo.type==2 ?NO :YES)];
        
        [_titleLbl setText:_collShareInfo.title];
        [_titleLbl setY:_coverImg.bottom+8];
        [_titleLbl setHeight:_collShareInfo.contentHeight];
        [_titleLbl setHidden:!(_collShareInfo.contentHeight>0)];
        
        [_headImg yy_setImageWithURL:[NSURL URLWithString:_collShareInfo.avatar] placeholder:[UIImage imageNamed:@"user_default_head"]];
        [_headImg setY:self.height-_headImg.height-10];
        [_nameLbl setText:_collShareInfo.nickname];
        [_nameLbl setY:self.height-_nameLbl.height];
   
        NSString *str = [CCTool transformExtremeByNum:_collShareInfo.praises];
        float width = [CCTool getWidth:str font:_praiseCCn.titleLabel.font];
        [_praiseCCn setWidth:width+_praiseCCn.imageView.image.size.width+3];
        [_praiseCCn setImageEdgeInsets:(UIEdgeInsets){0,-3,0,3}];
        [_praiseCCn setX:self.width-6-_praiseCCn.width];
        [_praiseCCn setY:self.height-_praiseCCn.height];
        [_praiseCCn setTitle:str forState:UIControlStateNormal];
    }
}

@end
