//
//  MembersTableViewController.m
//  ETMX_1.2
//
//  Created by wenpq on 16/11/20.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "MembersTableViewController.h"

@interface MembersTableViewController ()

@end

@implementation MembersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menbersDataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *memberCellID = @"MEMBERCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:memberCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:memberCellID];
    }
    UserAccount *curAccount = self.menbersDataSource[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",curAccount.fullName];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.memberDelegate && [self.memberDelegate respondsToSelector:@selector(onSelctedMemeberWithIndex:)]) {
        [self.memberDelegate onSelctedMemeberWithIndex:indexPath.row];
    }
}

-(NSMutableArray<UserAccount *> *)menbersDataSource{
    if (_menbersDataSource == nil) {
        _menbersDataSource = [[NSMutableArray alloc] init];
    }
    return _menbersDataSource;
}
@end
