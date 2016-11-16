//
//  UserManager.h
//  ETMX
//
//  Created by wenpq on 16/10/31.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAccount.h"
#import "LogiinViewController.h"
//使用单例管理用户的行为
@interface UserManager : NSObject
+(UserManager *)instance;
-(UserAccount *)getCurAccount;
- (void)setCurAccount:(UserAccount *)user;
@property (nonatomic, strong)  NSMutableDictionary * dic ;

@end
