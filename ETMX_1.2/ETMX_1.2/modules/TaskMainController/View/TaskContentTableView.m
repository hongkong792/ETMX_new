//
//  TaskContentTableView.m
//  ETMX
//
//  Created by wenpq on 16/11/2.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "TaskContentTableView.h"
#import "ETMXTask.h"


#define CellUnFoldStateHeight               91.0f              //展开时cell的高度
#define CellFoldStateHeight                     45.0f               //折叠时cell的高度
#define SectionHeight                               50.0f               //section高度

@interface TaskContentTableView()
@property(nonatomic,strong) NSMutableArray *unfoldSections;       //存储展开状态的section，数组中存储的是section
@property(nonatomic,strong) NSMutableArray *unfoldCells;              //存储展开状态的cells，数组中存储的是cells



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
    if ([self.unfoldSections containsObject:[NSNumber numberWithInteger:section]]) {
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
    NSString *cellID = @"TaskCellSpreadID";
    ETMXTableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ETMXTableViewCell1" owner:self options:nil].lastObject;
    }
    if ([self.unfoldCells containsObject:indexPath]) {
        //展开状态
        [cell.taskView setHidden:NO];
    }else{
        [cell.taskView setHidden:YES];
    }
    cell.task = curTask;
    cell.cellDelegate = self;
    if ([self.selectedTasks containsObject:curTask]) {
        cell.selectedImageView1.image = [UIImage imageNamed:@"selected_image_checkmark"];
        cell.selectedImageView2.image = [UIImage imageNamed:@"selected_image_checkmark"];
    }else{
        cell.selectedImageView1.image = [UIImage imageNamed:@"selected_image_uncheckmark"];
        cell.selectedImageView2.image = [UIImage imageNamed:@"selected_image_uncheckmark"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.unfoldCells containsObject:indexPath]) {
        //展开状态下点击
        [self.unfoldCells removeObject:indexPath];
    }else{
        [self.unfoldCells addObject:indexPath];
    }
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.unfoldCells containsObject:indexPath]) {
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
    headerView.delegate = self;
    if ([self.selectedSections containsObject:[NSNumber numberWithInteger:section]]) {
        headerView.selectedImageView.image = [UIImage imageNamed:@"selected_image_checkmark"];
    }else{
        headerView.selectedImageView.image = [UIImage imageNamed:@"selected_image_uncheckmark"];
    }
    return headerView;
}

-(void)tapHandle:(UITapGestureRecognizer *)gesture{
    UIView *curHeaderView = gesture.view;
    NSInteger tag = curHeaderView.tag;
    if ([self.unfoldSections containsObject:[NSNumber numberWithInteger:tag]]) {
        //头部展开状态
        [self.unfoldSections removeObject:[NSNumber numberWithInteger:tag]];
    }else{
        [self.unfoldSections addObject:[NSNumber numberWithInteger:tag]];
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

-(NSMutableArray *)unfoldSections{
    if (!_unfoldSections) {
        _unfoldSections = [[NSMutableArray alloc] init];
    }
    return _unfoldSections;
}

-(NSMutableArray *)unfoldCells{
    if (!_unfoldCells) {
        _unfoldCells = [[NSMutableArray alloc] init];
    }
    return _unfoldCells;
}

-(NSMutableArray *)selectedSections{
    if (_selectedSections == nil) {
        _selectedSections = [[NSMutableArray alloc] init];
    }
    return _selectedSections;
}

-(NSMutableArray *)selectedTasks{
    if (_selectedTasks == nil) {
        _selectedTasks = [[NSMutableArray alloc] init];
    }
    return _selectedTasks;
}

-(void)reloadDataWithSortTasks:(NSArray *)sortTasks{
    [self.mold loadMoldWithTasks:sortTasks];
    [self reloadData];
}

#pragma mark -- TaskSectionHeaderDelegate
-(void)selecteSectionWithTag:(NSInteger)tag{
    if ([self.selectedSections containsObject:[NSNumber numberWithInteger:tag]]) {
        [self.selectedSections removeObject:[NSNumber numberWithInteger:tag]];
        for (ETMXTask *task in self.mold.dataSource[tag]) {
            [self.selectedTasks removeObject:task];
        }
    }else{
        [self.unfoldSections addObject:[NSNumber numberWithInteger:tag]];
        [self.selectedSections addObject:[NSNumber numberWithInteger:tag]];
        for (ETMXTask *task in self.mold.dataSource[tag]) {
            [self.selectedTasks addObject:task];
        }
    }
    [self reloadData];
}

-(void)selecteCellWithTask:(ETMXTask *)task{
    if ([self.selectedTasks containsObject:task]) {
        [self.selectedTasks removeObject:task];
    }else{
        [self.selectedTasks addObject:task];
    }
    [self reloadData];
}

@end
