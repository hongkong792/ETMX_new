//
//  CheckNetWorkerTool.h
//  ETMX_1.2
//
//  Created by 杨香港 on 2016/11/12.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPSessionManager.h"

@interface CheckNetWorkerTool : AFHTTPSessionManager
+ (instancetype)sharedManager;
- (BOOL)isNetWorking;
@end
