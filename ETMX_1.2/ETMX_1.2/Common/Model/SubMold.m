//
//  SubMold.m
//  ETMX_1.2
//
//  Created by wenpq on 16/12/17.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "SubMold.h"

@implementation SubMold

#pragma mark --INIT
-(NSMutableArray<ETMXTask *> *)tasks{
    if (_tasks == nil) {
        _tasks = [[NSMutableArray alloc] init];
    }
    return _tasks;
}

-(void)addNewTask:(ETMXTask *)task{
    if (![self.tasks containsObject:task]) {
        [self.tasks addObject:task];
    }
}
@end
