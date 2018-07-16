##效果

![](https://github.com/MeteoriteMan/Assets/blob/master/gif/ZCHScrollChannelView-iPhone%20X.gif?raw=true)

##使用

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

##安装

使用 [CocoaPods](http://www.cocoapods.com/) 集成.
首先在podfile中
>`pod 'ZCHScrollChannelView'`

安装一下pod

>`#import <ZCHScrollChannelView/ZCHScrollChannelView.h>`
