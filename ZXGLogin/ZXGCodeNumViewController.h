//
//  ZXGCodeNumViewController.h
//  ZhenXinGou
//
//  Created by Victor on 2017/11/29.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZXGCodeNumViewControllerDelegate <NSObject>

- (void)getCodeNum:(NSString *)num;

@end
@interface ZXGCodeNumViewController : UIViewController

@property (nonatomic, strong) id <ZXGCodeNumViewControllerDelegate> delgate;

@end
