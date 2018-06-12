//
//  ZXGPhoneLoginViewController.m
//  ZhenXinGou
//
//  Created by Victor on 2017/11/22.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "ZXGPhoneLoginViewController.h"
#import "ZXGCheckNumViewController.h"

@interface ZXGPhoneLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end
NSInteger i;
@implementation ZXGPhoneLoginViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
    _textField.tintColor = Color(252, 77, 101);
    [_textField becomeFirstResponder];
    i = 0;
}

- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//18364280936
- (IBAction)confirmBtn:(UIButton *)sender {
    if ([self.textField.text length] == 13) { // 中间加了两个空格所以为13
        NSString *strUrl = [self.textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        AVShortMessageRequestOptions *options = [[AVShortMessageRequestOptions alloc] init];
        options.TTL = 5;                      // 验证码有效时间为 5 分钟
        options.applicationName = @"真心购";  // 应用名称
        options.operation = @"登录验证";        // 操作名称
        [AVSMS requestShortMessageForPhoneNumber:strUrl
                                         options:options
                                        callback:^(BOOL succeeded, NSError * _Nullable error) {
                                            if (succeeded) {
                                                /* 请求成功 */
                                            } else {
                                                /* 请求失败 */
                                            }
                                        }];
        // 为了快速切换，没等请求成功就进入了验证码页面
        ZXGCheckNumViewController *checkVC = [[ZXGCheckNumViewController alloc] init];
        checkVC.phoneNum = [NSString stringWithFormat:@"%@ ",strUrl];
        [self.navigationController pushViewController:checkVC animated:YES];
    }else {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
    }
}

- (IBAction)inputNum:(UITextField *)sender {
    if (sender == self.textField) {
        NSInteger a = 4;
        NSInteger b = 9;
        NSInteger c = 13;
        if (sender.text.length > i) {
            if (sender.text.length == a || sender.text.length == b ) {//输入
                NSMutableString * str = [[NSMutableString alloc ] initWithString:sender.text];
                [str insertString:@" " atIndex:(sender.text.length-1)];
                sender.text = str;
            }if (sender.text.length >= c ) {//输入完成
                sender.text = [sender.text substringToIndex:c];
//                [sender resignFirstResponder];
                self.confirmBtn.backgroundColor = Color(252, 77, 101);
            }
            i = sender.text.length;
            
        }else if (sender.text.length < i){//删除
            if (sender.text.length == a || sender.text.length == b) {
                sender.text = [NSString stringWithFormat:@"%@",sender.text];
                sender.text = [sender.text substringToIndex:(sender.text.length-1)];
            }
            i = sender.text.length;
            self.confirmBtn.backgroundColor = Color(238, 238, 238);
        }
    }
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
