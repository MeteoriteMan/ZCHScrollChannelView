# ZCHScrollChannelView

## 效果

![](https://github.com/MeteoriteMan/Assets/blob/master/gif/ZCHScrollChannelView-iPhone%20X.gif?raw=true)

## 使用

```
    _titleArray = @[@"直播" ,@"强烈推荐" ,@"你懂的" ,@"呵呵哒哒呵呵哒哒" ,@"神马情况" ,@"233333"];
    _channelView = [[ZCHScrollChannelView alloc] init];
    [self.view addSubview:_channelView];
    [_channelView mas_makeConstraints:^(MASConstraintMaker *make) {
	make.top.equalTo(self.mas_topLayoutGuide);
        make.left.right.offset(0);
        make.height.offset(48);
    }];
    [self.channelView reloadData];	
```

## 安装

使用 [CocoaPods](http://www.cocoapods.com/) 集成.
首先在podfile中
>`pod 'ZCHScrollChannelView'`

安装一下pod

>`#import <ZCHScrollChannelView/ZCHScrollChannelView.h>`

## 更新记录

|版本|更新内容|
|:--|:--|
|0.0.1|支持TwigView.按钮正常/选中状态颜色设置.按钮字体设置等.|
|0.0.2|拓展TwigView的功能.可以手动隐藏|
|0.0.3|统一命名,修复TwigView显示错乱问题|
|0.0.4|新增设置按钮正常/选中状态字体的设置|
|0.0.5|修复0.0.4版本中宽度不跟随选中按钮宽度时不更新TwigView的BUG|