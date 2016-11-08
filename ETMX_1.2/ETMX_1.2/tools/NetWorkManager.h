//
//  NetWorkManager.h
//  ETMX
//
//  Created by wenpq on 16/10/30.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "XMLReader.h"

//成功回调
typedef void (^HttpSuccess)(id data);
//失败回调
typedef void (^HttpFailure)(NSError *error);

@interface NetWorkManager : NSObject<NSURLConnectionDelegate>
@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSMutableString *soapResults;
@property (strong, nonatomic) NSXMLParser *xmlParser;
@property (nonatomic) BOOL elementFound;
@property (strong, nonatomic) NSString *matchingElement;
@property (strong, nonatomic) NSURLConnection *conn;

/**
 *  soap请求
 *
 *  @param paramters 请求参数数组，例如@[@"admin",@"admin"]
 *  @param success   请求成功回调
 *  @param failure   请求失败回调
 */
+(void)sendRequestWithParameters:(NSArray *)paramters  url:(NSString *)urlStr method:(NSString *)methodName success:(HttpSuccess)success failure:(HttpFailure)failure;


//get请求
+(void)getWithUrlString:(NSString *)urlString success:(HttpSuccess)success failure:(HttpFailure)failure;

//post请求
+(void)postWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure;

@end
