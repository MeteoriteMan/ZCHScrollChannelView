//
//  ZCHScrollChannelView.m
//  ZCHScrollChannelView
//
//  Created by 张晨晖 on 2018/1/20.
//  Copyright © 2018年 张晨晖. All rights reserved.
//

#import "ZCHScrollChannelView.h"
#import "ZCHChannelButton.h"

@interface ZCHScrollChannelView ()

/// 滚动条
@property (nonatomic ,strong) UIView *twigView;

/// 正在显示的Item
@property (nonatomic ,strong) NSMutableDictionary *cachedItems;

/// 缓存池内的Item
@property (nonatomic ,strong) NSMutableSet *reusableItems;

@property (nonatomic ,assign) BOOL needsReload;

/// 缓存计算的item的x位置
@property (nonatomic ,assign) CGFloat *itemX;

/// 缓存计算的item宽度
@property (nonatomic ,assign) CGFloat *itemWidth;

/// 当前选中行
@property (nonatomic ,assign) NSInteger selectedRow;

@end

@implementation ZCHScrollChannelView {
    UIColor *_twigViewColor;
    NSInteger _selectIndex;
}

// MARK: 属性有关
//颜色
- (UIColor *)normalColor {
    if (_normalColor == nil) {
        _normalColor = [UIColor groupTableViewBackgroundColor];
    }
    return _normalColor;
}

- (UIColor *)selectedColor {
    if (_selectedColor == nil) {
        _selectedColor = [UIColor darkTextColor];
    }
    return _selectedColor;
}

- (UIColor *)twigViewColor {
    if (_twigViewColor == nil) {
        _twigViewColor = self.selectedColor;
    }
    return _twigViewColor;
}

- (void)setTwigViewColor:(UIColor *)twigViewColor {
    _twigViewColor = twigViewColor;
    _twigView.backgroundColor = twigViewColor;
}

//字体
- (UIFont *)normalFont {
    if (_normalFont == nil) {
        _normalFont = [UIFont systemFontOfSize:15];
    }
    return _normalFont;
}

- (UIFont *)selectedFont {
    if (_selectedFont == nil) {
        _selectedFont = self.normalFont;
    }
    return _selectedFont;
}

- (UIView *)twigView {
    if (_twigView == nil) {
        _twigView = [UIView new];
        _twigView.backgroundColor = self.twigViewColor;
    }
    return _twigView;
}

- (NSInteger)selectIndex {
    return self.selectedRow;
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    [self selectedBtnWithTag:selectIndex];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupConfig];
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupConfig];
    [self setupUI];
}

- (void)reloadData {
    free(self.itemWidth);
    free(self.itemX);
    self.selectedRow = -1;
    // 移除已经显示的View.缓存池内的View
    [[self.cachedItems allValues] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.reusableItems makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.cachedItems removeAllObjects];
    [self.reusableItems removeAllObjects];
    /// 存储Item的宽度
    self.itemWidth = malloc(self.titleArray.count * sizeof(CGFloat));
    self.itemX = malloc(self.titleArray.count * sizeof(CGFloat));
    [self setContentSize];
    self.needsReload = NO;
    [self layoutChannelView];
    [self updateTwigView];
}

- (void)layoutSubviews {
    [self reloadDataIfNeeded];
    [self layoutChannelView];
    [self updateTwigView];
    [super layoutSubviews];
}

/// 刷新数据
- (void)reloadDataIfNeeded {
    if (self.needsReload) {
        [self reloadData];
    }
}

- (void)setNeedsReload {
    self.needsReload = YES;
    [self setNeedsLayout];
}

- (void)layoutChannelView {
    const CGSize boundsSize = self.bounds.size;
    const CGFloat contentOffset = self.contentOffset.x;
    /// 当前显示区域
    const CGRect visibleBounds = CGRectMake(contentOffset, 0, boundsSize.width, boundsSize.height);
    /// 当前正在显示的Item
    NSMutableDictionary *availableItems = self.cachedItems.mutableCopy;
    [self.cachedItems removeAllObjects];
    for (int i = 0; i < self.titleArray.count; i++) {
        NSNumber *index = @(i);
        CGRect itemRect = [self rectForItemAtRow:i];
        if (CGRectIntersectsRect(itemRect, visibleBounds)) {///在可显示区域内就进行布局
            ZCHChannelButton *item;
            if ([availableItems objectForKey:index]) {///首先"复用"当前存在的
                item = [availableItems objectForKey:index];
            } else if (self.reusableItems.count != 0) {///目前只有一种.暂且不区分ID.当前不存在去缓存池取
                for (ZCHChannelButton *button in self.reusableItems) {
                    [button.reuseIdentifier isEqualToString:@"reuse"];
                    item = button;
                    [self.reusableItems removeObject:item];
                    break;
                }
                if (!item) {
                    item = [[ZCHChannelButton alloc] initWithReuseIdentifier:@"reuse"];
                    [item addTarget:self action:@selector(btnClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
                }
            } else {///没缓存池就新创建
                item = [[ZCHChannelButton alloc] initWithReuseIdentifier:@"reuse"];
                [item addTarget:self action:@selector(btnClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
            if (item) {
                item.tag = i;
                [item setButtonWithTitle:self.titleArray[i] normalFont:self.normalFont selectedFont:self.selectedFont normalColor:self.normalColor selectedColor:self.selectedColor];
                [_cachedItems setObject:item forKey:index];
                [availableItems removeObjectForKey:index];
                item.selected = self.selectedRow == i?YES:NO;
                item.frame = itemRect;
                [self addSubview:item];
            }
            [self setContentSize];
        }
    }
    /// 出屏幕的加入缓存池或者移除.
    for (ZCHChannelButton *item in [availableItems allValues]) {
        if (item.reuseIdentifier && self.reusableItems.count < 10) {
            [self.reusableItems addObject:item];
        } else {
            [item removeFromSuperview];
        }
    }
    ///正在显示的Item
    NSArray *allCachedItems = [self.cachedItems allValues];
    for (ZCHChannelButton *item in self.reusableItems) {
        if (!CGRectIntersectsRect(item.frame,visibleBounds) && ![allCachedItems containsObject:item]) {
            [item removeFromSuperview];
        }
    }
}

- (ZCHChannelButton *)itemForRow:(NSInteger)row {
    return [_cachedItems objectForKey:@(row)];
}

/// 给Item进行布局
- (CGRect)rectForItemAtRow:(NSInteger)row {
    if (self.itemWidth == nil || self.itemX == nil) {
        return CGRectZero;
    }
    /// 计算Item的Rect
    // 上一个Row的Rect
    CGFloat lastWidth;
    CGFloat lastX;
    if (row == 0) {
        lastWidth = 0.0;
        lastX = 0.0;
    } else {
        lastWidth = self.itemWidth[row - 1];
        lastX = self.itemX[row - 1];
    }
    // 2.计算当前的Rect
    CGRect currentRect = [self.titleArray[row] boundingRectWithSize:CGSizeMake(MAXFLOAT, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.normalFont.pointSize>self.selectedFont.pointSize?self.normalFont:self.selectedFont} context:nil];
    CGFloat header = row==0?self.intervalHeader:0.0;
    CGFloat interval = row==0?0:self.intervalInLine;
    CGRect itemRect = CGRectMake(header + interval + lastX + lastWidth , 0, currentRect.size.width, self.bounds.size.height);
    self.itemWidth[row] = itemRect.size.width;
    self.itemX[row] = itemRect.origin.x;
    return itemRect;
}

- (void)setContentSize {
    if (self.itemX == nil || self.itemWidth == nil) {
        self.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    } else {
        self.contentSize = CGSizeMake(self.itemX[self.titleArray.count - 1] + self.itemWidth[self.titleArray.count - 1] + self.intervalFooter, self.bounds.size.height);
    }
}

- (NSInteger)rowAtPoint:(CGPoint)point {
    NSArray *paths = [self rowsInRect:CGRectMake(point.x,point.y,1,1)];
    return ([paths count] > 0)? [[paths objectAtIndex:0] integerValue] : -1;
}

- (NSArray <NSNumber *> *)rowsInRect:(CGRect)rect {
    NSMutableArray *arrayM = [NSMutableArray array];
    for (ZCHChannelButton *button in self.cachedItems.allValues) {
        if (CGRectContainsRect(button.frame, rect)) {
            NSArray *numbersArray = [self.cachedItems allKeysForObject:button];
            if (numbersArray.count) {
                [arrayM addObject:numbersArray.firstObject];
            }
        }
    }
    return arrayM.count!=0?arrayM.copy:nil;
}

- (void)setupConfig {
    self.cachedItems = [[NSMutableDictionary alloc] init];
    self.reusableItems = [[NSMutableSet alloc] init];
    self.selectedRow = -1;
    [self setNeedsReload];
}

- (void)setupUI {
    self.showsHorizontalScrollIndicator = 0;
    self.bounces = NO;
    [self addSubview:self.twigView];
}

- (void)btnClickWithBtn:(ZCHChannelButton *)sender {
    [self selectedBtnWithTag:sender.tag];
    if (self.didSelectItemBlock) {
        self.didSelectItemBlock(self ,sender.tag);
    }
    if (self.scrollChannelViewDelegate && [self.scrollChannelViewDelegate respondsToSelector:@selector(scrollChannelView:didSelectItemAtIndex:)]) {
        [self.scrollChannelViewDelegate scrollChannelView:self didSelectItemAtIndex:sender.tag];
    }
}

/**
 根据tag滚动twigView,以及选中Btn

 @param tag 按钮编号
 */
- (void)selectedBtnWithTag:(NSInteger)tag {
    self.selectedRow = tag;
    // 取出btn
    CGRect rect = [self rectForItemAtRow:tag];
    [self scrollRectToVisible:CGRectMake(rect.origin.x - self.bounds.size.width / 2 + rect.size.width / 2, 0, self.bounds.size.width, self.bounds.size.height) animated:YES];
    [self layoutChannelView];
}

// MARK: TwigView动画方法
- (void)updateTwigView {
    if (self.selectedRow >= 0) {
        if (self.twigViewHidden) {
            self.twigView.hidden = YES;
            self.twigView.frame = CGRectZero;
        } else {
            self.twigView.hidden = NO;
            CGFloat twigViewWidth;
            CGRect selectBtnRect = [self rectForItemAtRow:self.selectedRow];
            if (!CGRectEqualToRect(selectBtnRect, CGRectZero)) {
                if (self.twigViewEqualToButtonWidth) {
                    twigViewWidth = selectBtnRect.size.width;
                } else {
                    twigViewWidth = self.twigViewWidth;
                }
                self.twigView.layer.cornerRadius = self.twigViewCornerRadius;
                self.twigView.layer.masksToBounds = YES;
                [UIView animateWithDuration:self.twigView.frame.origin.x==0.0?0:.25 animations:^{
                    self.twigView.frame = CGRectMake(0, 0, twigViewWidth, self.twigViewHeight);
                    self.twigView.center = CGPointMake(selectBtnRect.origin.x + selectBtnRect.size.width / 2, self.bounds.size.height - self.twigViewHeight / 2);
                }];
            }
        }
    } else {
        self.twigView.hidden = YES;
        self.twigView.frame = CGRectZero;
    }
}

@end
