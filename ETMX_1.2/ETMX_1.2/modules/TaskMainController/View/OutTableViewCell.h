//
//  OutTableViewCell.h
//  ETMX_1.2
//
//  Created by wenpq on 16/12/15.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InTableView.h"
#import "SubMold.h"

@protocol OutTableViewCellDelegate <NSObject>

@optional
-(void)onTapIndexPath:(NSIndexPath *)indexPath;

-(void)onAllTaskSelected:(NSIndexPath *)indexPath;

@end
@interface OutTableViewCell : UITableViewCell<InTableViewDelegate>
@property (strong, nonatomic) IBOutlet InTableView *inTableView;
@property (nonatomic,strong) SubMold *subMold;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,weak)id<OutTableViewCellDelegate>delegate;
@end
