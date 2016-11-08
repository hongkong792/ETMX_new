//
//  EtmxMold.m
//  ETMX
//
//  Created by wenpq on 16/11/3.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "EtmxMold.h"
@interface EtmxMold()
@property (nonatomic,strong) NSMutableArray *moldTitles;
@end

@implementation EtmxMold

-(void)loadMoldWithTasks:(NSArray *)tasks{
    [self.moldTitles removeAllObjects];
    [self.dataSource removeAllObjects];
    for (ETMXTask *task in tasks) {
        if (![_moldTitles containsObject:task.container]) {
            NSMutableArray *newArr = [[NSMutableArray alloc] init];
            [newArr addObject:task];
            [self.moldTitles addObject:task.container];
            [self.dataSource addObject:newArr];
        }else{
            NSInteger index = 0;
            for (NSInteger i =0; i<self.moldTitles.count; i++) {
                if ([task.container isEqualToString:self.moldTitles[i]]) {
                    index = i;
                    break;
                }
            }
            NSMutableArray *arr =  self.dataSource[index];
            [arr addObject:task];
        }
    }
}

-(NSMutableArray<NSMutableArray *> *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(NSMutableArray *)moldTitles{
    if (_moldTitles == nil) {
        _moldTitles = [[NSMutableArray alloc] init];
    }
    return _moldTitles;
}
@end
