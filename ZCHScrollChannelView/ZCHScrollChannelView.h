//
//  ZCHScrollChannelView.h
//  ZCHScrollChannelView
//
//  Created by 张晨晖 on 2018/1/20.
//  Copyright © 2018年 张晨晖. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZCHScrollChannelView;

typedef void(^ZCHScrollChannelViewDidSelectItemBlock)(ZCHScrollChannelView *scrollChannelView ,NSInteger index);

@protocol ZCHScrollChannelViewDelegate <NSObject>

@optional
- (void)scrollChannelView:(ZCHScrollChannelView *)scrollChannelView didSelectItemAtIndex:(NSInteger)index;

@end

@interface ZCHScrollChannelView : UIScrollView

///scrollView标签
@property (nonatomic ,strong) NSArray <NSString *> *titleArray;

@property (nonatomic ,weak) id <ZCHScrollChannelViewDelegate> scrollChannelViewDelegate;

// MARK: 间距
///组头间距
@property (nonatomic ,assign) NSInteger intervalHeader;

///组尾间距
@property (nonatomic ,assign) NSInteger intervalFooter;

///组间间距
@property (nonatomic ,assign) NSInteger intervalInLine;

// MARK: 指示器View
/// 滚动条
@property (nonatomic ,strong) UIView *twigView;

/// twigView高度
@property (nonatomic ,assign) CGFloat twigViewHeight;

/// twigView宽度
@property (nonatomic ,assign) CGFloat twigViewWidth;

/// twigView距离底部的高度
@property (nonatomic ,assign) CGFloat twigViewBottom;

/// TwigView切边
@property (nonatomic ,assign) CGFloat twigViewCornerRadius;

/// TwigView等于Channel的宽度
@property (nonatomic ,assign) BOOL twigViewEqualToButtonWidth;

/// 隐藏TwigView
@property (nonatomic ,assign) BOOL twigViewHidden;

// MARK: 颜色
///normal颜色
@property (nonatomic ,strong) UIColor *normalColor;

///选中颜色
@property (nonatomic ,strong) UIColor *selectedColor;

/// twigView颜色
@property (nonatomic ,strong) UIColor *twigViewColor;

// MARK: 字体
/// 字体:默认状态字体
@property (nonatomic ,strong) UIFont *normalFont;

/// 字体:选中状态字体
@property (nonatomic ,strong) UIFont *selectedFont;

/// 默认选中Index
@property (nonatomic ,assign) NSInteger defaultSelectIndex;

// MARK:联动有关
/// 建议使用下面的setSelectItemAtIndex: animated:
@property (nonatomic ,assign) NSInteger selectIndex;

/**
 点击channel中的按钮回调方法.tag为第几个按钮
 */
@property (nonatomic ,copy) ZCHScrollChannelViewDidSelectItemBlock didSelectItemBlock;

/// 选中某个按钮
- (void)setSelectItemAtIndex:(NSInteger)index animated:(BOOL)animated;

- (void)reloadData;

@end
