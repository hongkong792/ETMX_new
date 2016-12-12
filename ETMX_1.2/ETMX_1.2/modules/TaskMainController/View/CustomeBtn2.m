//
//  CustomeBtn2.m
//  ETMX_1.2
//
//  Created by wenpq on 16/12/3.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "CustomeBtn2.h"


@implementation CustomeBtn2
-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect = self.frame;
    self.frame = CGRectMake(rect.origin.x, rect.origin.y, 40, 60);
    CGRect tempImageFrame = self.imageView.frame;
    self.imageView.frame = CGRectMake(0, 0, tempImageFrame.size.width,tempImageFrame.size.height);
    self.titleLabel.frame = CGRectMake(0, 40, 40, 60-40);
}
    

@end
