//
//  ZCHChannelButton.h
//  ZCHScrollChannelView
//
//  Created by 张晨晖 on 2018/3/31.
//  Copyright © 2018年 张晨晖. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCHChannelButton : UIButton

+ (instancetype)zch_ButtonWithTitle:(NSString *)str normalFont:(UIFont *)normalFont normalColor:(UIColor *)normalColor selectedColor:(UIColor *)slectedColor;

@end
