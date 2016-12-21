//
//  SelectTaskViewController.m
//  ETMX_1.2
//
//  Created by 杨香港 on 2016/12/19.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "SelectTaskViewController.h"

#import "InTableViewCell.h"
#define  SELECTTASK  @"SelectTaskViewController"

@interface SelectTaskViewController ()<UITableViewDelegate,UITableViewDataSource>
{
  __strong  NSArray * _dataSource;
    
}
@property (nonatomic,strong)ETMXTask * selectedTask;

@end

@implementation SelectTaskViewController

- (id) initWithTaskDataList:(NSArray *)dataList
{
    if (!self) {
        self = [super init];
    }
    _dataSource  = dataList;
    return  self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"InTableViewCell" bundle:nil]  forCellReuseIdentifier:SELECTTASK];
   // self.view.frame = CGRectMake(0, 0, self.view.frame.size., 400);
    //self.view.center = self.tableView.superview.center;
}



#pragma UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  _dataSource.count;
    
}


#pragma UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     InTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SELECTTASK forIndexPath:indexPath];
     [cell setTask:_dataSource[indexPath.row]];
      __weak typeof(self) weakSelf = self;
     cell.block = ^(ETMXTask *task){
         weakSelf.selectedTask = task;
     };
    return cell;
}


@end
