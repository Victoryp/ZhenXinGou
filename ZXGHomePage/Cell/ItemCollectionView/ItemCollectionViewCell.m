//
//  ItemCollectionViewCell.m
//  ZhenXinGou
//
//  Created by Victor on 2017/11/7.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "ItemCollectionViewCell.h"

@implementation ItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
}

@end
