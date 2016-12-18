//
//  SubMold.h
//  ETMX_1.2
//
//  Created by wenpq on 16/12/17.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETMXTask.h"
@interface SubMold : NSObject
@property (nonatomic,strong)NSMutableArray<ETMXTask *> *tasks;
@property (nonatomic,assign)BOOL isSelected;
-(void)addNewTask:(ETMXTask *)task;
@end
