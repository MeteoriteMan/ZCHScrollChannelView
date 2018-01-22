//
//  ZCHChannelScrollView.h
//  ZCHScrollChannelView
//
//  Created by 张晨晖 on 2018/1/20.
//  Copyright © 2018年 张晨晖. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCHChannelScrollView : UIScrollView

///scrollView标签
@property (nonatomic ,strong) NSArray <NSString *> *titleArray;

///组头间距
@property (nonatomic ,assign) NSInteger intervalHeader;

///组尾间距
@property (nonatomic ,assign) NSInteger intervalFooter;

///组间间距
@property (nonatomic ,assign) NSInteger intervalInLine;

//normal颜色
@property (nonatomic ,assign) UIColor *normalColor;

//选中颜色
@property (nonatomic ,assign) UIColor *selectedColor;

@property (nonatomic ,copy) void(^chancelSelectedBlock)(NSInteger tag);

@end

@interface UIButton (zch_Button)

+ (instancetype)zch_ButtonWithTitle:(NSString *)str andFont:(UIFont *)font andNormalColor:(UIColor *)normalColor andSelectedColor:(UIColor *)slectedColor;

@end
