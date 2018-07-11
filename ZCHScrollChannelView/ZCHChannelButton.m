//
//  ZCHChannelButton.m
//  ZCHScrollChannelView
//
//  Created by 张晨晖 on 2018/3/31.
//  Copyright © 2018年 张晨晖. All rights reserved.
//

#import "ZCHChannelButton.h"

@interface ZCHChannelButton ()

@end

@implementation ZCHChannelButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)zch_ButtonWithTitle:(NSString *)str normalFont:(UIFont *)normalFont normalColor:(UIColor *)normalColor selectedColor:(UIColor *)slectedColor {
    ZCHChannelButton *btn = [[self alloc] init];
    //初始化
    [btn setTitle:str forState:UIControlStateNormal];
    btn.titleLabel.font = normalFont;
    [btn setTitleColor:normalColor forState:UIControlStateNormal];
    [btn setTitleColor:slectedColor forState:UIControlStateSelected];
    return btn;
}

@end
