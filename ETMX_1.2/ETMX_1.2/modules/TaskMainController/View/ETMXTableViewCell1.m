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

@property (strong, nonatomic) IBOutlet UILabel *taskCodePlace;
@property (strong, nonatomic) IBOutlet UILabel *objectNamePlace;
@property (strong, nonatomic) IBOutlet UILabel *statusPlace;
@property (strong, nonatomic) IBOutlet UITextField *taskNamePlace;
@property (strong, nonatomic) IBOutlet UITextField *status2Place;
@property (strong, nonatomic) IBOutlet UITextField *operatorPlace;
@property (strong, nonatomic) IBOutlet UITextField *machinePlace;
@property (strong, nonatomic) IBOutlet UITextField *actStartDatePlace;
@property (strong, nonatomic) IBOutlet UITextField *actEneDatePlace;
@property (strong, nonatomic) IBOutlet UITextField *workHourPlace;
@property (strong, nonatomic) IBOutlet UITextField *actWorkHourPlace;
@property (strong, nonatomic) IBOutlet UIImageView *selectedImageView1;
@property (strong, nonatomic) IBOutlet UIImageView *selectedImageView2;

@end

@implementation ETMXTableViewCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.taskCodePlace.text =Localized(@"part code") ;
    self.objectNamePlace.text =Localized(@"part name");
    self.statusPlace.text = Localized(@"status");
    self.taskNamePlace.text = Localized(@"task name");
    self.status2Place.text = Localized(@"status");
    self.operatorPlace.text = Localized(@"operator");
    self.machinePlace.text = Localized(@"machine");
    self.actStartDatePlace.text = Localized(@"actual start date");
    self.actEneDatePlace.text = Localized(@"actual end date");
    self.workHourPlace.text = Localized(@"used work hour");
    self.actWorkHourPlace.text = Localized(@"actual work hour");
    UITapGestureRecognizer *tapGesture= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
    [self.selectedImageView1 addGestureRecognizer:tapGesture];
    [self.selectedImageView2 addGestureRecognizer:tapGesture];
}

-(void)tapHandle:(UITapGestureRecognizer *)gesture{
    self.cellSelected = !self.cellSelected;
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(selecteCellWithTask:status:)]) {
        [self.cellDelegate selecteCellWithTask:self.task status:self.cellSelected];
    }
    self.selectedImageView1.image = self.cellSelected?[UIImage imageNamed:@"selected_image_checkmark"]:[UIImage imageNamed:@"selected_image_uncheckmark"];
    self.selectedImageView2.image = self.cellSelected?[UIImage imageNamed:@"selected_image_checkmark"]:[UIImage imageNamed:@"selected_image_uncheckmark"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
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
