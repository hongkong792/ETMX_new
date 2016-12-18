//
//  EtmxMold.h
//  ETMX
//
//  Created by wenpq on 16/11/3.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETMXTask.h"
#import "SubMold.h"
@interface EtmxMold : NSObject
@property (nonatomic,strong) NSMutableArray<SubMold *>  *subMolds;
@property (nonatomic,assign) BOOL isSelected;
-(void)addNewTask:(ETMXTask *)task;
@end
