//
//  InTableViewCell.h
//  ETMX_1.2
//
//  Created by wenpq on 16/12/15.
//  Copyright © 2016年 杨香港. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ETMXTask.h"
typedef void(^TaskClickImageViewBlock)(ETMXTask *task);
@interface InTableViewCell : UITableViewCell

@property (nonatomic,assign)BOOL isSelectedInTable;
@property (nonatomic,strong)ETMXTask *task;
@property (nonatomic,copy)TaskClickImageViewBlock block;
@end
