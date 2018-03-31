//
//  ZCHChannelScrollView.m
//  ZCHScrollChannelView
//
//  Created by 张晨晖 on 2018/1/20.
//  Copyright © 2018年 张晨晖. All rights reserved.
//

#import "ZCHChannelScrollView.h"

@interface ZCHChannelScrollView ()

///按钮数组
@property (nonatomic ,strong) NSArray <UIButton *> *buttonArray;

///滚动条
@property (nonatomic ,strong) UIView *twigView;

///上一个选中Button
@property (nonatomic ,strong) UIButton *lastSelectedButton;

@end

@implementation ZCHChannelScrollView

- (void)setBtnTag:(NSInteger)btnTag {
    _btnTag = btnTag;
    [self selectedBtnWithTag:btnTag];
}

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

- (void)setTitleArray:(NSArray<NSString *> *)titleArray {
    _titleArray = titleArray;
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i  = 0; i < titleArray.count; i++) {
        UIButton *btn = [UIButton zch_ButtonWithTitle:titleArray[i] andFont:[UIFont systemFontOfSize:18] andNormalColor:self.normalColor andSelectedColor:self.selectedColor];
        _twigView.backgroundColor = self.selectedColor;
        btn.tag = i;
        [btn sizeToFit];
        [arrayM addObject:btn];
    }
    self.buttonArray = arrayM.copy;
}

- (void)setButtonArray:(NSArray *)buttonArray {
    _buttonArray = buttonArray;
    CGFloat lastX = _intervalHeader;
    for (int i = 0; i < buttonArray.count; i++) {
        UIButton *btn = ((UIButton *)buttonArray[i]);
        [btn addTarget:self action:@selector(btnClickWithBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {//初始化第一个btn的选中状态
            btn.selected = YES;
            _lastSelectedButton = btn;
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
        lastX = X + W + _intervalInLine;
    }
    //这个时候应该是没有height的.暂不做处理
    self.contentSize = CGSizeMake(lastX - _intervalInLine + _intervalFooter, self.bounds.size.height);
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
        UIButton *btn = ((UIButton *)_buttonArray[i]);
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
            _twigView.frame = CGRectMake(_lastSelectedButton.frame.origin.x, _lastSelectedButton.bounds.size.height - 2, _lastSelectedButton.bounds.size.width, 2);
        }];
    }
}

- (void)setupUI {
    self.showsHorizontalScrollIndicator = 0;
    self.bounces = NO;
    _twigView = [[UIView alloc] init];
    [self addSubview:_twigView];
}

- (void)btnClickWithBtn:(UIButton *)btn {
    [self selectedBtnWithTag:btn.tag];
    if (self.chancelSelectedBlock) {
        self.chancelSelectedBlock(btn.tag);
    }
}

/**
 根据tag滚动twigView,以及选中Btn

 @param tag 按钮编号
 */
- (void)selectedBtnWithTag:(NSInteger)tag {
    //取出btn
    UIButton *btn = _buttonArray[tag];
    if (btn != _lastSelectedButton) {
        _lastSelectedButton.selected = !_lastSelectedButton.isSelected;
        btn.selected = !btn.isSelected;
        _lastSelectedButton = btn;
        CGPoint point = CGPointMake(btn.center.x, 0);
        if (point.x - self.bounds.size.width / 2 + btn.bounds.size.width / 2 >= _intervalHeader && point.x + self.bounds.size.width / 2 <= self.contentSize.width) {
            [self setContentOffset:CGPointMake(point.x - self.bounds.size.width / 2, point.y) animated:YES];
        } else if (point.x - self.bounds.size.width / 2 + btn.bounds.size.width / 2 <= 0) {
            [self setContentOffset:CGPointMake(0, 0) animated:YES];
        } else if (point.x + self.bounds.size.width / 2 > self.contentSize.width) {
            [self setContentOffset:CGPointMake(self.contentSize.width - self.bounds.size.width, 0) animated:YES];
        }
        [UIView animateWithDuration:.25 animations:^{
            _twigView.frame = CGRectMake(_lastSelectedButton.frame.origin.x, _lastSelectedButton.bounds.size.height - 2, _lastSelectedButton.bounds.size.width, 2);
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

@implementation UIButton (zch_Button)

+ (instancetype)zch_ButtonWithTitle:(NSString *)str andFont:(UIFont *)font andNormalColor:(UIColor *)normalColor andSelectedColor:(UIColor *)slectedColor {
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:str forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn setTitleColor:normalColor forState:UIControlStateNormal];
    [btn setTitleColor:slectedColor forState:UIControlStateSelected];
    return btn;
}
@end
