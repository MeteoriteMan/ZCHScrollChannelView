//
//  ViewController.m
//  ZCHScrollChannelView
//
//  Created by 张晨晖 on 2018/1/20.
//  Copyright © 2018年 张晨晖. All rights reserved.
//

#import "ViewController.h"
#import "ZCHChannelScrollView.h"

@interface ViewController ()

@property (nonatomic ,strong) ZCHChannelScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _scrollView = [[ZCHChannelScrollView alloc] init];
    _scrollView.intervalInLine = 40;
    _scrollView.intervalHeader = 20;
    _scrollView.intervalFooter = 20;
    _scrollView.titleArray = @[@"全部" ,@"内科" ,@"外科" ,@"妇科" ,@"儿科" ,@"口腔"];
    _scrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_scrollView];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    ///解决警告可以把第二个attribute换成NSLayoutAttributeHeight
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:50]];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
