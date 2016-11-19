//
//  UserAccount.h
//  ETMX
//
//  Created by wenpq on 16/10/31.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtensionConfig.h"

@interface UserAccount : MJExtensionConfig

/**用户名(用于登录)*/
@property (nonatomic ,strong)NSString*name;

/**密码*/
@property (nonatomic ,strong)NSString*password;

/**账户id*/
@property (nonatomic ,strong)NSString*id;

/**用户全名*/
@property (nonatomic ,strong)NSString*fullName;

/**账户工号*/
@property (nonatomic ,strong)NSString*number;

/**用户类型*/
@property (nonatomic ,strong)NSString*userType;
 

@end
