//
//  ETMXTableViewCell1.h
//  ETMX
//
//  Created by wenpq on 16/11/4.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETMXTask.h"
@interface ETMXTableViewCell1 : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *taskView;
@property (nonatomic,strong)ETMXTask *task;

@end
