//
//  ZCHChannelScrollView.m
//  ZCHScrollChannelView
//
//  Created by 张晨晖 on 2018/1/20.
//  Copyright © 2018年 张晨晖. All rights reserved.
//

#import "ZCHChannelScrollView.h"
#import "ZCHChannelButton.h"

@interface ZCHChannelScrollView ()

///按钮数组
@property (nonatomic ,strong) NSArray <ZCHChannelButton *> *buttonArray;

///滚动条
@property (nonatomic ,strong) UIView *twigView;

///上一个选中Button
@property (nonatomic ,strong) ZCHChannelButton *lastSelectedButton;

@end

@implementation ZCHChannelScrollView {
    UIColor *_twigViewColor;
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
    self.twigView.backgroundColor = twigViewColor;
}

//字体
- (UIFont *)font {
    if (_font == nil) {
        _font = [UIFont systemFontOfSize:self.fontSize];
    }
    return _font;
}

//字体大小
- (CGFloat)fontSize {
    if (_fontSize == 0) {//没有设置字体
        _fontSize = 15;
    }
    return _fontSize;
}

- (UIView *)twigView {
    if (_twigView == nil) {
        _twigView = [UIView new];
        _twigView.backgroundColor = self.twigViewColor;
    }
    return _twigView;
}

- (void)setBtnTag:(NSInteger)btnTag {
    _btnTag = btnTag;
    if (btnTag > self.buttonArray.count - 1) {
        return;
    }
    [self selectedBtnWithTag:btnTag];
}

- (void)reloadData {
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[ZCHChannelButton class]]) {
            [subView removeFromSuperview];
        }
    }
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i  = 0; i < self.titleArray.count; i++) {
        ZCHChannelButton *btn = [ZCHChannelButton zch_ButtonWithTitle:self.titleArray[i] normalFont:self.font normalColor:self.normalColor selectedColor:self.selectedColor];
        btn.tag = i;
        [btn sizeToFit];
        [arrayM addObject:btn];
    }
    self.buttonArray = arrayM.copy;
}

// 计算SubView的frame
- (void)setButtonArray:(NSArray *)buttonArray {
    _buttonArray = buttonArray;
    CGFloat lastX = _intervalHeader;
    for (int i = 0; i < buttonArray.count; i++) {
        ZCHChannelButton *btn = ((ZCHChannelButton *)buttonArray[i]);
        [btn addTarget:self action:@selector(btnClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {//初始化第一个btn的选中状态
            btn.selected = YES;
            self.lastSelectedButton = btn;
            [self updateTwigView];
        }
        [self addSubview:btn];
        //x
        CGFloat X = lastX;
        //y
        CGFloat Y = 0.0;
        //w
        CGFloat W = btn.frame.size.width;
        //h高暂不做处理
        CGFloat H = btn.frame.size.height;
        btn.frame = CGRectMake(X, Y, W, H);
        lastX = X + W + self.intervalInLine;
    }
    //这个时候应该是没有height的.暂不做处理
    self.contentSize = CGSizeMake(lastX - self.intervalInLine + self.intervalFooter, self.bounds.size.height);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (int i = 0; i < _buttonArray.count; i++) {
        ZCHChannelButton *btn = ((ZCHChannelButton *)_buttonArray[i]);
        //x
        CGFloat X = btn.frame.origin.x;
        //y
        CGFloat Y = btn.frame.origin.y;
        //w
        CGFloat W = btn.frame.size.width;
        //h高暂不做处理
        CGFloat H = self.bounds.size.height;
        btn.frame = CGRectMake(X, Y, W, H);
        [UIView animateWithDuration:.25 animations:^{
            [self updateTwigView];
        }];
    }
}

- (void)setupUI {
    self.showsHorizontalScrollIndicator = 0;
    self.bounces = NO;
    [self addSubview:self.twigView];
}

- (void)btnClickWithBtn:(ZCHChannelButton *)btn {
    [self selectedBtnWithTag:btn.tag];
    if (self.chancelSelectedBlock) {
        self.chancelSelectedBlock(btn.tag);
    }
}

- (void)updateTwigView {
    CGFloat twigViewWidth;
    if (self.twigViewEqualToButtonWidth) {
        twigViewWidth = self.lastSelectedButton.bounds.size.width;
    } else {
        twigViewWidth = self.twigViewWidth;
    }
    self.twigView.frame = CGRectMake(0, 0, twigViewWidth, self.twigViewHeight);
    self.twigView.center = CGPointMake(self.lastSelectedButton.center.x, self.lastSelectedButton.bounds.size.height - self.twigViewHeight / 2);
    self.twigView.layer.cornerRadius = self.twigViewCornerRadius;
    self.twigView.layer.masksToBounds = YES;
    [self.twigView layoutIfNeeded];
}

/**
 根据tag滚动twigView,以及选中Btn

 @param tag 按钮编号
 */
- (void)selectedBtnWithTag:(NSInteger)tag {
    //取出btn
    ZCHChannelButton *btn = _buttonArray[tag];
    if (btn != _lastSelectedButton) {
        _lastSelectedButton.selected = !_lastSelectedButton.isSelected;
        btn.selected = !btn.isSelected;
        _lastSelectedButton = btn;
        CGPoint point = CGPointMake(btn.center.x, 0);
        if (point.x - btn.bounds.size.width / 2 - self.bounds.size.width / 2 + _intervalHeader <= 0) {
            [self setContentOffset:CGPointMake(0, 0) animated:YES];
        } else if (point.x + btn.bounds.size.width / 2 + self.bounds.size.width / 2 + _intervalFooter >= self.contentSize.width) {
            if (self.contentSize.width <= self.bounds.size.width) {
                [self setContentOffset:CGPointMake(0, 0) animated:YES];
            } else {
                [self setContentOffset:CGPointMake(self.contentSize.width - self.bounds.size.width, 0) animated:YES];
            }
        } else {
            [self setContentOffset:CGPointMake(point.x - self.bounds.size.width / 2 , 0) animated:YES];
        }
        [UIView animateWithDuration:.25 animations:^{
            [self updateTwigView];
        }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
