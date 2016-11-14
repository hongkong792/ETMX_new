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
    
    NSInteger _currentData1Index;
    NSMutableArray *_data1;
      NSInteger _currentData2Index;
      NSMutableArray *_data2;
}

@property (strong, nonatomic) IBOutlet UIView *equipmentView;
@property (strong, nonatomic) IBOutlet UIView *memberView;
@property (strong, nonatomic)    JSDropDownMenu *menu;
@property (strong, nonatomic)    JSDropDownMenu *equmenu;
@property (strong, nonatomic) IBOutlet UILabel *equipmentLabel;
@property (strong, nonatomic) IBOutlet UILabel *memberLabel;


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _data2 = [NSMutableArray arrayWithObjects:@"智能排序", @"离我最近", @"评价最高", @"最新发布", @"人气最高", @"价格最低", @"价格最高", nil];
    CGPoint point= self.memberView.frame.origin;
    self.menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(point.x , point.y) andHeight:45];
    self.menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    self.menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    self.menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    self.menu.dataSource = self;
    self.menu.delegate = self;
    [self.view addSubview:self.menu];
    
    
    _data1 = [NSMutableArray arrayWithObjects:@"智能排序", @"离我最近", @"评价最高", @"最新发布", @"人气最高", @"价格最低", @"价格最高", nil];
    CGPoint equoint= self.equipmentView.frame.origin;
    self.equmenu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(equoint.x , equoint.y) andHeight:45];
    self.equmenu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    self.equmenu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    self.equmenu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    self.equmenu.dataSource = self;
    self.equmenu.delegate = self;
    [self.view addSubview:self.equmenu];
    
    
    
 //   [self.equipmentView addSubview:menu];


}
- (void)viewWillAppear:(BOOL)animated
{
    self.equipmentLabel.text = Localized(@"equipment");
    self.memberLabel.text = Localized(@"member");
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

    if ([menu isEqual:self.equmenu]) {
        return _data1.count;
    }else if ([menu isEqual:self.menu]){
      return _data2.count;
        
    }
    return 0;

}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    
    if ([menu isEqual:self.equmenu]) {
        return _data1[0];
    }else if ([menu isEqual:self.menu]){
        return _data2[0];
        
    }
    return nil;

}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    
    if ([menu isEqual:self.equmenu]) {
        return _data1[indexPath.row];
    }else if ([menu isEqual:self.menu]){
        return _data2[indexPath.row];
        
    }
    return nil;
    
    
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    if ([menu isEqual:self.equmenu]) {
         _currentData1Index = indexPath.row;
    }else if ([menu isEqual:self.menu]){
        _currentData2Index =  indexPath.row;

    }

  
}

@end
