//
//  UserManager.m
//  ETMX
//
//  Created by wenpq on 16/10/31.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager

+(UserManager *)instance{
    static UserManager *sharedUserManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUserManager = [[self alloc] init];
    });
    return sharedUserManager;
}

@end
