//
//  ZXGGoodsDetailViewController.m
//  ZhenXinGou
//
//  Created by Victor on 2017/11/14.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "ZXGGoodsDetailViewController.h"
#import "ZXGAddressViewController.h"

#import "SDCycleScrollView.h"

@interface ZXGGoodsDetailViewController ()<SDCycleScrollViewDelegate>

@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
@property (strong, nonatomic) NSMutableArray *imagesURLStrings;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation ZXGGoodsDetailViewController

- (NSMutableArray *)imagesURLStrings {
    if (!_imagesURLStrings) {
        _imagesURLStrings = [NSMutableArray arrayWithCapacity:3];
    }
    return _imagesURLStrings;
}

- (void)setBanArray:(NSArray *)banArray {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = CGRectMake(0, 64, VIEW_WIDTH, 250);
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:[UIImage imageNamed:@"xiaoyi200"]];
    self.cycleScrollView = cycleScrollView;
    cycleScrollView.autoScrollTimeInterval = 4;
    cycleScrollView.bannerImageViewContentMode = 2;
    [self.view addSubview:cycleScrollView];
    
    self.imagesURLStrings = nil;
    for (NSInteger i = 0; i < [self.dataDic[@"goods_imgs"] count]; i ++) {
        if (self.dataDic[@"goods_imgs"][i] == nil) {
            [self.imagesURLStrings addObject:@""];
        }else {
            [self.imagesURLStrings addObject:self.dataDic[@"goods_imgs"][i]];
        }
    }
    self.cycleScrollView.imageURLStringsGroup = _imagesURLStrings;

    NSString *contentStr = self.dataDic[@"goods_content"];
    [self setLabelSpace:self.contentLabel withValue:contentStr withFont:[UIFont systemFontOfSize:14]];
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@.00",self.dataDic[@"goods_price"]];

}

- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 立即购买
- (IBAction)buyNowBtnAction:(UIButton *)sender {
    ZXGAddressViewController *addressVC = [[ZXGAddressViewController alloc] init];
    addressVC.goodsImageUrl = self.dataDic[@"goods_img"];
    addressVC.goodsNameString = self.dataDic[@"goods_name"];
    addressVC.goodsPriceString = self.dataDic[@"goods_price"];
    [self.navigationController pushViewController:addressVC animated:YES];
}

-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 5; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.f
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
    label.attributedText = attributeStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
