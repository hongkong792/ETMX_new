//
//  SelectMachineViewController.h
//  ETMX_1.2
//
//  Created by yangxianggang on 17/5/4.
//  Copyright © 2017年 杨香港. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"

@interface SelectMachineViewController : UIViewController
@property (nonatomic,strong)id<SearchMachineDelegate>delegate;
@end
