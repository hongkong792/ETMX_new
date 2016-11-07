//
//  ETMXApi.m
//  ETMX
//
//  Created by 杨香港 on 2016/11/1.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "ETMXApi.h"
#import "ETMXDefine.h"

@interface ETMXApi()
{
    NSString* _language;
    
    
}


@end

@implementation ETMXApi


- (NSString *)language
{
    @synchronized (self) {
        if (_language) {
            return _language;
        }
    }
    return nil;
    
}



@end
