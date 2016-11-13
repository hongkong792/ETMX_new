//
//  TaskSectionHeaderView.h
//  ETMX
//
//  Created by wenpq on 16/11/3.
//  Copyright © 2016年 杨香港. All rights reserved.
//

@protocol TaskSectionHeaderDelegate <NSObject>

@optional
-(void)selecteSectionWithTag:(NSInteger)tag status:(BOOL)isSelected;

@end
#import <UIKit/UIKit.h>
#import "ETMXTask.h"

@interface TaskSectionHeaderView : UITableViewHeaderFooterView
/**任务对象*/
@property (nonatomic ,strong)ETMXTask*task;
@property (nonatomic,assign)BOOL sectionIsSelected;
@property (nonatomic,weak)id<TaskSectionHeaderDelegate>delegate;
@end
