//
//  NetWorkManager.m
//  ETMX
//
//  Created by wenpq on 16/10/30.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "NetWorkManager.h"
#define NetRequestParameter         @"NetRequestParameter"
@implementation NetWorkManager

+(void)sendRequestWithParameters:(NSArray *)paramters method:(NSString *)methodName success:(HttpSuccess )success failure:(HttpFailure)failure{
    NSString *urlStr = [self getURLByRequestName:methodName];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //回复的序列化
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [[manager dataTaskWithRequest:[self loadRequestWithParameter:paramters url:urlStr methodName:methodName] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSString *node =  [NetWorkManager getNodeByRequestName:methodName];
            NSError *readError = nil;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:responseObject error:&readError];
            NSDictionary *dict1 = [dict valueForKey:@"soap:Envelope"];
            NSDictionary *dict2 = [dict1 valueForKey:@"soap:Body"];
            NSDictionary *dict3 = [dict2 valueForKey:node];
            NSDictionary *dict4 = [dict3 valueForKey:@"ns1:out"];
            NSString *str = [dict4 valueForKey:@"text"];
            NSData *newData = [str dataUsingEncoding:NSUTF8StringEncoding];
            success(newData);
        } else {
            failure(error);
        }
    }] resume];
    
    
}
//根据方法名获取url
+(NSString *)getURLByRequestName:(NSString *)methodName{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",[NetWorkManager getServiceURL],[NetWorkManager getServiceURIByMethodName:methodName]];
    return urlStr;
}
//根据方法名获得xml解析节点
+(NSDictionary *)getCurMethodDicByMethodName:(NSString *)methodName{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:NetRequestParameter ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSDictionary *curParameterDic = [dic valueForKey:methodName];
    return curParameterDic;
}

+(NSString *)getNodeByRequestName:(NSString *)methodName{
    NSDictionary *curParameterDic = [NetWorkManager getCurMethodDicByMethodName:methodName];
    NSString *parserNode = [curParameterDic valueForKey:@"node"];
    return parserNode;
}

//获取方法名对应的uri
+(NSString *)getServiceURIByMethodName:(NSString *)methodName{
    NSDictionary *curParameterDic = [NetWorkManager getCurMethodDicByMethodName:methodName];
    NSString *uriStr = [curParameterDic valueForKey:@"URI"];
    return uriStr;
}

//获得服务器url不包括uri部分
+(NSString *)getServiceURL{
    NSString *ipStr = [[NSUserDefaults standardUserDefaults] valueForKey:ADRESSIP];
    NSString *serviceURL = [NSString stringWithFormat:@"http://%@:8085",ipStr];
    return serviceURL;
}

+(NSMutableURLRequest *)loadRequestWithParameter:(NSArray *)parameters url:(NSString *)urlString methodName:(NSString *)methodName{
    NSString *webBody = [NSString stringWithFormat:@"<web:%@>\n",methodName];
    for (NSInteger i = 0; i<parameters.count; i++) {
        NSString *paraStr = [NSString stringWithFormat:@"<web:in%ld>%@</web:in%ld>\n",i,parameters[i],i];
        webBody = [webBody stringByAppendingString:paraStr];
    }
    webBody = [webBody stringByAppendingString:[NSString stringWithFormat:@"</web:%@>",methodName]];
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                              "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://webservice.etmx.elite.com/\" >"
                             "<soapenv:Body>"
                             "%@"
                             "</soapenv:Body>"
                              "</soapenv:Envelope>",webBody
                             ];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%ld",[soapMessage length]];
    // 添加请求的详细信息，与请求报文前半部分的各字段对应
    [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    // 设置请求行方法为POST，与请求报文第一行对应
    [req setHTTPMethod:@"POST"];
    // 将SOAP消息加到请求中
    [req setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return req;
}

//GET请求
+(void)getWithUrlString:(NSString *)urlString success:(HttpSuccess)success failure:(HttpFailure)failure{
    //创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //内容类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    //get请求
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];


    
}

//POST请求
+(void)postWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure{
    //创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //内容类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    //post请求
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
@end
