//
//  ItemTableViewCell.m
//  ZhenXinGou
//
//  Created by Victor on 2017/11/7.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "ItemTableViewCell.h"

#import "ItemCollectionView.h"

@interface ItemTableViewCell ()

@property (strong, nonatomic) ItemCollectionView *itemCollectionView;
@property (strong, nonatomic) NSArray *recevieArray;
@property (assign, nonatomic) NSInteger receiveGoodsAccount;
@end

@implementation ItemTableViewCell

- (void)setDataArray:(NSArray *)dataArray {
    self.recevieArray = dataArray;
    self.itemCollectionView.receiveArray = self.recevieArray;
}

- (void)setGoodsAccount:(NSInteger)goodsAccount {
    self.receiveGoodsAccount = goodsAccount;
    _itemCollectionView.frame = CGRectMake(0, 0, VIEW_WIDTH, ((VIEW_WIDTH-45)/2 + 85)*self.receiveGoodsAccount);
}

- (ItemCollectionView *)itemCollectionView {
    if (!_itemCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        _itemCollectionView = [[ItemCollectionView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, ((VIEW_WIDTH-45)/2 + 85)*self.receiveGoodsAccount) collectionViewLayout:flowLayout];
    }
    return _itemCollectionView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.itemCollectionView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
