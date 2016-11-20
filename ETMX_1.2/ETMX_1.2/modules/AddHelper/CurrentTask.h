//
//  CurrentTask.h
//  ETMX_1.2
//
//  Created by 文沛祺 on 16/11/20.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ETMXTask.h"
@interface CurrentTask : NSObject
+ (CurrentTask *)sharedManager;
@property (nonatomic,strong)ETMXTask * currentTask;
@property (nonatomic,strong)NSString * taskId;
@end
