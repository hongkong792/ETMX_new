//
//  TaskSectionHeaderView.h
//  ETMX
//
//  Created by wenpq on 16/11/3.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EtmxMold.h"
typedef void(^OutTableClickImageViewBlock)(EtmxMold *mold);

@interface TaskSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic ,strong)EtmxMold *mold;
@property (strong, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (nonatomic,copy) OutTableClickImageViewBlock block;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@end
