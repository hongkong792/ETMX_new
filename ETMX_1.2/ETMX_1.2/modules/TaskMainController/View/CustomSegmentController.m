//
//  CustomSegmentController.m
//  ETMX
//
//  Created by wenpq on 16/11/5.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "CustomSegmentController.h"

@implementation CustomSegmentController

-(void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor =[UIColor whiteColor];
    [self.layer setMasksToBounds:YES];
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1;
    [self.layer setCornerRadius:8];
    NSDictionary * selectedTextAttr = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]};
    [self setTitleTextAttributes:selectedTextAttr forState:UIControlStateSelected];
    NSDictionary * unselectedTextAttr = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]};
    [self setTitleTextAttributes:unselectedTextAttr forState:UIControlStateNormal];
    
}
@end


//self.segmentC.tintColor = YJ_COLOR(0xd3e6f7);    self.segmentC.backgroundColor = [UIColor whiteColor];    self.segmentC.layer.borderColor = [UIColor blueColor].CGColor;    self.segmentC.layer.borderWidth = 0.5;    self.segmentC.layer.cornerRadius = 3;    NSDictionary * selectedTextAttr = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blueColor]};    [self.segmentC setTitleTextAttributes:selectedTextAttr forState:UIControlStateSelected];    NSDictionary * unselectedTextAttr = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blueColor]};    [self.segmentC setTitleTextAttributes:unselectedTextAttr forState:UIControlStateNormal];
