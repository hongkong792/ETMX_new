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
@property (strong, nonatomic) IBOutlet UIImageView *selectedImageView;


@end
@implementation TaskSectionHeaderView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.containerPlace.text = Localized(@"mold code");
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
    [self.selectedImageView addGestureRecognizer:tapGesture];
}

-(void)tapHandle:(UITapGestureRecognizer *)gesture{
    self.sectionIsSelected = !self.sectionIsSelected;
    NSInteger section =  self.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(selecteSectionWithTag:status:)]) {
        [self.delegate selecteSectionWithTag:section status:self.sectionIsSelected];
    }
    self.selectedImageView.image = self.sectionIsSelected?[UIImage imageNamed:@"selected_image_checkmark"]:[UIImage imageNamed:@"selected_image_uncheckmark"];
}


-(void)setTask:(ETMXTask *)task{
    self.containerCode.text = [task valueForKey:@"container"];
    self.planStartDate.text = [task valueForKey:@"planStartDate"];
    self.planEndDate.text = [task valueForKey:@"planEndDate"];
}

@end
