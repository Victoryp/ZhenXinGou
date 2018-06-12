//
//  ZXGGoodsMessage.m
//  ZhenXinGou
//
//  Created by Victor on 2017/11/17.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "ZXGGoodsMessage.h"
#import <RongIMLib/RCUtilities.h>

@implementation ZXGGoodsMessage

+(RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}

#pragma mark – NSCoding protocol methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.imgPath = [aDecoder decodeObjectForKey:@"imgPath"];
        self.goodsName = [aDecoder decodeObjectForKey:@"goodsName"];
        self.goodsPrice = [aDecoder decodeObjectForKey:@"goodsPrice"];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.imgPath forKey:@"imgPath"];
    [aCoder encodeObject:self.goodsName forKey:@"goodsName"];
    [aCoder encodeObject:self.goodsPrice forKey:@"goodsPrice"];
}

#pragma mark – RCMessageCoding delegate methods

-(NSData *)encode {
    
    NSMutableDictionary *dataDict=[NSMutableDictionary dictionary];
    [dataDict setObject:self.imgPath forKey:@"imgPath"];
    [dataDict setObject:self.goodsName forKey:@"goodsName"];
    [dataDict setObject:self.goodsPrice forKey:@"goodsPrice"];
    
    if (self.senderUserInfo) {
        NSMutableDictionary *__dic=[[NSMutableDictionary alloc]init];
        if (self.senderUserInfo.name) {
            [__dic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [__dic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [__dic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:__dic forKey:@"user"];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict
                                                   options:kNilOptions
                                                     error:nil];
    return data;
}

-(void)decodeWithData:(NSData *)data {
    __autoreleasing NSError* __error = nil;
    if (!data) {
        return;
    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:&__error];
    if (json) {
        self.imgPath = json[@"imgPath"];
        self.goodsName = json[@"goodsName"];
        self.goodsPrice = json[@"goodsPrice"];
    }
    
    NSObject *__object = [json objectForKey:@"user"];
    NSDictionary *userinfoDic = nil;
    if (__object &&[__object isMemberOfClass:[NSDictionary class]]) {
        userinfoDic =__object;
    }
    
    if (userinfoDic) {
        RCUserInfo *userinfo =[RCUserInfo new];
        userinfo.userId = [userinfoDic objectForKey:@"id"];
        userinfo.name =[userinfoDic objectForKey:@"name"];
        userinfo.portraitUri =[userinfoDic objectForKey:@"icon"];
        self.senderUserInfo = userinfo;
    }
}

- (NSString *)conversationDigest
{
    return @"消息";
}

+(NSString *)getObjectName {
    return @"ZXG:ImgMsg";
}

#if ! __has_feature(objc_arc)
-(void)dealloc
{
    [super dealloc];
}
#endif//__has_feature(objc_arc)

@end
