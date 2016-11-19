//
//  ETMXMachine.h
//  ETMX
//
//  Created by wenpq on 16/10/31.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtensionConfig.h"

@interface ETMXMachine : MJExtensionConfig

/**机床id*/
@property (nonatomic ,strong)NSString*machineID;

/**机床编号*/
@property (nonatomic ,strong)NSString*machineCode;

/**机床名称*/
@property (nonatomic ,strong)NSString*machineName;

/**机床型号*/
@property (nonatomic ,strong)NSString*machineModel;

@end
