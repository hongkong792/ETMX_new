//
//  LogiinViewController.m
//  ETMX
//
//  Created by 杨香港 on 2016/10/30.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "LogiinViewController.h"
#import "UserAccount.h"
#import "NetWorkManager.h"

@interface LogiinViewController ()

@property(nonatomic,strong)AFHTTPSessionManager * manager;

@end

@implementation LogiinViewController


- (instancetype)init
{
    self = [super init];
    self.manager =  [AFHTTPSessionManager manager];
    return self;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)loginWithReq:(UserAccount *)user withUrl:(NSString *)url success:(HttpSuccess)success failure:(HttpFailure)failure
{

    
    
    
}

@end
