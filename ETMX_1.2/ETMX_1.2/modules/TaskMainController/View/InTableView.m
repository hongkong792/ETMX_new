//
//  InTableView.m
//  ETMX_1.2
//
//  Created by wenpq on 16/12/17.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "InTableView.h"
#import "InTableViewCell.h"
#import "InTableViewHeaderView.h"
#define IntableViewHeaderHeight     35.0f
#define IntableViewCellHeight       65.0f
#define IntableViewCellHeightFold   0.0f

@interface InTableView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation InTableView

#pragma INIT
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataSource:(NSMutableArray *)dataSource{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource =self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.scrollEnabled = NO;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.delegate = self;
        self.dataSource =self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.scrollEnabled = NO;
    }
    return self;
}

#pragma mark -- common
-(void)handleTapSectionInTable:(UITapGestureRecognizer *)gesture{
    if (self.inTableViewDelegate && [self.inTableViewDelegate respondsToSelector:@selector(onTapInTableView)]) {
        [self.inTableViewDelegate onTapInTableView];
    }
}
#pragma mark --UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *tasks = self.subMold.tasks;
    return tasks.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"InTableViewCell";
    InTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSArray *tasks = self.subMold.tasks;
    cell.task = tasks[indexPath.row];
    cell.block = ^(ETMXTask *task){
        BOOL allSelected = YES;
        for (ETMXTask *curTask in self.subMold.tasks) {
            if (!curTask.isSelected) {
                allSelected = NO;
            }
        }
        self.subMold.isSelected = allSelected;
        if (self.inTableViewDelegate && [self.inTableViewDelegate respondsToSelector:@selector(onAllTaskSelected)]) {
            [self.inTableViewDelegate onAllTaskSelected];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_SELECTED_TASK_NUM" object:nil];
        });
    };
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    InTableViewHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"InTableViewHeaderView" owner:self options:nil].lastObject;
    headerView.subMold = self.subMold;
    headerView.contentView.backgroundColor = [UIColor colorWithRed:0xBC/255.0 green:0xBC/255.0 blue:0xBC/255.0 alpha:1.0];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapSectionInTable:)];
    [headerView addGestureRecognizer:tap];
    headerView.block =^(SubMold *subMold){
        for (ETMXTask *task in subMold.tasks) {
            task.isSelected = subMold.isSelected;
        }
        if (self.inTableViewDelegate && [self.inTableViewDelegate respondsToSelector:@selector(onAllTaskSelected)]) {
            [self.inTableViewDelegate onAllTaskSelected];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_SELECTED_TASK_NUM" object:nil];
        });
    };
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return IntableViewHeaderHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return IntableViewCellHeight;
}
@end
