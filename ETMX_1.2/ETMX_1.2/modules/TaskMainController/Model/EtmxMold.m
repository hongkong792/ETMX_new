//
//  EtmxMold.m
//  ETMX
//
//  Created by wenpq on 16/11/3.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "EtmxMold.h"

@interface EtmxMold()
@property (nonatomic,strong) NSMutableArray<NSString *> *subMoldTitles;
@end

@implementation EtmxMold

-(void)addNewTask:(ETMXTask *)task{
    if ([self.subMoldTitles containsObject:task.object]) {//已经创建任务对应的零件
        NSInteger index = 0;
        for (NSInteger i = 0; i<self.subMolds.count; i++) {
            if ([task.object isEqualToString:self.subMoldTitles[i]]) {
                index = i;
                break;
            }
        }
        SubMold *curSubMold = self.subMolds[index];
        [curSubMold addNewTask:task];
    }else{//未创建任务对应的零件
        SubMold *newSubMold = [[SubMold alloc] init];
        [newSubMold addNewTask:task];
        [self.subMolds addObject:newSubMold];
        [self.subMoldTitles addObject:task.object];
    }
}

-(NSMutableArray<SubMold *> *)subMolds{
    if (_subMolds == nil) {
        _subMolds = [[NSMutableArray alloc] init];
    }
    return _subMolds;
}

-(NSMutableArray<NSString *> *)subMoldTitles{
    if (_subMoldTitles == nil) {
        _subMoldTitles = [[NSMutableArray alloc] init];
    }
    return _subMoldTitles;
}
@end
