//
//  MembersTableViewController.h
//  ETMX_1.2
//
//  Created by wenpq on 16/11/20.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAccount.h"
@protocol MembersTableViewDelegate <NSObject>

@optional
-(void)onSelctedMemeberWithIndex:(NSInteger)index;

@end
@interface MembersTableViewController : UITableViewController
@property (nonatomic,strong)NSMutableArray<UserAccount *> *menbersDataSource;
@property (nonatomic,weak)id<MembersTableViewDelegate> memberDelegate;
@end
