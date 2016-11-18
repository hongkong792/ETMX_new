//
//  TaskSectionHeaderView.h
//  ETMX
//
//  Created by wenpq on 16/11/3.
//  Copyright © 2016年 杨香港. All rights reserved.
//

@protocol TaskSectionHeaderDelegate <NSObject>

@optional
-(void)selecteSectionWithTag:(NSInteger)tag;

@end
#import <UIKit/UIKit.h>
#import "ETMXTask.h"

@interface TaskSectionHeaderView : UITableViewHeaderFooterView
/**任务对象*/
@property (nonatomic ,strong)ETMXTask*task;
@property (nonatomic,weak)id<TaskSectionHeaderDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIImageView *selectedImageView;
@end
