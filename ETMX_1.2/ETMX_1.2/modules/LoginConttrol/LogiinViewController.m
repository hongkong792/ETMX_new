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
    // Do any additional setup after loading the view from its nib.

}


- (void)loginWithReq:(UserAccount *)user withUrl:(NSString *)url success:(HttpSuccess)success failure:(HttpFailure)failure
{
    //    获取所有任务接口测试（getTasksByUserCode(String userCode)）
    NSMutableArray *paramters = [NSMutableArray array];
    [paramters addObject:user.name];
    [paramters  addObject:user.password];
    NSString *methodName = @"checkUserInfo";
    [NetWorkManager sendRequestWithParameters:paramters method:methodName success:^(id data) {
        NSXMLParser *p = [[NSXMLParser alloc] initWithData:data];
        [p setDelegate:self];
        [p parse];
    } failure:^(NSError *error) {
        NSLog( @"%@",error);
    }];
}

#pragma mark -- NSXMLParserDelegate数据解析

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{

    if ([elementName isEqualToString:@"User"]) {
        LoginResponse *user = [LoginResponse mj_objectWithKeyValues:attributeDict];
        UserAccount *userAccount = [UserAccount mj_objectWithKeyValues:attributeDict];
        if (user != nil) {
  
            [[UserManager instance] setCurAccount:userAccount];
            if ([user.flag isEqualToString:@"1"]) {
                     [self checkUserAndSave];
            }else{
                
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"用户名或密码不正确" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    return ;
                }];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
}


- (void)dealloc
{
    self.loginResult = nil;
}
- (void)checkUserAndSave
{
//    TaskMainControllerViewController *taskMainVC = [[TaskMainControllerViewController alloc] init];
//    [self.navigationController pushViewController:taskMainVC animated:YES];
    
    [self.delegate loginSuccess];
}

@end
