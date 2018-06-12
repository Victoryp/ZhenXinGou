//
//  ZXGChatViewController.m
//  ZhenXinGou
//
//  Created by Victor on 2017/11/17.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "ZXGChatViewController.h"
#import "ZXGGoodsMessage.h"
#import "ZXGGoodsCollectionViewCell.h"

@interface ZXGChatViewController ()

@end

@implementation ZXGChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    self.conversationType = ConversationType_PRIVATE;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    self.targetId = self.customID;

    self.conversationMessageCollectionView.frame = CGRectMake(0, 64, VIEW_WIDTH, VIEW_HEIGHT-64-50);

    [self registerClass:[ZXGGoodsCollectionViewCell class ] forMessageClass:[ZXGGoodsMessage class]];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 64)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 20, 40, 40);
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((VIEW_WIDTH - 160)/2, 23, 160, 33)];
    titleLabel.text = @"客服";
    titleLabel.textAlignment = 1;
    [self.view addSubview:titleLabel];

    
//    ZXGGoodsMessage *mess = [[ZXGGoodsMessage alloc] init];
//    mess.imgPath = @"http://zhenxingou.oss-cn-qingdao.aliyuncs.com/img/xuehuaxiumianmo2.jpeg";
//    mess.goodsName = @"fj";
//    mess.goodsPrice = @"9.00";
//    
//    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:@"123" content:mess pushContent:nil pushData:nil success:^(long messageId) {
//        NSLog(@"messageId%ld",messageId);
//    } error:^(RCErrorCode nErrorCode, long messageId) {
//        NSLog(@"%ld",messageId);
//        
//    }];

}

- (void)goback {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    ZXGGoodsMessage *mess = [[ZXGGoodsMessage alloc] init];
    mess.imgPath = @"fdf";
    mess.goodsName = @"fj";
    mess.goodsPrice = @"9.00";
    
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:@"123" content:mess pushContent:nil pushData:nil success:^(long messageId) {
        NSLog(@"messageId%ld",messageId);
    } error:^(RCErrorCode nErrorCode, long messageId) {
        NSLog(@"%ld",messageId);
        
    }];

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
