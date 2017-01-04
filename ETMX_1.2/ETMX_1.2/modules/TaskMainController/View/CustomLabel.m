//
//  CustomLabel.m
//  ETMX_1.2
//
//  Created by wenpq on 17/1/4.
//  Copyright © 2017年 杨香港. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel
-(void)layoutSubviews{
    [super layoutSubviews];
    self.layer.borderColor = [[UIColor grayColor]CGColor];
    
    self.layer.borderWidth = 0.5f;
    
    self.layer.masksToBounds = YES;
}
@end
