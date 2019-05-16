//
//  ViewController.m
//  ZCHScrollChannelView
//
//  Created by 张晨晖 on 2018/1/20.
//  Copyright © 2018年 张晨晖. All rights reserved.
//

#import "ViewController.h"
#import "ZCHScrollChannelView.h"
#import "CollectionViewFlowLayout.h"
#import <Masonry.h>

@interface ViewController () <UICollectionViewDataSource ,UICollectionViewDelegate>

@property (nonatomic ,strong) ZCHScrollChannelView *channelView;

@property (nonatomic ,strong) UICollectionView *collectionView;

@property (nonatomic ,strong) NSArray *titleArray;

@end

@implementation ViewController

static NSString *cellID = @"cellID";

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Demo";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [ZCHScrollChannelView appearance].normalColor = [UIColor redColor];
    [ZCHScrollChannelView appearance].selectedColor = [UIColor greenColor];
    [ZCHScrollChannelView appearance].intervalHeader = 12;
    [ZCHScrollChannelView appearance].intervalFooter = 12;
    [ZCHScrollChannelView appearance].intervalInLine  = 8;
    [ZCHScrollChannelView appearance].twigViewHeight = 6;
    [ZCHScrollChannelView appearance].twigViewWidth = 32;
    [ZCHScrollChannelView appearance].twigViewBottom = 2;
    [ZCHScrollChannelView appearance].normalFont = [UIFont systemFontOfSize:12];
    [ZCHScrollChannelView appearance].selectedFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [ZCHScrollChannelView appearance].twigViewCornerRadius = 3;
    [ZCHScrollChannelView appearance].backgroundColor = [UIColor blueColor];
    [ZCHScrollChannelView appearance].twigViewColor = [UIColor orangeColor];
    [ZCHScrollChannelView appearance].defaultSelectIndex = 0;

    self.titleArray = @[@"StartCraft", @"StartCraft II", @"World of Warcraft", @"Over Watch", @"Hero Of Storm", @"Warcraft III", @"Age of Empires Ⅲ", @"Red Alert 2", @"Call Of Duty"];

    /// MARK: Test
//    NSMutableArray *arrayM = [NSMutableArray array];
//    for (int i = 0; i < 100000; i++) {
//        [arrayM addObject:[NSString stringWithFormat:@"%d",i]];
//    }
//    _titleArray = arrayM.copy;


    _channelView = [[ZCHScrollChannelView alloc] init];
//    _channelView.intervalInLine = 8;
//    _channelView.intervalHeader = 12;
//    _channelView.intervalFooter = 12;
//    _channelView.twigViewHeight = 4;
//    _channelView.twigViewWidth = 16;
//    _channelView.twigViewEqualToButtonWidth = YES;
//    _channelView.normalFont = [UIFont systemFontOfSize:12];
//    _channelView.selectedFont = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
//    _channelView.twigViewHidden = YES;
//    _channelView.twigViewCornerRadius = 2;
//    _channelView.backgroundColor = [UIColor whiteColor];
//    _channelView.twigViewColor = [UIColor greenColor];
    _channelView.titleArray = self.titleArray;
//    _channelView.twigViewBottom = 4;
    [self.view addSubview:_channelView];
    [_channelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide);
        make.left.right.offset(0);
        make.height.offset(48);
    }];
//    self.channelView.defaultSelectIndex = 0;
//    [self.channelView reloadData];
//    self.channelView.selectIndex = 0;

//#pragma mark 测试
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 5), dispatch_get_main_queue(), ^{
//        self.channelView.btnTag = 7;
//    });

    // MARK: 联动(点击channel联动collectionView)
    __weak typeof(self) weakSelf = self;
    _channelView.didSelectItemBlock = ^(ZCHScrollChannelView *scrollChannelView, NSInteger index) {
        [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    };
    
    CollectionViewFlowLayout *flowLayout = [[CollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.bounces = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(self.channelView.mas_bottom);
    }];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];



    UIButton *buttonChangeChannel = [UIButton buttonWithType:UIButtonTypeContactAdd];
    buttonChangeChannel.backgroundColor = [UIColor redColor];
    [self.view addSubview:buttonChangeChannel];
    [buttonChangeChannel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.view);
    }];
    [buttonChangeChannel addTarget:self action:@selector(buttonChangeChannelClick) forControlEvents:UIControlEventTouchUpInside];

//    [self.collectionView setNeedsLayout];
//    [self.collectionView layoutIfNeeded];
//    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.titleArray.count * .5 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(50 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"%@" ,NSStringFromCGPoint(self.collectionView.contentOffset));
//    });

}

/////方法一
////上下联动之滑动下面.滚动上面
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    if (scrollView == _collectionView) {
//        // 停止类型1、停止类型2
//        BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging &&    !scrollView.decelerating;
//        if (scrollToScrollStop) {
//            [self scrollViewDidEndScrollWithContentOffset:scrollView.contentOffset];
//        }
//    }
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (scrollView == _collectionView) {
//        if (!decelerate) {
//            // 停止类型3
//            BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
//            if (dragToDragStop) {
//                [self scrollViewDidEndScrollWithContentOffset:scrollView.contentOffset];
//            }
//        }
//    }
//}
//
//- (void)scrollViewDidEndScrollWithContentOffset:(CGPoint)contentOffset {
//    //滚动的X距离
//    CGFloat x = contentOffset.x;
//    NSInteger interger = x / _collectionView.bounds.size.width;
//    _channelView.btnTag = interger;
//}

//方法二
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        if (scrollView.isDragging || scrollView.isTracking || scrollView.isDecelerating) {//手动滚动
            // 计算Page
//            self.channelView.selectIndex = (scrollView.contentOffset.x / scrollView.bounds.size.width);
            [self.channelView setSelectItemAtIndex:(scrollView.contentOffset.x / scrollView.bounds.size.width) animated:YES];
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArray.count;
}

// MARK: 模拟网络延迟加载
- (void)buttonChangeChannelClick {

    [self.channelView reloadData];

//    ViewController *vc = [[ViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];

//    if (arc4random_uniform(2)) {
//        NSInteger channelNumber = arc4random_uniform(10) + 5;
//        NSMutableArray *arrayM = [NSMutableArray array];
//        for (NSInteger i = 0; i < channelNumber; i++) {
//            NSMutableString *stringM = [NSMutableString string];
//            NSInteger channelStrLength = arc4random_uniform(10) + 5;
//            for (NSInteger y = 0; y < channelStrLength; y++) {
//                [stringM appendString:[NSString stringWithFormat:@"%ld",i]];
//            }
//            [arrayM addObject:stringM.copy];
//        }
//        self.titleArray = arrayM.copy;
//        self.channelView.titleArray = self.titleArray;
//        [self.channelView reloadData];
//        [self.collectionView reloadData];
//        self.channelView.selectIndex = 0;
//    } else {
//        self.titleArray = nil;
//        self.channelView.titleArray = nil;
//        [self.channelView reloadData];
//        [self.collectionView reloadData];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

@end
