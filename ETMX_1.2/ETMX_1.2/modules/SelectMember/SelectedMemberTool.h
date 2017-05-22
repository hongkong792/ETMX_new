//
//  SelectedMemberTool.h
//  ETMX_1.2
//
//  Created by yangxianggang on 17/5/22.
//  Copyright © 2017年 杨香港. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectedMemberTool : NSObject
+ (void)setSelectedMember:(NSMutableArray *)array;
+ (NSMutableArray *)getSelectedMember;

+ (void)setSelectedMachine:(NSMutableArray *)array;

+ (NSMutableArray *)getSelectedMachine;
@end
