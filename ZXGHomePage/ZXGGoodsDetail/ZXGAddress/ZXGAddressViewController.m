//
//  ZXGAddressViewController.m
//  ZhenXinGou
//
//  Created by Victor on 2017/11/24.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "ZXGAddressViewController.h"
#import "ZXGPayViewController.h"

@interface ZXGAddressViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;

@property (weak, nonatomic) IBOutlet UITextView *addressTextView;

@end

@implementation ZXGAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:self.goodsImageUrl] placeholderImage:[UIImage imageNamed:@"xiaoyi200"] options:SDWebImageRefreshCached];
    self.goodsName.text = self.goodsNameString;
    self.goodsPrice.text = [NSString stringWithFormat:@"¥ %@.00",self.goodsPriceString];
    
    self.addressTextView.delegate = self;
}

- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)gotoPay:(UIButton *)sender {
    if ([self.addressTextView.text length] == 0 || [self.addressTextView.text isEqualToString:@"填写：姓名-收货地址-手机号"]) {
        [SVProgressHUD showErrorWithStatus:@"请填写收货信息"];
    }else {
        ZXGPayViewController *payVC = [[ZXGPayViewController alloc] init];
        payVC.goodsPrice = self.goodsPriceString;
        [self.navigationController pushViewController:payVC animated:YES];
    }
}


- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"填写：姓名-收货地址-手机号"]) {
        self.addressTextView.text = @"";
        self.addressTextView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.addressTextView.text length] == 0) {
        self.addressTextView.text = @"填写：姓名-收货地址-手机号";
        self.addressTextView.textColor = [UIColor lightGrayColor];
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
