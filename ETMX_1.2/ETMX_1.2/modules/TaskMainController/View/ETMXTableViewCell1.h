//
//  ETMXTableViewCell1.h
//  ETMX
//
//  Created by wenpq on 16/11/4.
//  Copyright © 2016年 杨香港. All rights reserved.
//
@class ETMXTask;
@protocol ETXMTableViewCellDelegate <NSObject>
@optional
-(void)selecteCellWithTask:(ETMXTask *)task;

@end
#import <UIKit/UIKit.h>
#import "ETMXTask.h"
typedef NSString *(^taskNameSelecteBlock)();
@interface ETMXTableViewCell1 : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *taskView;
@property (nonatomic,strong)ETMXTask *task;
@property (nonatomic,weak)id<ETXMTableViewCellDelegate>cellDelegate;
@property (strong, nonatomic) IBOutlet UIImageView *selectedImageView1;
@property (strong, nonatomic) IBOutlet UIImageView *selectedImageView2;
@property (nonatomic,copy) taskNameSelecteBlock block;
@end
