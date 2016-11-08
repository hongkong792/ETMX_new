//
//  ETMXTableViewCell1.m
//  ETMX
//
//  Created by wenpq on 16/11/4.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "ETMXTableViewCell1.h"

@interface ETMXTableViewCell1()
@property (strong, nonatomic) IBOutlet UILabel *taskCode;
@property (strong, nonatomic) IBOutlet UILabel *objectName;
@property (strong, nonatomic) IBOutlet UILabel *status;


@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *state2;
@property (strong, nonatomic) IBOutlet UITextField *operatorMsg;
@property (strong, nonatomic) IBOutlet UITextField *machine;
@property (strong, nonatomic) IBOutlet UITextField *actualStartDate;
@property (strong, nonatomic) IBOutlet UITextField *actualEndDate;
@property (strong, nonatomic) IBOutlet UITextField *usedWorkHour;
@property (strong, nonatomic) IBOutlet UITextField *actualWorkHour;


@end

@implementation ETMXTableViewCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setTask:(ETMXTask *)task{
    self.taskCode.text = [task valueForKey:@"code"];
    self.objectName.text = [task valueForKey:@"objectName"];
    self.status.text = [task valueForKey:@"status"];
    self.name.text = [task valueForKey:@"name"];
    self.state2.text = [task valueForKey:@"status"];
    self.operatorMsg.text = [task valueForKey:@"operatorMsg"];
    self.machine.text = [task valueForKey:@"machine"];
    self.actualStartDate.text = [task valueForKey:@"actualStartDate"];
    self.actualEndDate.text = [task valueForKey: @"actualEndDate"];
    self.usedWorkHour.text = [task valueForKey:@"usedWorkHour"];
    self.actualWorkHour.text = [task valueForKey:@"actualWorkHour"];
}

@end
