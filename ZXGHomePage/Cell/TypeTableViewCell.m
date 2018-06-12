//
//  TypeTableViewCell.m
//  ZhenXinGou
//
//  Created by Victor on 2017/11/7.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "TypeTableViewCell.h"

@implementation TypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

// 化妆品按钮
- (IBAction)cosmeticsBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cosBtnAction)]) {
        [self.delegate cosBtnAction];
    }
}

// 零食按钮
- (IBAction)snacksBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(snacksBtnAction)]) {
        [self.delegate snacksBtnAction];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
