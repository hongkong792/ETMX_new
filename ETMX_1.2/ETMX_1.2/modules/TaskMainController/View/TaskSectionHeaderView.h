//
//  TaskSectionHeaderView.h
//  ETMX
//
//  Created by wenpq on 16/11/3.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETMXTask.h"
@interface TaskSectionHeaderView : UITableViewHeaderFooterView
/**任务对象*/
@property (nonatomic ,strong)ETMXTask*task;
@end
