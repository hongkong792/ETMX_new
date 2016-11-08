//
//  TaskContentTableView.h
//  ETMX
//
//  Created by wenpq on 16/11/2.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EtmxMold.h"
@interface TaskContentTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) EtmxMold *mold;//数据源
-(void)reloadDataWithSortTasks:(NSArray *)sortTasks;
@end
