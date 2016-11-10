//
//  TaskContentTableView.m
//  ETMX
//
//  Created by wenpq on 16/11/2.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "TaskContentTableView.h"
#import "ETMXTask.h"
#import "ETMXTableViewCell1.h"
#import "ETMXTableViewCell2.h"
#import "TaskSectionHeaderView.h"

#define CellUnFoldStateHeight               110.0f              //展开时cell的高度
#define CellFoldStateHeight                     45.0f               //折叠时cell的高度
#define SectionHeight                               50.0f               //section高度

@interface TaskContentTableView()
@property(nonatomic,strong) NSMutableArray *selectedSections;       //存储展开状态的section，数组中存储的事section
@property(nonatomic,strong) NSMutableArray *selectedCells;              //存储展开状态的cells，数组中存储的事cells

@end
@implementation TaskContentTableView
#pragma mark -- INIT
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

#pragma mark -- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mold.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.selectedSections containsObject:[NSNumber numberWithInteger:section]]) {
        //展开状态
        NSArray *arr = self.mold.dataSource[section];
        return arr.count;
    }else{
        //收缩状态
        return 0;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = self.mold.dataSource[indexPath.section];
    ETMXTask *curTask = arr[indexPath.row];
    if ([self.selectedCells containsObject:indexPath]) {
        //展开状态
        NSString *taskCell1ID= @"TaskCellSpreadID";
        ETMXTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:taskCell1ID];
        if (cell == nil) {
            cell = (ETMXTableViewCell1 *)[[NSBundle mainBundle] loadNibNamed:@"ETMXTableViewCell1" owner:self options:nil].lastObject;
        }
        cell.task =curTask;
        return cell;
    }else{
    //收缩状态
        NSString *taskCell2ID= @"TaskCellFoldID";
        ETMXTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:taskCell2ID];
        if (cell == nil) {
            cell = (ETMXTableViewCell2 *)[[NSBundle mainBundle] loadNibNamed:@"ETMXTableViewCell2" owner:self options:nil].lastObject;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        cell.task =curTask;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.selectedCells containsObject:indexPath]) {
        //展开状态下点击
        [self.selectedCells removeObject:indexPath];
    }else{
        [self.selectedCells addObject:indexPath];
    }
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.selectedCells containsObject:indexPath]) {
        //展开状态
        return CellUnFoldStateHeight;
    }
    return CellFoldStateHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SectionHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TaskSectionHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"TaskSectionHeaderView" owner:self options:nil].lastObject;
    NSArray *tasks = self.mold.dataSource[section];
    ETMXTask *curTask = tasks.firstObject;
    headerView.task = curTask;
    headerView.tag = section;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
    [headerView addGestureRecognizer:tapGesture];
    return headerView;
}

-(void)tapHandle:(UITapGestureRecognizer *)gesture{
    UIView *curHeaderView = gesture.view;
    NSInteger tag = curHeaderView.tag;
    if ([self.selectedSections containsObject:[NSNumber numberWithInteger:tag]]) {
        //头部展开状态
        [self.selectedSections removeObject:[NSNumber numberWithInteger:tag]];
    }else{
        [self.selectedSections addObject:[NSNumber numberWithInteger:tag]];
    }
    [self reloadSections:[NSIndexSet indexSetWithIndex:tag] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark-- INIT

-(EtmxMold *)mold{
    if (!_mold) {
        _mold = [[EtmxMold alloc] init];
    }
    return _mold;
}

-(NSMutableArray *)selectedSections{
    if (!_selectedSections) {
        _selectedSections = [[NSMutableArray alloc] init];
    }
    return _selectedSections;
}

-(NSMutableArray *)selectedCells{
    if (!_selectedCells) {
        _selectedCells = [[NSMutableArray alloc] init];
    }
    return _selectedCells;
}

-(void)reloadDataWithSortTasks:(NSArray *)sortTasks{
    [self.mold loadMoldWithTasks:sortTasks];
    [self reloadData];
    CGRect tempRect = self.frame;
    tempRect.size.height = self.contentSize.height;
    self.frame = tempRect;
    [self layoutIfNeeded];
}


@end