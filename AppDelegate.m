//
//  AppDelegate.m
//  ZhenXinGou
//
//  Created by Victor on 2017/11/7.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "AppDelegate.h"
#import "ZXGHomePageViewController.h"
#import "ZXGLoginViewController.h"
#import "ZXGLeftViewController.h"

#import "ZXGGoodsMessage.h"

#import "ZXGUserInfoDataSource.h"
#import <RongIMKit/RongIMKit.h>
#import "RESideMenu.h"
#import <AVOSCloud/AVOSCloud.h>

#define IOS8 ([[[UIDevice currentDevice] systemVersion] doubleValue] >=8.0 ? YES : NO)
@interface AppDelegate ()<RCIMReceiveMessageDelegate>

@property (nonatomic, strong) ZXGUserInfoDataSource *user;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = Color(51, 51, 51);
    [self.window makeKeyAndVisible];
    
    // 初始化融云
    [[RCIM sharedRCIM] initWithAppKey:@"x18ywvqfxneqc"];
    [[RCIMClient sharedRCIMClient]registerMessageType:ZXGGoodsMessage.class];

    // 初始化云存储
    [AVOSCloud setApplicationId:@"3Qj9vyp0UKYcu7aFQSGgdAOx-gzGzoHsz" clientKey:@"YmzjqMEBx9DhLPmYvEBtThG6"];
    // 统计
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.user = [[ZXGUserInfoDataSource alloc] init];
    [RCIM sharedRCIM].userInfoDataSource = self.user;
    [RCIM sharedRCIM].groupInfoDataSource = self.user;
    
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [userDefaults objectForKey:@"phoneNum"];
    if (phoneNum != nil) {
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

        self.window.rootViewController = navVC;
    }else {
        ZXGLoginViewController *VC = [[ZXGLoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
        self.window.rootViewController = nav;
    }

    [self addLaunchingImage];

    // iOS8以上要求开启通知
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
    return YES;
}

- (void)addLaunchingImage{
    UIImageView *launchingImage = [[UIImageView alloc]initWithFrame:self.window.frame];
    launchingImage.image = [UIImage imageNamed:@"zhenxingou"];
    [self.window addSubview:launchingImage];
    UILabel *ver = [[UILabel alloc] initWithFrame:CGRectMake((VIEW_WIDTH-100)/2, VIEW_HEIGHT - 50, 100, 20)];
    ver.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    ver.textAlignment = 1;
    ver.textColor = [UIColor whiteColor];
    [self.window addSubview:ver];
    __block CGRect launchingImageRect = launchingImage.bounds;
    
    [UIView animateWithDuration:1.5 animations:^{
        //让launchingImage的frame变大
        launchingImageRect = CGRectMake(-20, -20, VIEW_WIDTH+40, VIEW_HEIGHT+40);
        //将新的frame赋值给launchingImage
        launchingImage.frame = launchingImageRect;
    } completion:^(BOOL finished) {
        //判断动画是否执行完成
        if (finished) {
            [ver removeFromSuperview];
            //如果执行完成就将透明度设置成0，使其缓慢消失
            [UIView animateWithDuration:0.5 animations:^{
                launchingImage.alpha = 0;
            } completion:^(BOOL finished) {
                if (finished) {
                    //动画执行完成后将其移除
                    [launchingImage removeFromSuperview];
                }
            }];
        }
    }];
}

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    
}

- (BOOL)onRCIMCustomLocalNotification:(RCMessage *)message withSenderName:(NSString *)senderName {
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
