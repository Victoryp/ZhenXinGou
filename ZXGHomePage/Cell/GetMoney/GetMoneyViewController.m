//
//  GetMoneyViewController.m
//  ZhenXinGou
//
//  Created by Victor on 2018/5/10.
//  Copyright © 2018年 Victor. All rights reserved.
//

#import "GetMoneyViewController.h"

@interface GetMoneyViewController ()
@property (nonatomic, strong) AFHTTPSessionManager *mgrr;
@property (nonatomic, assign) NSInteger startLoc;
@property (nonatomic, strong) UILocalNotification *localNotification;

@end

@implementation GetMoneyViewController

- (AFHTTPSessionManager *)mgrr{
    if (!_mgrr) {
        _mgrr = [[AFHTTPSessionManager alloc]init];
        _mgrr.requestSerializer = [AFHTTPRequestSerializer serializer];
        [_mgrr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _mgrr.requestSerializer.timeoutInterval = 5.f;
        [_mgrr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        _mgrr.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _mgrr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.startLoc = 1;
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    self.localNotification = localNotification;

    // 此处需要写一个异步任务，是因为需要开辟一个新的线程去反复执行你的代码块，否则会阻塞主线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        while (self.startLoc == 1) {
            
            // 每隔5秒执行一次（当前线程阻塞5秒）
            [NSThread sleepForTimeInterval:5];
            
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            
            // 这里写你要反复处理的代码，如网络请求
            NSLog(@"***每5秒输出一次这段文字***");
            [self getList];

            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            
            if ([NSThread currentThread].isCancelled) {
                NSLog(@"2...88");
                return;
            }
        };
    });

}

- (IBAction)loginBtnAction:(id)sender {
    NSString *askingURL =  @"https://m.leader001.cn/qmch/generalRequest?parameter=%7B%22command%22:%22login%22,%22requestType%22:%22login%22,%22userName%22:%2217664080215%22,%22password%22:%22510280321a%22,%22productName%22:%22lzcp%22,%22channel%22:%221020025%22,%22platform%22:%22IOS%22,%22imei%22:%22869271010208178%22,%22version%22:%224.4.25%22%7D&callBackMethod=jQuery111107794920853339136_1513158538344&_=1513158538345";
    [self.mgrr GET:askingURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *messageInfo = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"sss%@sss", messageInfo);
        NSArray *a = [messageInfo componentsSeparatedByString:@"("];
        NSArray *b = [a[1] componentsSeparatedByString:@")"];
        NSDictionary *dic = [self dictionaryWithJsonString:b[0]];
        NSLog(@"ddddddddddd%@",dic);
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:dic[@"result"][@"accessToken"] forKey:@"accessToken"];
        [userDefaults synchronize];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];
}

- (void)getList {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [userDefault objectForKey:@"accessToken"];

    NSString *c = @"https://m.leader001.cn/support/bdapi/sharporder/redhalling?parameter={\"information\":\"bd_web_api\",\"command\":\"redhalling\",\"userno\":\"2017082107579931\",\"accessToken\":\"d403dbd4aabf0516b9dbe81f6705dadb\",\"token\":\"\",\"imei\":\"DC974AEA-50C8-4423-B1FE-4B0EB0C62D1E\",\"platform\":\"html\",\"version\":\"4.4.25\",\"productName\":\"ltcp22\"}&_=1525939181745";
     c = [c stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    

    NSString *a = @"https://m.leader001.cn/support/bdapi/sharporder/redhalling?parameter={%22information%22:%22bd_web_api%22,%22command%22:%22redhalling%22,%22userno%22:%222017082107579931%22,%22accessToken%22:%22";
    NSString *b = @"%22,%22token%22:%22%22,%22imei%22:%22DC974AEA-50C8-4423-B1FE-4B0EB0C62D1E%22,%22platform%22:%22IOS%22,%22version%22:%224.4.25%22,%22productName%22:%22ltcp22%22}&_=1525939181745&callback=Zepto1525939171239";
    NSString *askingURL = [NSString stringWithFormat:@"%@%@%@",a,accessToken,b];
     askingURL = [askingURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [self.mgrr GET:c parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *messageInfo = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"sss%@sss", messageInfo);
//        NSArray *a = [messageInfo componentsSeparatedByString:@"("];
//        NSArray *b = [a[1] componentsSeparatedByString:@")"];
//        NSDictionary *dic = [self dictionaryWithJsonString:b[0]];
        NSDictionary *dic = [self dictionaryWithJsonString:messageInfo];
        NSLog(@"%@",dic);
        if ([[NSString stringWithFormat:@"%@",dic[@"errorCode"]] isEqualToString:@"0001"]) {
            
        }else if ([[NSString stringWithFormat:@"%@",dic[@"data"][@"list"][0][@"status"]] isEqualToString:@"4"]) {
//            [self getMoney];
        }else {
            [self getMoney];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];

}

- (void)getMoney {
    NSString *askingURL = @"https://m.leader001.cn/support/bdapi/sharporder/grab?parameter=%7B%22information%22:%22bd_web_api%22,%22command%22:%22grab%22,%22userno%22:%222017082107579931%22,%22id%22:%225af4fc5d0cf2f8cb00190f6e%22,%22platform%22:%22html%22,%22version%22:%224.2.25%22,%22productName%22:%22lzcp%22%7D&_=1515500103336&callback=Zepto1515499555122%0A";
    [self.mgrr GET:askingURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *messageInfo = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"sss%@sss", messageInfo);
        [self nextGetMoney];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];
}

- (void)nextGetMoney {
    NSString *askingURL = @"https://m.leader001.cn/support/bdapi/sharporder/reddetail?parameter=%7B%22information%22:%22bd_web_api%22,%22command%22:%22reddetail%22,%22userno%22:%222017082107579931%22,%22id%22:%225af4fc5d0cf2f8cb00190f6e%22,%22start%22:0,%22size%22:50,%22platform%22:%22html%22,%22version%22:%224.2.25%22,%22productName%22:%22lzcp%22%7D&_=1515588784864&callback=Zepto1515499555122%0A";
    [self.mgrr GET:askingURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *messageInfo = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"aaaaaaa%@", messageInfo);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];
}

- (void)ff {
    NSString *followURL = @"https://m.leader001.cn/support/bdapi/sharporder/redhalling?parameter={%22information%22:%22bd_web_api%22,%22command%22:%22redhalling%22,%22userno%22:%222017082107579931%22,%22accessToken%22:%22d403dbd4aabf0516b9dbe81f6705dadb%22,%22token%22:%22%22,%22imei%22:%22DC974AEA-50C8-4423-B1FE-4B0EB0C62D1E%22,%22platform%22:%22html%22,%22version%22:%224.4.25%22,%22productName%22:%22ltcp22%22}&_=1525939181745";
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)followURL, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    [self.mgr GET:encodedString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
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
