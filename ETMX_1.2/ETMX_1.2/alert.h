//
//  alert.h
//  ETMX_1.2
//
//  Created by yangxianggang on 17/5/14.
//  Copyright © 2017年 杨香港. All rights reserved.
//

#ifndef alert_h
#define alert_h


#define alert_h(con,tips) - (void)showAlert:(NSString *)tips class:(UIViewController *) con;

#define alert_m(con,tips) - (void)showAlert:(NSString *)tips class:(UIViewController *) con{\
UIAlertController * alertCon = [UIAlertController alertControllerWithTitle:tips message:nil preferredStyle:UIAlertControllerStyleAlert];\
UIAlertAction * action = [UIAlertAction \actionWithTitle:Localized(@"searchConfirm") style:UIAlertActionStyleDestructive handler:nil];\
[alertCon addAction:action];\
[con presentViewController:alertCon animated:YES completion:nil];\
}

#endif /* alert_h */
