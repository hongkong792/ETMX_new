//
//  LogiinViewController.m
//  ETMX
//
//  Created by 杨香港 on 2016/10/30.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "LogiinViewController.h"
#import "UserAccount.h"
#import "NetWorkManager.h"
#import "TaskMainControllerViewController.h"
#import "UserManager.h"


@implementation LoginResponse

MJExtensionLogAllProperties
@end

@interface LogiinViewController ()<NSXMLParserDelegate>

@property(nonatomic,strong)AFHTTPSessionManager * manager;
@property(nonatomic,strong)UserAccount * userAccount;
@property(nonatomic,strong)LoginResponse * loginResult;
@property (nonatomic,strong)NSString * loginType ;


@end




@implementation LogiinViewController


- (instancetype)init
{
    self = [super init];
    self.manager =  [AFHTTPSessionManager manager];
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
  

}


- (void)loginWithReq:(UserAccount *)user withUrl:(NSString *)url method:(NSString *)method success:(HttpSuccess)success failure:(HttpFailure)failure
{
    //    获取所有任务接口测试（getTasksByUserCode(String userCode)）
    NSMutableArray *paramters = [NSMutableArray array];
    if ([method isEqualToString:@"checkUserInfo"] ) {
        [paramters addObject:user.name];
        [paramters  addObject:user.password];
    }else if ([method isEqualToString:@"checkCode"]){
        [paramters addObject:user.number];
    }
    NSString *methodName = method;
    self.loginType = method;
    //网络检测
    if (![[CheckNetWorkerTool sharedManager] isNetWorking]) {
        [self.delegate neeNotWorking];
    }
    
    [NetWorkManager sendRequestWithParameters:paramters method:methodName success:^(id data) {
        NSString *datastr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSXMLParser *p = [[NSXMLParser alloc] initWithData:data];
        [p setDelegate:self];
        [p parse];
    } failure:^(NSError *error) {
        NSLog( @"%@",error);
    }];
}

#pragma mark -- NSXMLParserDelegate数据解析

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{

    if ([elementName isEqualToString:@"User"] && [self.loginType isEqualToString:@"checkUserInfo"]) {
        LoginResponse *user = [LoginResponse mj_objectWithKeyValues:attributeDict];
        UserAccount *userAccount = [UserAccount mj_objectWithKeyValues:attributeDict];
        if (user != nil) {
            [[UserManager instance] setCurAccount:userAccount];
            if ([user.flag isEqualToString:@"1"]) {
                    [self.delegate loginSuccess];
            }else{
                [self.delegate loginFail];
            }
        }
    }else if ([self.loginType isEqualToString:@"checkCode"] && [elementName isEqualToString:@"Task"]){///二维码登录
        
        LoginResponse *user = [LoginResponse mj_objectWithKeyValues:attributeDict];
        UserAccount *userAccount = [[UserAccount alloc] init];
        userAccount.name = user.objectName;
        userAccount.number = user.objectCode;
        userAccount.fullName = user.objectAlias;
       if ([user.flag isEqualToString:@"1"]) {
            [[UserManager instance] setCurAccount:userAccount];
            [self.delegate loginSuccess];
       }else{
            [self.delegate loginFail];
       }
        //处理解析
    }
    
}


- (void)dealloc
{
    self.loginResult = nil;
    self.loginType = nil;
}
@end
