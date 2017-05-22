
//
//  SelectedMemberTool.m
//  ETMX_1.2
//
//  Created by yangxianggang on 17/5/22.
//  Copyright © 2017年 杨香港. All rights reserved.
//

#import "SelectedMemberTool.h"

@implementation SelectedMemberTool

+ (void)setSelectedMember:(NSMutableArray *)array
{
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.arch"];
    [NSKeyedArchiver archiveRootObject:array toFile:cachePath];
    
}
+ (NSMutableArray *)getSelectedMember
{
    NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.arch"];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:cachePath];
}

@end
