//
//  ZXGGoodsCollectionViewCell.h
//  ZhenXinGou
//
//  Created by Victor on 2017/11/17.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface ZXGGoodsCollectionViewCell : RCMessageBaseCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;

@end
