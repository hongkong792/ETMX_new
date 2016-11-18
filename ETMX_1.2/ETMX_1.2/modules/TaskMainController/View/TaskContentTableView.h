//
//  TaskContentTableView.h
//  ETMX
//
//  Created by wenpq on 16/11/2.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EtmxMold.h"
#import "ETMXTableViewCell1.h"
#import "TaskSectionHeaderView.h"
@interface TaskContentTableView : UITableView<UITableViewDataSource,UITableViewDelegate,TaskSectionHeaderDelegate,ETXMTableViewCellDelegate>
@property (nonatomic,strong) EtmxMold *mold;//数据源
-(void)reloadDataWithSortTasks:(NSArray *)sortTasks;
@property (nonatomic,strong) NSMutableArray *selectedTasks;         //被勾选的任务
@property (nonatomic,strong) NSMutableArray *selectedSections;      //被勾选的section
@end
