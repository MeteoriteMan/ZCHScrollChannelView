//
//  ZCHChannelButton.m
//  ZCHScrollChannelView
//
//  Created by 张晨晖 on 2018/3/31.
//  Copyright © 2018年 张晨晖. All rights reserved.
//

#import "ZCHChannelButton.h"

@interface ZCHChannelButton ()

/// 普通状态字体
@property (nonatomic ,strong) UIFont *normalFont;

/// 选中状态字体
@property (nonatomic ,strong) UIFont *selectedFont;

@end

@implementation ZCHChannelButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.titleLabel.font = self.selectedFont;
    } else {
        self.titleLabel.font = self.normalFont;
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    
}

+ (instancetype)zch_ButtonWithTitle:(NSString *)str normalFont:(UIFont *)normalFont selectedFont:(UIFont *)selectedFont normalColor:(UIColor *)normalColor selectedColor:(UIColor *)slectedColor {
    ZCHChannelButton *btn = [[self alloc] init];
    //初始化
    [btn setTitle:str forState:UIControlStateNormal];
    btn.titleLabel.font = normalFont;
    [btn setTitleColor:normalColor forState:UIControlStateNormal];
    [btn setTitleColor:slectedColor forState:UIControlStateSelected];
    btn.normalFont = normalFont;
    btn.selectedFont = selectedFont;
    return btn;
}

@end
