

//
//  CurrentTask.m
//  ETMX_1.2
//
//  Created by 文沛祺 on 16/11/20.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "CurrentTask.h"

@implementation CurrentTask
static NSString * _taskId;
+ (CurrentTask *)sharedManager
{
    static CurrentTask *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}
- (void)setTaskId:(NSString *)taskId
{
    
    _taskId = taskId;
}
- (NSString *)taskId
{    
    return _taskId;
}


@end
