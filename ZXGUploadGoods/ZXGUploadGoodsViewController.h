//
//  ZXGUploadGoodsViewController.h
//  ZhenXinGou
//
//  Created by Victor on 2017/12/4.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "BaseViewController.h"

@protocol ZXGUploadGoodsViewControllerDelegate <NSObject>

- (void)refreshHomePage;

@end

@interface ZXGUploadGoodsViewController : BaseViewController

@property (nonatomic, strong) id <ZXGUploadGoodsViewControllerDelegate> delegate;

@end
