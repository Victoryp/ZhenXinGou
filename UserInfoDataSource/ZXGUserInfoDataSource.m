//
//  ZXGUserInfoDataSource.m
//  ZhenXinGou
//
//  Created by Victor on 2017/12/8.
//  Copyright © 2017年 Victor. All rights reserved.
//

#import "ZXGUserInfoDataSource.h"

@implementation ZXGUserInfoDataSource

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    RCUserInfo *user = [[RCUserInfo alloc] init];
    user.userId = userId;
    user.name = @"上帝";
    user.portraitUri = @"";
    completion(user);
}

- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion {
    RCGroup *group = [[RCGroup alloc] init];
    group.groupId = groupId;
    group.groupName = @"买买买";
    group.portraitUri = @"";
    completion(group);
}

@end
