//
//  ExchangeOperatorViewController.h
//  ETMX_1.2
//
//  Created by wenpq on 16/11/20.
//  Copyright © 2016年 杨香港. All rights reserved.
//


#import <UIKit/UIKit.h>
typedef void(^popDismissBlock)();
typedef void(^refreshTableView)();
@interface ExchangeOperatorViewController : UIViewController
@property (nonatomic,strong) NSArray *selecedTasks;//被选的任务数组
@property (nonatomic,copy) popDismissBlock block;
@property (nonatomic,copy) refreshTableView refreshTableViewBlock;//刷新table
@end
