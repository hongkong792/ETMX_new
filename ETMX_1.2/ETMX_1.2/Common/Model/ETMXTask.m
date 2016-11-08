//
//  ETMXTask.m
//  ETMX
//
//  Created by wenpq on 16/10/31.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "ETMXTask.h"

@implementation ETMXTask
-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self =[super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

@end
