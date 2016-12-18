//
//  InTableViewHeaderView.h
//  ETMX_1.2
//
//  Created by wenpq on 16/12/17.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ETMXTask.h"
#import "SubMold.h"
typedef void(^InTableClickImageViewBlock)(SubMold *subMold);
@interface InTableViewHeaderView : UITableViewHeaderFooterView
@property (strong, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (strong, nonatomic) IBOutlet UILabel *objectPlaceLabel;
@property (strong, nonatomic) IBOutlet UILabel *objectLabel;
@property (strong, nonatomic) IBOutlet UILabel *objectNamePlaceLabel;
@property (strong, nonatomic) IBOutlet UILabel *objcectNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *objectStatusPlaceLabel;
@property (strong, nonatomic) IBOutlet UILabel *objectStatusLabel;

@property (nonatomic,copy)InTableClickImageViewBlock block;
@property (nonatomic,strong) SubMold *subMold;

@end
