//
//  ZXGGoodsMessage.h
//  ZhenXinGou
//
//  Created by Victor on 2017/11/17.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>
#import <RongIMLib/RCMessageContentView.h>

@interface ZXGGoodsMessage : RCMessageContent <NSCoding,RCMessageContentView>

@property (nonatomic, strong) NSString *imgPath;
@property (nonatomic, strong) NSString *goodsName;
@property (nonatomic, strong) NSString *goodsPrice;

@end
