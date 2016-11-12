//
//  SearchViewController.m
//  ETMX_1.2
//
//  Created by 杨香港 on 2016/11/12.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "SearchViewController.h"
#import "JSDropDownMenu.h"

@interface SearchViewController ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate>
{
      NSInteger _currentData2Index;
       NSMutableArray *_data2;
}

@property (strong, nonatomic) IBOutlet UIView *equipmentView;
@property (strong, nonatomic) IBOutlet UIView *memberView;


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _data2 = [NSMutableArray arrayWithObjects:@"智能排序", @"离我最近", @"评价最高", @"最新发布", @"人气最高", @"价格最低", @"价格最高", nil];
    CGPoint point= self.memberView.frame.origin;
    JSDropDownMenu *menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(point.x , point.y) andHeight:45];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
 //   [self.equipmentView addSubview:menu];


}

- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu
{
    return 1;
}
-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    return NO;
}
-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    

    return NO;
}
-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    

    return 1;
}
-(NSInteger)currentLeftSelectedRow:(NSInteger)column{

   return _currentData2Index;

}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{

  return _data2.count;

}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    return _data2[0];

}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    

   return _data2[indexPath.row];
        

}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {

   _currentData2Index = indexPath.row;

}

@end
