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

@interface LogiinViewController ()

@property(nonatomic,strong)AFHTTPSessionManager * manager;
@property(nonatomic,strong)UserAccount * userAccount;

@end


@implementation LoginResponse

+(NSDictionary *)replacedKeyFromPropertyName{
    
    return  @{@"IDw":@"wpq"};
    
}


+ (NSDictionary *)mj_replacedKeyFromPropertyName;
{
     return  @{@"IDw":@"wpq"};
}
+ (id)mj_replacedKeyFromPropertyName121:(NSString *)propertyName
{    
     return  @{@"wpq":@"IDw"};
}

MJExtensionLogAllProperties
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
    NSArray *paramters = [NSArray arrayWithObjects:user.number,nil];
    NSString *urlStr = url;
    NSString *methodName = @"checkUserInfo";
    [NetWorkManager sendRequestWithParameters:paramters url:urlStr method:methodName success:^(id data) {
        NSError *error = nil;
        NSDictionary *dict = [XMLReader dictionaryForXMLData:data error:&error];
        NSDictionary *dict1 = [dict valueForKey:@"soap:Envelope"];
        NSDictionary *dict2 = [dict1 valueForKey:@"soap:Body"];
        NSDictionary *dict3 = [dict2 valueForKey:@"ns1:getTasksByUserCodeResponse"];///到时候换掉
        NSDictionary *dict4 = [dict3 valueForKey:@"ns1:out"];
        NSString *str = [dict4 valueForKey:@"text"];//该字段根据实践情况获得
        NSData *newData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSXMLParser *p = [[NSXMLParser alloc] initWithData:newData];
        [p setDelegate:self];
        [p parse];
        
    } failure:^(NSError *error) {
        NSLog( @"%@",error);
    }];
    
}

#pragma mark -- NSXMLParserDelegate数据解析

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{

    if ([elementName isEqualToString:@"User"]) {
        UserAccount *user = [[UserAccount alloc] init];
   

        
    }
}



@end
