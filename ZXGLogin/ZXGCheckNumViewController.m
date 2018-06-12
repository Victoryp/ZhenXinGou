//
//  ZXGCheckNumViewController.m
//  ZhenXinGou
//
//  Created by Victor on 2017/11/22.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "ZXGCheckNumViewController.h"
#import "ZXGHomePageViewController.h"
#import "ZXGLeftViewController.h"

#import "RESideMenu.h"

@interface ZXGCheckNumViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation ZXGCheckNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.phoneNumLabel.text = self.phoneNum;
    self.textField.delegate = self;
    _textField.tintColor = Color(252, 77, 101);
    [_textField becomeFirstResponder];
}

- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmBtnAction:(UIButton *)sender {
    [AVOSCloud verifySmsCode:self.textField.text mobilePhoneNumber:self.phoneNum callback:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            //验证成功
            NSString *followURL = @"/user/login.php";
            NSString *askingURL = [NSString stringWithFormat:@"%@%@", localURL, followURL];
            NSDictionary *dic = @{
                                  @"phone":self.phoneNum,
                                  };
            [self.mgr POST:askingURL parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"----------------%@",responseObject);
                if ([[responseObject valueForKey:@"code"] isEqualToString:@"000"]) {
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:self.phoneNum forKey:@"phoneNum"];
                    [userDefaults synchronize];
                    
                    ZXGHomePageViewController *VC = [[ZXGHomePageViewController alloc] init];
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
                    
                    ZXGLeftViewController *leftVC = [[ZXGLeftViewController alloc] init];
                    //抽屉界面
                    RESideMenu *reSide = [[RESideMenu alloc] initWithContentViewController:nav leftMenuViewController:leftVC rightMenuViewController:nil];
                    reSide.backgroundImage = [UIImage imageNamed:@""];
                    reSide.contentViewScaleValue = 1;//缩放比例
                    reSide.contentViewInPortraitOffsetCenterX = VIEW_WIDTH/2-VIEW_WIDTH/3;//偏移中心点的距离
                    reSide.bouncesHorizontally = NO;
                    reSide.menuPreferredStatusBarStyle = 1;//UIStatusBarStyleLightContent，适用于暗色的背景
                    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:reSide];
                    [UIApplication sharedApplication].keyWindow.rootViewController = navVC;
                }else {
                    
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
            }];
        }else {
            [SVProgressHUD showErrorWithStatus:@"验证码错误"];
        }
    }];
}

- (IBAction)inputTextField:(UITextField *)sender {
    NSDictionary *attrsDictionary =@{
                                     NSFontAttributeName: self.textField.font,
                                     NSKernAttributeName:[NSNumber numberWithFloat:25.0f]//这里修改字符间距
                                     };
    self.textField.attributedText=[[NSAttributedString alloc]initWithString:self.textField.text attributes:attrsDictionary];
    if ([self.textField.text length] == 6) {
        self.textField.tintColor = [UIColor clearColor];
        self.confirmBtn.backgroundColor = Color(252, 77, 101);
    }else {
        self.textField.tintColor = Color(252, 77, 101);
        self.confirmBtn.backgroundColor = Color(238, 238, 238);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.textField) {
        if (string.length == 0)
            return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
//            [SVProgressHUD showErrorWithStatus:@"您输入的号码已超出范围"];
            return NO;
        }
    }
    return YES;
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
