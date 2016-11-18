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
}

-(void)tapHandle:(UITapGestureRecognizer *)gesture{
    if (self.delegate  && [self.delegate respondsToSelector:@selector(selecteSectionWithTag:)]) {
        [self.delegate selecteSectionWithTag:self.tag];
    }
}


-(void)setTask:(ETMXTask *)task{
    self.containerCode.text = [task valueForKey:@"container"];
    self.planStartDate.text = [task valueForKey:@"planStartDate"];
    self.planEndDate.text = [task valueForKey:@"planEndDate"];
}

@end
