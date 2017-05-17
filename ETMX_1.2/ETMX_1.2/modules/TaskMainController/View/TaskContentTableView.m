//
//  OutTableView.m
//  ETMX_1.2
//
//  Created by wenpq on 16/12/17.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "TaskContentTableView.h"
#import "TaskSectionHeaderView.h"
#import "OutTableViewCell.h"

#define OutTableViewSectionHeight           50.0f
#define InTableViewSectionHeight            35.0f
#define InTableVeiwCellHeight               65.0f
@interface TaskContentTableView()<OutTableViewCellDelegate>
@property (nonatomic,strong) NSMutableArray<NSString *> *containers;//已存在的模具名数组


@property (nonatomic,weak) TaskSectionHeaderView *outHeaderView;
@end

@implementation TaskContentTableView
#pragma mark -- common
-(void)reloadWithTasks:(NSMutableArray<ETMXTask *> *)tasks{
    [self.molds removeAllObjects];
    [self.containers removeAllObjects];
    for (ETMXTask *task in tasks) {
        if ([self.containers containsObject:task.container]) {//已经创建了任务对应所在的模型
            NSInteger index = 0;
            for (NSInteger i = 0; i<self.containers.count; i++) {
                if ([task.container isEqualToString:self.containers[i]]) {
                    index = i;
                    break;
                }
            }
            EtmxMold *curMold = self.molds[index];
            [curMold addNewTask:task];
        }else{//未创建任务对应的所在的模型
            EtmxMold *newMold = [[EtmxMold alloc] init];
            [newMold addNewTask:task];
            [self.molds addObject:newMold];
            [self.containers addObject:task.container];
        }
    }
    [self reloadData];
}

-(void)handleTapSection:(UITapGestureRecognizer *)gesture{
    NSInteger tag = gesture.view.tag;
 
    if ([self.outOpens containsObject:[NSNumber numberWithInteger:tag]]) {//收起
        [self.outOpens removeObject:[NSNumber numberWithInteger:tag]];
        
    }else{
        //展开
        [self.outOpens addObject:[NSNumber numberWithInteger:tag]];
    }
    [self reloadSections:[NSIndexSet indexSetWithIndex:tag] withRowAnimation:UITableViewRowAnimationNone];
    if ([self.outOpens containsObject:[NSNumber numberWithInteger:tag]]) {
        [self.outHeaderView.arrowImageView setImage:[UIImage imageNamed:@"bottom.png"]];
    }else{
        [self.outHeaderView.arrowImageView setImage:[UIImage imageNamed:@"left2"]];
        
    }
}

#pragma mark -- INIT
-(NSMutableArray<EtmxMold *> *)molds{
    if (_molds == nil) {
        _molds = [[NSMutableArray alloc] init];
    }
    return _molds;
}

-(NSMutableArray<NSString *> *)containers{
    if (_containers == nil) {
        _containers = [[NSMutableArray alloc] init];
    }
    return _containers;
    
}
-(NSMutableArray *)outOpenIndexPaths{
    if (_outOpenIndexPaths == nil) {
        _outOpenIndexPaths = [[NSMutableArray alloc] init];
    }
    return _outOpenIndexPaths;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle =UITableViewCellSeparatorStyleNone;
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle =UITableViewCellSeparatorStyleNone;
    }
    return self;
}

-(NSMutableArray *)outOpens{
    if (_outOpens == nil) {
        _outOpens = [[NSMutableArray alloc] init];
    }
    return _outOpens;
}

#pragma mark -- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.molds.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    EtmxMold *curMold = self.molds[section];
    return curMold.subMolds.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"OutTableViewCell";
    OutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    EtmxMold *curMold = self.molds[indexPath.section];
    SubMold *curSubMold = curMold.subMolds[indexPath.row];
    cell.subMold = curSubMold;
    cell.indexPath = indexPath;
    cell.delegate =self;
   // cell.backgroundColor = [UIColor redColor];
 
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TaskSectionHeaderView *outHeaderView =[[NSBundle mainBundle] loadNibNamed:@"TaskSectionHeaderView" owner:self options:nil].lastObject;
    outHeaderView.mold = self.molds[section];
    outHeaderView.tag = section;
    self.outHeaderView = outHeaderView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapSection:)];
    tap.numberOfTapsRequired  = 1;
    [outHeaderView addGestureRecognizer:tap];
    outHeaderView.block = ^(EtmxMold *mold){
        for (SubMold *subMold in mold.subMolds) {
            subMold.isSelected = mold.isSelected;
            for (ETMXTask *task in subMold.tasks) {
                task.isSelected = subMold.isSelected;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGE_SELECTED_TASK_NUM" object:nil];
        });
    };
    return outHeaderView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.outOpens containsObject:[NSNumber numberWithInteger:indexPath.section]]) {
        EtmxMold *curMold = self.molds[indexPath.section];
        SubMold *curSubMold = curMold.subMolds[indexPath.row];
        NSInteger count =0;
        if ([self.outOpenIndexPaths containsObject:indexPath]) {
            count =curSubMold.tasks.count;
        }
        CGFloat height = InTableViewSectionHeight + InTableVeiwCellHeight * count;
        return height;
    }else{
        return 0.0f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return OutTableViewSectionHeight;
}

#pragma mark --OutTableViewCellDelegate
-(void)onTapIndexPath:(NSIndexPath *)indexPath{
    if ([self.outOpenIndexPaths containsObject:indexPath]) {
        [self.outOpenIndexPaths removeObject:indexPath];

    }else{//展开
        [self.outOpenIndexPaths addObject:indexPath];
    }
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    
    
    
    
}

-(void)onAllTaskSelected:(NSIndexPath *)indexPath{
    BOOL allSubMoldSelected = YES;
    EtmxMold *curMold = self.molds[indexPath.section];
    for (SubMold *curSubMold in curMold.subMolds) {
        if (!curSubMold.isSelected) {
            allSubMoldSelected = NO;
        }
    }
    curMold.isSelected = allSubMoldSelected;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    });
}
@end
