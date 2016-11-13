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
-(void)selecteCellWithTask:(ETMXTask *)task status:(BOOL)isSelectd;

@end
#import <UIKit/UIKit.h>
#import "ETMXTask.h"

@interface ETMXTableViewCell1 : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *taskView;
@property (nonatomic,strong)ETMXTask *task;
@property (nonatomic,assign)BOOL cellSelected;
@property (nonatomic,weak)id<ETXMTableViewCellDelegate>cellDelegate;
@end
