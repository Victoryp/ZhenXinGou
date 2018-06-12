//
//  ZXGHomePageViewController.m
//  ZhenXinGou
//
//  Created by Victor on 2017/11/7.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "ZXGHomePageViewController.h"
#import "ZXGLeftViewController.h"
#import "ZXGUploadGoodsViewController.h"

#import "ZXGChatViewController.h"
#import "ZXGConversationListViewController.h"
#import "ZXGGoodsDetailViewController.h"

#import "BannerTableViewCell.h"
#import "TypeTableViewCell.h"
#import "ItemTableViewCell.h"

#import <RongIMKit/RongIMKit.h>
#import "RESideMenu.h"

#import "ZXGPayViewController.h"

#import "GetMoneyViewController.h"

static NSString *bannerID = @"bannerID";
static NSString *typeID = @"typeID";
static NSString *itemID = @"itemID";
@interface ZXGHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,TypeBtnDelegate,ZXGUploadGoodsViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *myIcon;
@property (weak, nonatomic) IBOutlet UIButton *updateGoods;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@property (strong, nonatomic) BannerTableViewCell *bannerCell;
@property (strong, nonatomic) ItemTableViewCell *itemCell;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSMutableArray *goodsMutableArray;

@end

@implementation ZXGHomePageViewController

- (NSMutableArray *)goodsMutableArray {
    if (!_goodsMutableArray) {
        _goodsMutableArray = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return _goodsMutableArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, -50, 0);
    self.view.alpha = 0.5f;
    [UIView animateWithDuration:0.9f animations:^{
        self.view.layer.transform = CATransform3DIdentity;
        self.view.alpha = 1.0f;
    }];

//    AVObject *testObject = [AVObject objectWithClassName:@"Goods"];
//    [testObject setObject:@"白酒" forKey:@"goodsName"];
//    [testObject save];
    
    [self loginChat];

    [self getData];
//    [self aaa];
    self.myIcon.layer.cornerRadius = 33/2;
    self.myIcon.clipsToBounds = YES;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [userDefaults objectForKey:@"phoneNum"];
    if ([manager containsString:phoneNum]) {
        self.updateGoods.hidden = NO;
        [self.bottomBtn setTitle:@"会话列表" forState:UIControlStateNormal];
    }else {
        self.updateGoods.hidden = YES;
        [self.bottomBtn setTitle:@"咨询购买" forState:UIControlStateNormal];
    }
    
    [self.mainTableView registerClass:[BannerTableViewCell class] forCellReuseIdentifier:bannerID];
    [self.mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass([TypeTableViewCell class]) bundle:nil] forCellReuseIdentifier:typeID];
    [self.mainTableView registerClass:[ItemTableViewCell class] forCellReuseIdentifier:itemID];

    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = 0;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    self.mainTableView.mj_header = header;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToGoodsDetail:) name:@"selectedItem" object:nil];
    
}

- (IBAction)leftBtnAction:(UIButton *)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)refreshHomePage {
    [self getData];
}

- (IBAction)rightBtnAction:(UIButton *)sender {
    ZXGUploadGoodsViewController *uploadVC = [[ZXGUploadGoodsViewController alloc] init];
    uploadVC.delegate = self;
    [self.navigationController pushViewController:uploadVC animated:YES];

}

- (void)aaa {
//    http://codepay.fateqq.com:52888/creat_order?id=10041&token=888888&&price=100&pay_id=admin&type=1
//    NSString *askingURL = @"http://codepay.fateqq.com:52888/creat_order";
//    NSDictionary *dic = @{
//                        @"id":@"15234",
//                        @"price":@"100",
//                        @"token":@"tuKqTbmRwNUAMCWA6WaxV3fbA8K39D78",
//                        @"pay_id":@"123",
//                        @"type":@"1",
//                        @"page":@"3",
//                        @"call":@"callback"
//                        };
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://codepay.fateqq.com:52888/creat_order?id=15234&token=tuKqTbmRwNUAMCWA6WaxV3fbA8K39D78&&price=1&pay_id=admin&type=1&pay_type=1"]];
//    [self.mgr POST:askingURL parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"----------------%@",responseObject);
//        if ([[responseObject valueForKey:@"code"] isEqualToString:@"000"]) {
//
//        }else {
//
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
//    }];

}

- (void)loginChat {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [userDefaults objectForKey:@"phoneNum"];

    NSString *followURL = @"/API/gettoken.php";
    NSString *askingURL = [NSString stringWithFormat:@"%@%@", localURL, followURL];
    NSDictionary *dic = @{
                          @"uid":phoneNum,
                          @"uname":@"nnn"
                          };
    [self.mgr POST:askingURL parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"----------------%@",responseObject);
        if ([[responseObject valueForKey:@"code"] integerValue] ==200) {
            [[RCIM sharedRCIM] connectWithToken:responseObject[@"token"]     success:^(NSString *userId) {
                NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
            } error:^(RCConnectErrorCode status) {
                NSLog(@"登陆的错误码为:%d", status);
            } tokenIncorrect:^{
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                NSLog(@"token错误");
            }];
        }else {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];
}

- (void)getData {
    NSString *followURL = @"/homepage/homepage.php";
    NSString *askingURL = [NSString stringWithFormat:@"%@%@", localURL, followURL];
//    NSDictionary *dic = @{
//                          @"fid":@"10002",
//                          @"pageNum":@"1"
//                          };
    [self.mgr GET:askingURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"/mall/goods/i%@",responseObject);
        if ([[responseObject valueForKey:@"code"] isEqualToString:@"200"]) {
            [self.mainTableView.mj_header endRefreshing];
            
//            self.resDic = responseObject;
            self.dataArray = responseObject[@"data"];
            NSArray *goodsArray = responseObject[@"data"];
            self.goodsMutableArray = nil;
            if (goodsArray.count >= 2) {
                self.bannerCell.banArray = [goodsArray subarrayWithRange:NSMakeRange(0, 2)];
                for (int i = 0 ; i < goodsArray.count; i ++) {
                    if (i >1) {
                        [self.goodsMutableArray addObject:goodsArray[i]];
                    }
                }
                self.itemCell.dataArray = self.goodsMutableArray;
                if (self.goodsMutableArray.count%2 == 0) {
                    self.itemCell.goodsAccount = self.goodsMutableArray.count/2;
                }else {
                    self.itemCell.goodsAccount = self.goodsMutableArray.count/2 + 1;
                }
            }
            [self.mainTableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshItemCollectionView" object:nil];
        }else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self.mainTableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];
    
}

// 化妆品
- (void)cosBtnAction {
    [SVProgressHUD showSuccessWithStatus:@"❤️❤️❤️"];
}

// 零食
- (void)snacksBtnAction {
//    HTTPS://QR.ALIPAY.COM/FKX02046JHZZSUZHXNUTC3?t=1528703889778
    NSString *a = @"HTTPS://QR.ALIPAY.COM/FKX02046JHZZSUZHXNUTC3?t=1528703889778";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:a]];

//    GetMoneyViewController *getMoneyVC = [[GetMoneyViewController alloc] init];
//    [self.navigationController pushViewController:getMoneyVC animated:YES];
    
//    ZXGPayViewController *payVC = [[ZXGPayViewController alloc] init];
//    [self.navigationController pushViewController:payVC animated:YES];

//    [SVProgressHUD showSuccessWithStatus:@"❤️❤️❤️"];
}

// 跳转单个详细
- (void)jumpToGoodsDetail:(NSNotification *)dict {
    NSLog(@"%@",dict.object[@"itemID"]);
    ZXGGoodsDetailViewController *goodsDetailVC = [[ZXGGoodsDetailViewController alloc] init];
    goodsDetailVC.dataDic = self.dataArray[[dict.object[@"itemID"] integerValue] + 2];
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}

// 聊天
- (IBAction)chat:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [userDefaults objectForKey:@"phoneNum"];
    if ([manager containsString:phoneNum]) {
        ZXGConversationListViewController *conversationVC = [[ZXGConversationListViewController alloc] init];
        [self.navigationController pushViewController:conversationVC animated:YES];
    }else {
        ZXGChatViewController *chatVC = [[ZXGChatViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:@"17664080215"];
        chatVC.customID = @"17664080215";
        [self.navigationController pushViewController:chatVC animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BannerTableViewCell *bannerCell = [tableView dequeueReusableCellWithIdentifier:bannerID forIndexPath:indexPath];
        self.bannerCell = bannerCell;
        bannerCell.selectionStyle = 0;
        return bannerCell;
    }else if (indexPath.row == 1) {
        TypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:typeID forIndexPath:indexPath];
        cell.delegate = self;
        cell.selectionStyle = 0;
        return cell;
    }else {
        ItemTableViewCell *itemCell = [tableView dequeueReusableCellWithIdentifier:itemID forIndexPath:indexPath];
        self.itemCell = itemCell;
        itemCell.selectionStyle = 0;
        return itemCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 180;
    }else if (indexPath.row == 1) {
        return 80;
    }else {
        if (self.goodsMutableArray.count%2 == 0) {
            return ((VIEW_WIDTH-45)/2 + 85)*self.goodsMutableArray.count/2;
        }else {
            return ((VIEW_WIDTH-45)/2 + 112)*self.goodsMutableArray.count/2 + 1;
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
