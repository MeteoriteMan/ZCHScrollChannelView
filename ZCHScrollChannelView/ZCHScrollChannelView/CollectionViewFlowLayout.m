//
//  CollectionViewFlowLayout.m
//  ZCHScrollChannelView
//
//  Created by 张晨晖 on 2018/3/31.
//  Copyright © 2018年 张晨晖. All rights reserved.
//

#import "CollectionViewFlowLayout.h"

@implementation CollectionViewFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.itemSize = self.collectionView.bounds.size;
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
}

@end
