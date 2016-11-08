//
//  EtmxMold.h
//  ETMX
//
//  Created by wenpq on 16/11/3.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETMXTask.h"
//typedef enum : NSUInteger {
//    NewMold,                         //新模
//    ChangeMold,                  //改模
//    Electrode,                          //铜公
//} TaskType;
////模具类型
//typedef enum : NSUInteger {
//    TaskStateReleased,                      //未开始
//    TaskStateInwork,                           //正在进行
//    TaskStateStopped,                       //暂停中
//    TaskStatecompleted,                  //已完成
//    TaskSteteOther,                             //其他类型
//} TaskState;
@interface EtmxMold : NSObject
///**
// *  模具类型
// */
//@property (nonatomic,assign)TaskType taskType;
///**
// *  模具状态
// */
//@property (nonatomic,assign)TaskState taskState;
/**
 *  数据源，数据源的内容是数组，内数组中是ETMXTask对象
 */
@property (nonatomic,strong) NSMutableArray<NSMutableArray *>  *dataSource;
-(void)loadMoldWithTasks:(NSArray *)tasks;
@end
