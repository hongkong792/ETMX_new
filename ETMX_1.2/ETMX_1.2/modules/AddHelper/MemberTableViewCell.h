//
//  MemberTableViewCell.h
//  ETMX_1.2
//
//  Created by 杨香港 on 2016/11/19.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *propertyLabel;
@property (strong, nonatomic) IBOutlet UILabel *userTimeLabel;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) IBOutlet UIButton *pauseBtn;
@property (strong, nonatomic) IBOutlet UIButton *finishBtn;

@end
