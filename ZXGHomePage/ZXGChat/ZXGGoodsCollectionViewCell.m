//
//  ZXGGoodsCollectionViewCell.m
//  ZhenXinGou
//
//  Created by Victor on 2017/11/17.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "ZXGGoodsCollectionViewCell.h"
#import "ZXGGoodsMessage.h"

@implementation ZXGGoodsCollectionViewCell

+ (CGSize)sizeForMessageModel:(RCMessageModel *)model
      withCollectionViewWidth:(CGFloat)collectionViewWidth
         referenceExtraHeight:(CGFloat)extraHeight {
    return CGSizeMake(VIEW_WIDTH - 32, 210);
    
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    [self customMessageUI];
}

- (void)customMessageUI {
    ZXGGoodsMessage *goodsMessage = (ZXGGoodsMessage *)self.model.content;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, 146)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 4;
    [self.baseContentView addSubview:backView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(13, 13, 120, 120);
    [imageView sd_setImageWithURL:[NSURL URLWithString:goodsMessage.imgPath] placeholderImage:[UIImage imageNamed:@"healthDefaultIcon"] options:SDWebImageRefreshCached];
    [backView addSubview:imageView];
    
    UILabel *goodsName = [[UILabel alloc] initWithFrame:CGRectMake(153, 20, self.frame.size.width - 13 - 40 -120, 60)];
    goodsName.text = goodsMessage.goodsName;
    [backView addSubview:goodsName];
    
    UILabel *goodsPrice = [[UILabel alloc] initWithFrame:CGRectMake(153, 90, self.frame.size.width - 13 - 40 -120, 40)];
    goodsPrice.textColor = Color(255, 117, 0);
    goodsPrice.text = [NSString stringWithFormat:@"¥ %@",goodsMessage.goodsPrice];
    [backView addSubview:goodsPrice];
}

@end
