//
//  TaskSectionHeaderView.m
//  ETMX
//
//  Created by wenpq on 16/11/3.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "TaskSectionHeaderView.h"

@interface TaskSectionHeaderView()
@property (strong, nonatomic) IBOutlet UILabel *containerPlace;
@property (strong, nonatomic) IBOutlet UILabel *containerCode;
@property (strong, nonatomic) IBOutlet UILabel *planStartDate;
@property (strong, nonatomic) IBOutlet UILabel *planEndDate;


@end
@implementation TaskSectionHeaderView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.containerPlace.text = Localized(@"mold code");
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
    [self.selectedImageView addGestureRecognizer:tapGesture];
    self.contentView.backgroundColor = [UIColor colorWithHex:0x45AEFE];
}

-(void)tapHandle:(UITapGestureRecognizer *)gesture{
    self.mold.isSelected =!self.mold.isSelected;
    if (self.block) {
        self.block(self.mold);
    }
}

-(void)setMold:(EtmxMold *)mold{
    _mold = mold;
    NSArray *subMolds = mold.subMolds;
    SubMold *subMold = subMolds[0];
    NSArray *tasks = subMold.tasks;
    ETMXTask *task = tasks[0];
    NSInteger count = 0;
    for (SubMold *s in subMolds) {
        count+=s.tasks.count;
    }
    self.containerCode.text = [NSString stringWithFormat:@"%@(%ld)",[task valueForKey:@"container"],(long)count];
    self.planStartDate.text = [task valueForKey:@"moldPlanStartDate"];
    self.planEndDate.text = [task valueForKey:@"moldPlanEndDate"];
    if (mold.isSelected) {
        self.selectedImageView.image = [UIImage imageNamed:@"selected_image_checkmark"];
    }else{
        self.selectedImageView.image = [UIImage imageNamed:@"selected_image_uncheckmark"];
    }
}

@end
