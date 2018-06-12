//
//  ZXGLeftViewController.m
//  ZhenXinGou
//
//  Created by Victor on 2017/11/24.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "ZXGLeftViewController.h"
#import "ZXGLoginViewController.h"
#import "ZXGUploadGoodsViewController.h"

@interface ZXGLeftViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *myIcon;
@property (weak, nonatomic) IBOutlet UILabel *myName;

@end

@implementation ZXGLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myIcon.layer.cornerRadius = 50;
    self.myIcon.clipsToBounds = YES;
}


//// 商品上传
//- (IBAction)uploadGoods:(UIButton *)sender {
//    ZXGUploadGoodsViewController *uploadVC = [[ZXGUploadGoodsViewController alloc] init];
//    [self.navigationController pushViewController:uploadVC animated:YES];
//}

// 退出登录
- (IBAction)logoutBtnAction:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"phoneNum"];
    [userDefaults synchronize];
    
    ZXGLoginViewController *VC = [[ZXGLoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
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
