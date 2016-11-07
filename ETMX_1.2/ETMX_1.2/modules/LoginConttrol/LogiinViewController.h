//
//  LogiinViewController.h
//  ETMX
//
//  Created by 杨香港 on 2016/10/30.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAccount.h"
#import "NetWorkManager.h"

@interface LogiinViewController : UIViewController
- (void)loginWithReq:(UserAccount *)user withUrl:(NSString *)url success:(HttpSuccess)success failure:(HttpFailure)failure;
@end
