//
//  NetWorkManager.m
//  ETMX
//
//  Created by wenpq on 16/10/30.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "NetWorkManager.h"

@implementation NetWorkManager
+(void)sendRequestWith:(NSArray *)paramters url:(NSString *)urlStr method:(NSString *)methodName success:(HttpSuccess)success failure:(HttpFailure)failure{
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //回复的序列化
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [[manager dataTaskWithRequest:[self loadRequestWithParameter0:paramters url:urlStr methodName:methodName] completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                if (!error) {
                    success(responseObject);
                } else {
                    failure(error);
                }
    }] resume];
}

+(NSMutableURLRequest *)loadRequestWithParameter0:(NSArray *)parameters url:(NSString *)urlString methodName:(NSString *)methodName{
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

//+ (NSMutableURLRequest *)loadRequestWithParameter0:(NSString *)parameter0 parameter1:(NSString *)parameter1 url:(NSString *)urlString methodName:(NSString *)methodName{
//    
//    NSString *soapMessage =
//    [NSString stringWithFormat:
//     @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
//     "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://webservice.etmx.elite.com/\" >"
//     "<soapenv:Body>"
//     "<web:%@>"
//     "<web:in0>%@</web:in0>"
//     "<web:in1>%@</web:in1>"
//     "</web:%@>"
//     "</soapenv:Body>"
//     "</soapenv:Envelope>", methodName,parameter0,parameter1,methodName
//     ];
//    
//    // 将这个XML字符串打印出来
//    NSLog(@"%@", soapMessage);
//    // 创建URL，内容是前面的请求报文报文中第二行主机地址加上第一行URL字段
//    
//    NSURL *url = [NSURL URLWithString:urlString];
//    // 根据上面的URL创建一个请求
//    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
//    NSString *msgLengt = [NSString stringWithFormat:@"%ld", [soapMessage length]];
//    // 添加请求的详细信息，与请求报文前半部分的各字段对应
//    [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    [req addValue:msgLengt forHTTPHeaderField:@"Content-Length"];
//    // 设置请求行方法为POST，与请求报文第一行对应
//    [req setHTTPMethod:@"POST"];
//    // 将SOAP消息加到请求中
//    [req setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
//    return req;
//}


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
