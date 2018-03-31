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

// MARK: 间距
///组头间距
@property (nonatomic ,assign) NSInteger intervalHeader;

///组尾间距
@property (nonatomic ,assign) NSInteger intervalFooter;

///组间间距
@property (nonatomic ,assign) NSInteger intervalInLine;

// MARK: 颜色
///normal颜色
@property (nonatomic ,assign) UIColor *normalColor;

///选中颜色
@property (nonatomic ,assign) UIColor *selectedColor;

// MARK: 字体
//字体:默认system.re
@property (nonatomic ,strong) UIFont *font;

// MARK: 字体大小
//字体大小:默认15
@property (nonatomic ,assign) CGFloat fontSize;

// MARK:联动有关
//选中第几个Btn(tag,0-n).传入参数滚动到相应Btn
@property (nonatomic ,assign) NSInteger btnTag;

/**
 点击channel中的按钮回调方法.tag为第几个按钮
 */
@property (nonatomic ,copy) void(^chancelSelectedBlock)(NSInteger tag);

@end
