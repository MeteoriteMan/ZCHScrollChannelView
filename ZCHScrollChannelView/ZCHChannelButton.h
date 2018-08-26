//
//  ZCHChannelButton.h
//  ZCHScrollChannelView
//
//  Created by 张晨晖 on 2018/3/31.
//  Copyright © 2018年 张晨晖. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCHChannelButton : UIButton

/**
 创建按钮方法

 @param str 按钮文字
 @param normalFont 按钮普通状态字体
 @param selectedFont 按钮选中状态字体
 @param normalColor 按钮普通状态颜色
 @param slectedColor 按钮选中状态颜色
 @return 按钮
 */
+ (instancetype)zch_ButtonWithTitle:(NSString *)str normalFont:(UIFont *)normalFont selectedFont:(UIFont *)selectedFont normalColor:(UIColor *)normalColor selectedColor:(UIColor *)slectedColor;

@end
