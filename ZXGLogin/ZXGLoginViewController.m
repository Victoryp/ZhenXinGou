//
//  ZXGLoginViewController.m
//  ZhenXinGou
//
//  Created by Victor on 2017/11/21.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "ZXGLoginViewController.h"
#import "ZXGPhoneLoginViewController.h"

@interface ZXGLoginViewController ()

@end

@implementation ZXGLoginViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

// 登录
- (IBAction)loginBtnAction:(id)sender {
    ZXGPhoneLoginViewController *phoneVC = [[ZXGPhoneLoginViewController alloc] init];
    [self.navigationController pushViewController:phoneVC animated:YES];
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
