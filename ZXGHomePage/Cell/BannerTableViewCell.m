//
//  BannerTableViewCell.m
//  ZhenXinGou
//
//  Created by Victor on 2017/11/7.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "BannerTableViewCell.h"
#import "SDCycleScrollView.h"

@interface BannerTableViewCell ()<SDCycleScrollViewDelegate>

@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;

@property (strong, nonatomic) NSMutableArray *imagesURLStrings;

@end

@implementation BannerTableViewCell

- (NSMutableArray *)imagesURLStrings {
    if (!_imagesURLStrings) {
        _imagesURLStrings = [NSMutableArray arrayWithCapacity:3];
    }
    return _imagesURLStrings;
}

- (void)setBanArray:(NSArray *)banArray {
    self.imagesURLStrings = nil;
    for (NSInteger i = 0; i < banArray.count; i ++) {
        if (banArray[i][@"goods_img"] == nil) {
            [self.imagesURLStrings addObject:@""];
        }else {
            [self.imagesURLStrings addObject:banArray[i][@"goods_img"]];
        }
    }
    self.cycleScrollView.imageURLStringsGroup = _imagesURLStrings;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect frame = CGRectMake(0, 0, VIEW_WIDTH, 180);
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:[UIImage imageNamed:@"xiaoyi200"]];
        self.cycleScrollView = cycleScrollView;
        cycleScrollView.autoScrollTimeInterval = 4;
        cycleScrollView.bannerImageViewContentMode = 2;

        [self addSubview:cycleScrollView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
