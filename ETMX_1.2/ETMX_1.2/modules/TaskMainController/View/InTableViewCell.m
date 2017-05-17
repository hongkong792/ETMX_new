//
//  InTableViewCell.m
//  ETMX_1.2
//
//  Created by wenpq on 16/12/15.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "InTableViewCell.h"
#import "CustomLabel.h"
@interface InTableViewCell()

//xib属性
@property (strong, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (strong, nonatomic) IBOutlet CustomLabel *taskNamePlace;
@property (strong, nonatomic) IBOutlet CustomLabel *taskStatusPlace;
@property (strong, nonatomic) IBOutlet CustomLabel *taskOperatorPlace;
@property (strong, nonatomic) IBOutlet CustomLabel *taskMachinePlace;
@property (strong, nonatomic) IBOutlet CustomLabel *actStartDatePlace;
@property (strong, nonatomic) IBOutlet CustomLabel *actFinishDatePlace;
@property (strong, nonatomic) IBOutlet CustomLabel *userTimePlace;
@property (strong, nonatomic) IBOutlet CustomLabel *actUseTimePlace;

@property (strong, nonatomic) IBOutlet CustomLabel *taskName;
@property (strong, nonatomic) IBOutlet CustomLabel *taskStatus;
@property (strong, nonatomic) IBOutlet CustomLabel *taskOperator;
@property (strong, nonatomic) IBOutlet CustomLabel *taskMachine;
@property (strong, nonatomic) IBOutlet CustomLabel *ActStartDate;
@property (strong, nonatomic) IBOutlet CustomLabel *actFinishDate;
@property (strong, nonatomic) IBOutlet CustomLabel *useTime;
@property (strong, nonatomic) IBOutlet CustomLabel *actUseTime;
@end

@implementation InTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.taskNamePlace.text = Localized(@"task name");
    self.taskNamePlace.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
       self.taskStatusPlace.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    self.taskOperatorPlace.text = Localized(@"operator");
       self.taskOperatorPlace.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    self.taskMachinePlace.text = Localized(@"machine");
       self.taskMachinePlace.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    self.actStartDatePlace.text =Localized(@"actual start date");
       self.actStartDatePlace.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    self.actFinishDatePlace.text = Localized(@"actual end date");
       self.actFinishDatePlace.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    self.userTimePlace.text = Localized(@"used work hour");
       self.userTimePlace.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    self.actUseTimePlace.text = Localized(@"actual work hour");
       self.actUseTimePlace.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.selectedImageView addGestureRecognizer:tap];
    self.backgroundColor = [UIColor colorWithHex:0xFFFFFF] ;
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
        self.taskName.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    self.taskStatus.text = [task valueForKey:@"status"];
        self.taskStatus.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    self.taskOperator.text = [task valueForKey:@"operatorMsg"];
        self.taskOperator.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    self.taskMachine.text = [task valueForKey:@"machineMsg"];
        self.taskMachine.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    self.ActStartDate.text =[task valueForKey:@"actualStartDate"];
        self.ActStartDate.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    self.actFinishDate.text = [task valueForKey:@"actualEndDate"];
        self.actFinishDate.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    self.useTime.text = [task valueForKey:@"usedWorkHour"];
        self.useTime.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    self.actUseTime.text = [task valueForKey:@"actualWorkHour"];
        self.actUseTime.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    if (task.isSelected) {
        self.selectedImageView.image = [UIImage imageNamed:@"selected_image_checkmark"];
    }else{
        self.selectedImageView.image = [UIImage imageNamed:@"selected_image_uncheckmark"];
    }
}


@end
