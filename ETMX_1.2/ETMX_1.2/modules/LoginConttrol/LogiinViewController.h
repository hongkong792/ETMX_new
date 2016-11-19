//
//  LogiinViewController.h
//  ETMX
//
//  Created by 杨香港 on 2016/10/30.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAccount.h"
#import "NetWorkManager.h"
#import "MJExtension.h"
#import "MJExtensionConfig.h"

@protocol loginSucessDelegate <NSObject>
- (void)loginSuccess;
- (void)loginFail;
- (void)neeNotWorking;


@end


@interface LoginResponse : MJExtensionConfig

@property(nonatomic,assign)NSString* flag;
@property(nonatomic,copy)NSString * message;
@property(copy, nonatomic)NSString *ID;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString *fullName;
@property(nonatomic,copy)NSString * number;


@property(nonatomic,copy)NSString * type; //扫描编号的对象类型
@property(nonatomic,copy)NSString * objectID;//对象ID
@property(nonatomic,copy)NSString * objectCode;//对象编号
@property(nonatomic,copy)NSString * objectName;//对象名称
@property(nonatomic,copy)NSString * objectAlias;//对象别名

@end


@interface LogiinViewController : UIViewController
- (void)loginWithReq:(UserAccount *)user withUrl:(NSString *)url method:(NSString *)method success:(HttpSuccess)success failure:(HttpFailure)failure;

@property (nonatomic, strong)id <loginSucessDelegate>delegate;
@end

