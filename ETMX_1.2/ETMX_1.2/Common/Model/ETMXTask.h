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
@property (nonatomic ,strong)NSString*id;

/**任务编号*/
@property (nonatomic ,strong)NSString*code;

/**任务名称*/
@property (nonatomic ,strong)NSString*name;

/**任务对象*/
@property (nonatomic ,strong)NSString*object;

/**任务对象名称*/
@property (nonatomic ,strong)NSString*objectName;

/**任务对象图片地址*/
@property (nonatomic ,strong)NSString*objectImagePath;

/**任务所在容器*/
@property (nonatomic ,strong)NSString*container;

/**任务状态*/
@property (nonatomic ,strong)NSString*status;

/**计划开始时间*/
@property (nonatomic ,strong)NSString*planStartDate;

/**计划结束时间*/
@property (nonatomic ,strong)NSString*planEndDate;

/**实际开始时间*/
@property (nonatomic ,strong)NSString*actualStartDate;

/**实际结束时间*/
@property (nonatomic ,strong)NSString*actualEndDate;

/**发布时间*/
@property (nonatomic ,strong)NSString*releaseTime;

/**realFlow*/
@property (nonatomic ,strong)NSString*realFlow;

/**角色*/
@property (nonatomic ,strong)NSString*role;

/**责任人*/
@property (nonatomic ,strong)NSString*owner;

/**<#arg#>*/
@property (nonatomic ,strong)NSString*moldPlanStartDate;

/**<#arg#>*/
@property (nonatomic ,strong)NSString*moldPlanEndDate;

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
@property (nonatomic ,strong)NSString*QC;

/**任务二维码图片地址*/
@property (nonatomic ,strong)NSString*barCodePath;

/**备注*/
@property (nonatomic ,strong)NSString*remark;

/**<#arg#>*/
@property (nonatomic ,strong)NSString*usedWorkHour;

/**<#arg#>*/
@property (nonatomic ,strong)NSString*actualWorkHour;

/**<#arg#>*/
@property (nonatomic ,strong)NSString*groupAttr;

/**<#arg#>*/
@property (nonatomic ,strong)NSString*key;

@property (nonatomic,assign)BOOL isSelected;

-(instancetype)initWithDic:(NSDictionary *)dic;

@end
