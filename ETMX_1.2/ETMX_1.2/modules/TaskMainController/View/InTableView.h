//
//  InTableView.h
//  ETMX_1.2
//
//  Created by wenpq on 16/12/17.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETMXTask.h"
#import "SubMold.h"
@protocol InTableViewDelegate <NSObject>

@optional
-(void)onTapInTableView;

-(void)onAllTaskSelected;
@end

@interface InTableView : UITableView
@property (nonatomic,strong) SubMold *subMold;
@property (nonatomic,weak)id<InTableViewDelegate>inTableViewDelegate;
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style dataSource:(NSMutableArray *)dataSource;
@end
