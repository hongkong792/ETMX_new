//
//  TaskSectionHeaderView.m
//  ETMX
//
//  Created by wenpq on 16/11/3.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "TaskSectionHeaderView.h"

@interface TaskSectionHeaderView()
@property (strong, nonatomic) IBOutlet UILabel *containerCode;
@property (strong, nonatomic) IBOutlet UILabel *planStartDate;

@property (strong, nonatomic) IBOutlet UILabel *planEndDate;


@end
@implementation TaskSectionHeaderView
-(void)setTask:(ETMXTask *)task{
    self.containerCode.text = [task valueForKey:@"container"];
    self.planStartDate.text = [task valueForKey:@"planStartDate"];
    self.planEndDate.text = [task valueForKey:@"planEndDate"];
}
@end
