//
//  ETMXTask.h
//  ETMX
//
//  Created by wenpq on 16/10/31.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <Foundation/Foundation.h>
//任务模型
@interface ETMXTask : NSObject
/**任务id*/
@property (nonatomic ,strong)NSString*taskID;

/**任务编号*/
@property (nonatomic ,strong)NSString*taskCode;

/**任务名称*/
@property (nonatomic ,strong)NSString*taskName;

/**任务对象*/
@property (nonatomic ,strong)NSString*taskObject;

/**任务对象名称*/
@property (nonatomic ,strong)NSString*taskObjectName;

/**任务对象图片地址*/
@property (nonatomic ,strong)NSString*taskObjectImagePath;

/**任务所在容器*/
@property (nonatomic ,strong)NSString*container;

/**任务状态*/
@property (nonatomic ,strong)NSString*state;

/**计划开始时间*/
@property (nonatomic ,strong)NSString*planStartDate;

/**计划结束时间*/
@property (nonatomic ,strong)NSString*planEndDate;

/**实际开始时间*/
@property (nonatomic ,strong)NSString*actualStartDate;

/**实际结束时间*/
@property (nonatomic ,strong)NSString*actualEneDate;

/**发布时间*/
@property (nonatomic ,strong)NSString*releseTime;

/**角色*/
@property (nonatomic ,strong)NSString*role;

/**责任人*/
@property (nonatomic ,strong)NSString*ower;

/**机床*/
@property (nonatomic ,strong)NSString*machine;

/**任务类型*/
@property (nonatomic ,strong)NSString*type;

/**提交者*/
@property (nonatomic ,strong)NSString*submitter;

/**是否执行*/
@property (nonatomic ,strong)NSString*execute;      //是:1;否0

/**是否执行外援*/
@property (nonatomic ,strong)NSString*support;      //是:1;否0

/**操作者信息*/
@property (nonatomic ,strong)NSString*operatorMsg;

/**机床信息*/
@property (nonatomic ,strong)NSString*machineMsg;

/**是否失败*/
@property (nonatomic ,strong)NSString*isQC;

/**任务二维码图片地址*/
@property (nonatomic ,strong)NSString*barCodePath;

/**备注*/
@property (nonatomic ,strong)NSString*remark;

@end
