//
//  SearchViewController.h
//  ETMX_1.2
//
//  Created by 杨香港 on 2016/11/12.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchSelectedDelegate <NSObject>

- (void)userNameOnSelected:(NSString *)userCode;

@end


@interface SearchViewController : UIViewController

@property (nonatomic,strong)id<SearchSelectedDelegate>delegate;

@end
