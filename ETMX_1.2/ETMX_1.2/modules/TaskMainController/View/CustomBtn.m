//
//  CustomBtn.m
//  ETMX
//
//  Created by wenpq on 16/11/5.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "CustomBtn.h"

@implementation CustomBtn

-(void)layoutSubviews{
    [super layoutSubviews];
    self.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    [self.layer setBorderWidth:1];
    [self.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:5];
}

@end
