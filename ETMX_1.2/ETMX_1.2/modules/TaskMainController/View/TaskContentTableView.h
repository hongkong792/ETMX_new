//
//  OutTableView.h
//  ETMX_1.2
//
//  Created by wenpq on 16/12/17.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EtmxMold.h"
#import "ETMXTask.h"

@interface TaskContentTableView : UITableView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray<EtmxMold *>* molds;
@property (nonatomic,strong) NSMutableArray *outOpens;//记录外tableview被展开的section
@property (nonatomic,strong) NSMutableArray *outOpenIndexPaths;//记录展开的row
-(void)reloadWithTasks:(NSMutableArray<ETMXTask*> *)tasks;
@end
