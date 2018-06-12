//
//  ItemCollectionView.m
//  ZhenXinGou
//
//  Created by Victor on 2017/11/7.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "ItemCollectionView.h"

#import "ItemCollectionViewCell.h"

static NSString *itemCollectionID = @"itemCollectionID";
@interface ItemCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation ItemCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([ItemCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:itemCollectionID];
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:itemCollectionID];
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.scrollEnabled = NO;
        self.backgroundColor = Color(246, 247, 250);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCollectionView) name:@"refreshItemCollectionView" object:nil];

    }
    return self;
}

- (void)refreshCollectionView {
    [self reloadData];
}

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return self.pictruesArray.count;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    NSArray *num = self.pictruesArray[section][@"list"];
//    return num.count;
    return self.receiveArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemCollectionViewCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:itemCollectionID forIndexPath:indexPath];
    [itemCell.goods_img sd_setImageWithURL:[NSURL URLWithString:self.receiveArray[indexPath.row][@"goods_img"]] placeholderImage:[UIImage imageNamed:@"xiaoyi200"] options:SDWebImageRefreshCached];
    itemCell.goods_name.text = self.receiveArray[indexPath.row][@"goods_name"];
    itemCell.goods_price.text = [NSString stringWithFormat:@"¥ %@.00",self.receiveArray[indexPath.row][@"goods_price"]];
    return itemCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((VIEW_WIDTH-45)/2,(VIEW_WIDTH-45)/2 + 70);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = @{
                          @"itemID":[NSString stringWithFormat:@"%ld",(long)indexPath.row]
                          };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedItem" object:dic];
//    if(_ClickImageBlock != nil) _ClickImageBlock(indexPath.section, indexPath.row);
}

@end
