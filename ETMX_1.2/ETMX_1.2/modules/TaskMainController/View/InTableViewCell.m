//
//  InTableViewCell.m
//  ETMX_1.2
//
//  Created by wenpq on 16/12/15.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "InTableViewCell.h"
@interface InTableViewCell()

//xib属性
@property (strong, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (strong, nonatomic) IBOutlet UITextField *taskNamePlace;
@property (strong, nonatomic) IBOutlet UITextField *taskStatusPlace;
@property (strong, nonatomic) IBOutlet UITextField *taskOperatorPlace;
@property (strong, nonatomic) IBOutlet UITextField *taskMachinePlace;
@property (strong, nonatomic) IBOutlet UITextField *actStartDatePlace;
@property (strong, nonatomic) IBOutlet UITextField *actFinishDatePlace;
@property (strong, nonatomic) IBOutlet UITextField *userTimePlace;
@property (strong, nonatomic) IBOutlet UITextField *actUseTimePlace;

@property (strong, nonatomic) IBOutlet UITextField *taskName;
@property (strong, nonatomic) IBOutlet UITextField *taskStatus;
@property (strong, nonatomic) IBOutlet UITextField *taskOperator;
@property (strong, nonatomic) IBOutlet UITextField *taskMachine;
@property (strong, nonatomic) IBOutlet UITextField *ActStartDate;
@property (strong, nonatomic) IBOutlet UITextField *actFinishDate;
@property (strong, nonatomic) IBOutlet UITextField *useTime;
@property (strong, nonatomic) IBOutlet UITextField *actUseTime;
@end

@implementation InTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.taskNamePlace.text = Localized(@"task name");
    self.taskStatusPlace.text = Localized(@"status");
    self.taskOperatorPlace.text = Localized(@"operator");
    self.taskMachinePlace.text = Localized(@"machine");
    self.actStartDatePlace.text =Localized(@"actual start date");
    self.actFinishDatePlace.text = Localized(@"actual end date");
    self.userTimePlace.text = Localized(@"used work hour");
    self.actUseTimePlace.text = Localized(@"actual work hour");
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.selectedImageView addGestureRecognizer:tap];
}

-(void)handleTap:(UITapGestureRecognizer *)gesture{
    self.task.isSelected = !self.task.isSelected;
    if (self.block) {
        self.block(self.task);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setTask:(ETMXTask *)task{
    _task = task;
    self.taskName.text = [task valueForKey:@"name"];
    self.taskStatus.text = [task valueForKey:@"status"];
    self.taskOperator.text = [task valueForKey:@"operatorMsg"];
    self.taskMachine.text = [task valueForKey:@"machineMsg"];
    self.ActStartDate.text =[task valueForKey:@"actualStartDate"];
    self.actFinishDate.text = [task valueForKey:@"actualEndDate"];
    self.useTime.text = [task valueForKey:@"usedWorkHour"];
    self.actUseTime.text = [task valueForKey:@"actualWorkHour"];
    if (task.isSelected) {
        self.selectedImageView.image = [UIImage imageNamed:@"selected_image_checkmark"];
    }else{
        self.selectedImageView.image = [UIImage imageNamed:@"selected_image_uncheckmark"];
    }
}

@end
