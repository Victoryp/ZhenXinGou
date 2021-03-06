//
//  TypeTableViewCell.h
//  ZhenXinGou
//
//  Created by Victor on 2017/11/7.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TypeBtnDelegate <NSObject>

- (void)cosBtnAction;
- (void)snacksBtnAction;

@end

@interface TypeTableViewCell : UITableViewCell

@property (nonatomic, strong) id <TypeBtnDelegate> delegate;

@end
