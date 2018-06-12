//
//  ZXGUploadGoodsTableViewCell.h
//  ZhenXinGou
//
//  Created by Victor on 2017/12/4.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZXGUploadGoodsTableViewCellDelegate <NSObject>

- (void)addGoodsImg:(NSInteger)imgType;

@end

@interface ZXGUploadGoodsTableViewCell : UITableViewCell

@property (strong, nonatomic) id <ZXGUploadGoodsTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextField *goodsName;
@property (weak, nonatomic) IBOutlet UITextField *goodsPrice;
@property (weak, nonatomic) IBOutlet UITextField *goodsType;
@property (weak, nonatomic) IBOutlet UITextView *goodsContent;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIImageView *img4;
@property (weak, nonatomic) IBOutlet UIImageView *img5;
@property (weak, nonatomic) IBOutlet UIImageView *img6;

@end
