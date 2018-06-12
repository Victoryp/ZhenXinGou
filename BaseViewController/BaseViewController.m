//
//  BaseViewController.m
//  ZhenXinGou
//
//  Created by Victor on 2017/11/7.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "BaseViewController.h"

static BOOL _isPoping;
@interface BaseViewController ()<UINavigationControllerDelegate>

@end

@implementation BaseViewController

- (AFHTTPSessionManager *)mgr{
    if (!_mgr) {
        _mgr = [[AFHTTPSessionManager alloc]init];
        _mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
        [_mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        _mgr.requestSerializer.timeoutInterval = 5.f;
        [_mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//        _mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _mgr;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    //开启ios右滑返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (!_isPoping) {
        _isPoping = YES;
        return YES;
    }
    return NO;
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    //在didAppear时置为NO
    _isPoping = NO;
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    //    / if rootViewController, set delegate nil /
    if (navigationController.viewControllers.count == 1) {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
        navigationController.interactivePopGestureRecognizer.delegate = nil;
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
