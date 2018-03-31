//
//  ViewController.m
//  ZCHScrollChannelView
//
//  Created by 张晨晖 on 2018/1/20.
//  Copyright © 2018年 张晨晖. All rights reserved.
//

#import "ViewController.h"
#import "ZCHChannelScrollView.h"
#import "CollectionViewFlowLayout.h"
#import <Masonry.h>

@interface ViewController () <UICollectionViewDataSource ,UICollectionViewDelegate>

@property (nonatomic ,strong) ZCHChannelScrollView *channelView;

@property (nonatomic ,strong) UICollectionView *collectionView;

@property (nonatomic ,strong) NSArray *titleArray;

@end

@implementation ViewController

static NSString *cellID = @"cellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _titleArray = @[@"全部" ,@"内科" ,@"外科" ,@"妇科" ,@"儿科" ,@"口腔"];
    _channelView = [[ZCHChannelScrollView alloc] init];
    _channelView.intervalInLine = 40;
    _channelView.intervalHeader = 20;
    _channelView.intervalFooter = 20;
    _channelView.backgroundColor = [UIColor redColor];
    //这个要最后使用
    _channelView.titleArray = self.titleArray;
    [self.view addSubview:_channelView];
    [_channelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(48);
    }];

    // MARK: 联动(点击channel联动collectionView)
    __weak typeof(self) weakSelf = self;
    _channelView.chancelSelectedBlock = ^(NSInteger tag) {
        [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
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

}

//上下联动之滑动下面.滚动上面
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _collectionView) {
        // 停止类型1、停止类型2
        BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging &&    !scrollView.decelerating;
        if (scrollToScrollStop) {
            [self scrollViewDidEndScrollWithContentOffset:scrollView.contentOffset];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == _collectionView) {
        if (!decelerate) {
            // 停止类型3
            BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
            if (dragToDragStop) {
                [self scrollViewDidEndScrollWithContentOffset:scrollView.contentOffset];
            }
        }
    }
}

- (void)scrollViewDidEndScrollWithContentOffset:(CGPoint)contentOffset {
    //滚动的X距离
    CGFloat x = contentOffset.x;
    NSInteger interger = x / _collectionView.bounds.size.width;
    _channelView.btnTag = interger;
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
    return _titleArray.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
