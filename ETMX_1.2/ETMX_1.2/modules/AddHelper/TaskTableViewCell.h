//
//  TaskTableViewCell.h
//  ETMX_1.2
//
//  Created by 杨香港 on 2016/11/19.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *taskObject;
@property (strong, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *startLabel;

@end
