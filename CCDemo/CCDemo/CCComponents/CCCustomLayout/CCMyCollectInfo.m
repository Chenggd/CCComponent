//
//  CCMyCollectInfo.m
//  CCCustomComponent
//
//  Created by Chenggd on 2018/9/26.
//  Copyright © 2018 Dong. All rights reserved.
//

#import "CCMyCollectInfo.h"

@implementation CCMyCollectInfo

- (void)setStyle:(NSInteger)style {
    _style = style;
    _cellHeight = 0;
    if (_style == 1) { //分享样式计算布局信息
        float relWidth = (kScreenWidth-10*3)/2;
        if (self.size) {
            float width = [self.size[@"width"] floatValue];
            float height = [self.size[@"height"] floatValue];
            //默认宽高比
            float roate = width<=height ?3/4.f :4/3.f;
            float relHeight = relWidth/roate;
            //设计标注比例
            float minHeight = relWidth*110/172.f;
            float maxHeight = relWidth*210/172.f;
            relHeight = MIN(maxHeight, relHeight);
            _coverHeight = MAX(minHeight, relHeight);
            _cellHeight += _coverHeight;
        }
        _cellHeight += 8;
//        if ([CCTool isNotBlank:_content]) {
//            float txtHeight = [CCTool getTextHeight:_content linebreakMode:NSLineBreakByCharWrapping font:kHelveticaFont(13) width:(relWidth-8*2)];
//            txtHeight = MIN(38, txtHeight);
//            _contentHeight = MAX(19, txtHeight);
//            _cellHeight += _contentHeight;
//        }
        if ([CCTool isNotBlank:_title]) {
            float txtHeight = [CCTool getTextHeight:_title linebreakMode:NSLineBreakByCharWrapping font:kHelveticaFont(13) width:(relWidth-8*2)];
            txtHeight = MIN(38, txtHeight);
            _contentHeight = MAX(19, txtHeight);
            _cellHeight += _contentHeight;
        }
        //底部条目高
        _cellHeight += 34;
    }
    
}

@end
