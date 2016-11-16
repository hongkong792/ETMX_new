//
//  UserManager.m
//  ETMX
//
//  Created by wenpq on 16/10/31.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "UserManager.h"

@interface UserManager ()



@end

@implementation UserManager

+(UserManager *)instance{
    static UserManager *sharedUserManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUserManager = [[self alloc] init];
    });
    return sharedUserManager;
}
- (NSMutableDictionary *)dic
{
    if (_dic == nil) {
        _dic = [NSMutableDictionary dictionary];
        
    }
    return _dic;
}

- (void)setCurAccount:(UserAccount *)user
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:user.name forKey:@"name"];
    [dic setObject:user.fullName forKey:@"fullName"];
    [dic setObject:user.number forKey:@"number"];
    self.dic = dic;
}


@end
