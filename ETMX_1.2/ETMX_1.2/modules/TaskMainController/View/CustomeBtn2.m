//
//  CustomeBtn2.m
//  ETMX_1.2
//
//  Created by wenpq on 16/12/3.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "CustomeBtn2.h"

#define ImageViewAndLabelMargin     10

@implementation CustomeBtn2

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect rect = self.frame;
    CGRect tempImageViewRect = self.imageView.frame;
    CGRect tempLabelRect = self.titleLabel.frame;
    CGFloat width = tempImageViewRect.size.width>tempLabelRect.size.width?tempImageViewRect.size.width:tempLabelRect.size.width;
    CGFloat height = tempLabelRect.size.height + tempImageViewRect.size.height;
    self.frame = CGRectMake(rect.origin.x, rect.origin.y,width+5 , height +ImageViewAndLabelMargin);
    self.imageView.frame = CGRectMake(0, 0, 32, 32);
    self.titleLabel.frame = CGRectMake(0, 32, width+5,height - 32);
}

@end
