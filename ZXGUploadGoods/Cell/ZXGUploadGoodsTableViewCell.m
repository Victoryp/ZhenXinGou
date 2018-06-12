//
//  ZXGUploadGoodsTableViewCell.m
//  ZhenXinGou
//
//  Created by Victor on 2017/12/4.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "ZXGUploadGoodsTableViewCell.h"

@implementation ZXGUploadGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.contentTextView.layer.borderWidth = 1.0;
    self.contentTextView.layer.cornerRadius = 6;
}

// 添加封面
- (IBAction)addGoodsImg:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(addGoodsImg:)]) {
        [self.delegate addGoodsImg:1];
    }
}

// 添加详情图片
- (IBAction)addGoodsContentImg:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(addGoodsImg:)]) {
        [self.delegate addGoodsImg:2];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
