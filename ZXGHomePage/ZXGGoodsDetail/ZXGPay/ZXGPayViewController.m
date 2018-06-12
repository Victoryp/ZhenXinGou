//
//  ZXGPayViewController.m
//  ZhenXinGou
//
//  Created by Victor on 2017/11/23.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "ZXGPayViewController.h"

@interface ZXGPayViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *payWebView;

@end

@implementation ZXGPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.payWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT)];
    self.payWebView.delegate = self;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [userDefaults objectForKey:@"phoneNum"];

    NSString *payUrl = [NSString stringWithFormat:@"http://codepay.fateqq.com:52888/creat_order?id=11460&token=waoPMJCuxN22pKyFWBwuUYS6t7gKfoEy&&price=%@&pay_id=%@&type=1&pay_type=1&param=yuanpeng",self.goodsPrice,phoneNum];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:payUrl]];
    [self.payWebView loadRequest:request];

    [self.view addSubview:self.payWebView];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
        [self performSelector:@selector(openAliPay) withObject:nil afterDelay:1];
}

- (void)openAliPay {
    NSString *jsStr = [NSString stringWithFormat:@"window.location.href=msg.children[0].children[0]"];
    [self.payWebView stringByEvaluatingJavaScriptFromString:jsStr];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
        NSString *jsStr = [NSString stringWithFormat:@"window.location.href=msg.children[0].children[0]"];
        [self.payWebView stringByEvaluatingJavaScriptFromString:jsStr];
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
