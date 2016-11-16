//
//  CheckNetWorkerTool.m
//  ETMX_1.2
//
//  Created by 杨香港 on 2016/11/12.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "CheckNetWorkerTool.h"

@interface CheckNetWorkerTool()

@end
static  BOOL _staus  = YES;
@implementation CheckNetWorkerTool

+ (instancetype)sharedManager {
    static id instance;
//    static dispatch_once_t onceToken;
//    
//    dispatch_once(&onceToken, ^{
//        
//    });
    if (instance != nil) {
        instance = nil;
    }
        _staus  = YES;
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:ADRESSIP];
    instance  = [instance initWithBaseURL:[NSURL URLWithString:url]];
    instance = [instance init];
    return instance;
}

- (instancetype)init {
    if ((self = [super init])) {
        

        // 设置超时时间，afn默认是60s
        self.requestSerializer.timeoutInterval = 30;
        // 响应格式添加text/plain
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
        // 监听网络状态,每当网络状态发生变化就会调用此block
        __weak typeof(self) weakSelf =self;
        [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusNotReachable:     // 无连线
                    NSLog(@"AFNetworkReachability Not Reachable");

                    _staus = NO;
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                    NSLog(@"AFNetworkReachability Reachable via WWAN");
   
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi: // WiFi
                    NSLog(@"AFNetworkReachability Reachable via WiFi");

                    _staus = YES;
                    break;
                case AFNetworkReachabilityStatusUnknown:          // 未知网络
                default:

                    _staus = NO;
                    break;
            }
        }];
        // 开始监听
        [self.reachabilityManager startMonitoring];
    }
    return self;
}

- (BOOL)isNetWorking
{
//    if (_staus == NO) {
//        return NO;
//    }else if(_staus == YES){
//        return YES;
//    }
    return YES;
}


@end
