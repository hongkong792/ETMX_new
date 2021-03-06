//
//  SearchViewController.m
//  ETMX_1.2
//
//  Created by 杨香港 on 2016/11/12.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "SearchViewController.h"
#import "JSDropDownMenu.h"
#import "UserManager.h"
#import "NetWorkManager.h"
#import "ETMXMachine.h"
#import "TaskMainControllerViewController.h"

@interface SearchViewController ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate,NSXMLParserDelegate>
{
    NSInteger _currentData1Index  ;
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
@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;
@property (strong, nonatomic)UIActivityIndicatorView *indicatorView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;


@end

@implementation SearchViewController

static BOOL equFinish = NO;
static BOOL memberFinish = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentData1Index =-1;
    _currentData2Index =-1;
    
     _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.center = CGPointMake(self.view.center.x, self.view.center.y);
    _indicatorView.backgroundColor = [UIColor lightGrayColor];
    _indicatorView.frame = CGRectMake(0, 0, 600, 1000);
    //_indicatorView.frame = self.view.frame;
    self.indicatorView.alpha = 0.5;
 
    // Do any additional setup after loading the view from its nib.
//    _data2 = [NSMutableArray arrayWithObjects:@"智能排序", @"离我最近", @"评价最高", @"最新发布", @"人气最高", @"价格最低", @"价格最高", nil];

    [self initData];
}

- (void)initData
{
    _data2 = [NSMutableArray array];
    CGPoint point= self.memberView.frame.origin;
    self.menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(point.x , point.y) andHeight:45];
    self.menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    self.menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    self.menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    self.menu.dataSource = self;
    self.menu.delegate = self;
    
    
    //        _data1 = [NSMutableArray arrayWithObjects:@"智能排序", @"离我最近", @"评价最高", @"最新发布", @"人气最高", @"价格最低", @"价格最高", nil];
    _data1 = [NSMutableArray array];
    CGPoint equoint= self.equipmentView.frame.origin;
    self.equmenu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(equoint.x , equoint.y) andHeight:45];
    self.equmenu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    self.equmenu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    self.equmenu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    self.equmenu.dataSource = self;
    self.equmenu.delegate = self;
    //獲取數據
    NSString * equMethod = @"getEquipmentsByUserCode";
   // NSString * userCode = [[UserManager instance].dic objectForKey:@"number"];

    NSString * userCode =[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUser"];
    NSArray * paramArr = [NSArray arrayWithObjects:userCode, nil];
    __weak typeof(self) weakSelf = self;
    [NetWorkManager sendRequestWithParameters:paramArr method:equMethod success:^(id data) {
        NSString *datastr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSXMLParser *p = [[NSXMLParser alloc] initWithData:data];
        [p setDelegate:weakSelf];
        [p parse];
        equFinish = YES;
        [self.view addSubview:self.equmenu];
        [weakSelf laodDataFinish];
    } failure:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:Localized(@"please check the net") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }];
    
    
    NSString * userMethod = @"getGroupMembersByUserCode";
    NSArray * paramUserArr = [NSArray arrayWithObjects:userCode, nil];
    
    [NetWorkManager sendRequestWithParameters:paramUserArr method:userMethod success:^(id data) {
        NSString *datastr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSXMLParser *p = [[NSXMLParser alloc] initWithData:data];
        [p setDelegate:weakSelf];
        [p parse];
        memberFinish = YES;
        [self.view addSubview:self.menu];
        [weakSelf laodDataFinish];
        
        
    } failure:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:Localized(@"please check the net") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
        
    }];
    
    [self.view addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    self.equipmentLabel.text = Localized(@"equipment");
    self.memberLabel.text = Localized(@"member");
    [self.confirmBtn setTitle:Localized(@"searchConfirm") forState:UIControlStateNormal];
    [self.confirmBtn setTitle:Localized(@"searchConfirm") forState:UIControlStateHighlighted];

    [self.cancelBtn setTitle:Localized(@"cancel selected") forState:UIControlStateNormal];
    [self.cancelBtn setTitle:Localized(@"cancel selected") forState:UIControlStateHighlighted];

        
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
        return Localized(@"please select equipment");
    }else if ([menu isEqual:self.menu]){
        return  Localized(@"please select");
        
    }
    return nil;

}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if ([menu isEqual:self.equmenu]) {
        
        if (_data1.count > indexPath.row) {
            ETMXMachine *machine = _data1[indexPath.row];
            return machine.machineName;
        }
        
    }else if ([menu isEqual:self.menu]){
        if (_data2.count > indexPath.row) {
            UserAccount * user = _data2[indexPath.row];
            return user.fullName;
        }
    }
    return nil;
    
    
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    if ([menu isEqual:self.equmenu]) {
       
        if (indexPath.row < _data1.count) {
              _currentData1Index = indexPath.row;
        }
        
        
    }else if ([menu isEqual:self.menu]){
        
        if (indexPath.row < _data2.count) {
            _currentData2Index =  indexPath.row;

        }

    }

  
}
- (IBAction)confirmClick:(id)sender {
    
    
    if (_currentData1Index != -1 && _currentData2Index !=-1) {
        [self showAlert:@"不可以同时选择两个,请重新选择"];
        _currentData1Index = -1 ;
        _currentData2Index =-1;
        return;
        //[self.menu reloadInputViews];
    }
  [self dismissViewControllerAnimated:YES completion:^{
      
      NSString * userCode;
      NSString * machineCode;
      UserAccount * user = [[UserAccount alloc] init];
      ETMXMachine *machine;
      if (_currentData2Index == -1) {//用户
          userCode = @"";
          userCode = [userCode stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
          
      }else{
          user  = _data2[_currentData2Index];
          userCode = user.number;
      }
      if (_currentData1Index ==-1) {
          machineCode = @"";
          machineCode = [machineCode stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      }else{
          
          machine  = _data1[_currentData1Index];
          machineCode = machine.machineCode;
          
      }

      if (user != nil) {
       [[UserManager instance] setCurAccount:user];
      }


      [self.delegate searchAll:machineCode memberID:userCode];
     [[NSNotificationCenter defaultCenter] postNotificationName:REMOVEMASKVIEW object:nil];
    
      
  }];
    
}
- (IBAction)cancelClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{

        [[NSNotificationCenter defaultCenter] postNotificationName:REMOVEMASKVIEW object:nil];
        
    }];
    
    
}




#pragma mark -- NSXMLParserDelegate数据解析

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    if ([elementName isEqualToString:@"Equipment"]) {
        ETMXMachine * machine = [[ETMXMachine alloc] init];
        machine.machineID = [attributeDict objectForKey:@"id"];
        machine.machineCode = [attributeDict objectForKey:@"code"];
        machine.machineName = [attributeDict objectForKey:@"name"];
        machine.machineModel = [attributeDict objectForKey:@"model"];
        if (machine != nil) {
          [_data1 addObject:machine];
        }
      
        
    }else if([elementName isEqualToString:@"User"]){
 
        UserAccount *userAccount = [[UserAccount alloc] init];
        userAccount.id = [attributeDict objectForKey:@"id"];
        userAccount.name = [attributeDict objectForKey:@"name"];
        userAccount.fullName = [attributeDict objectForKey:@"fullName"];
        userAccount.number = [attributeDict objectForKey:@"code"];
        userAccount.userType = [attributeDict objectForKey:@"userType"];
        if (userAccount.id != nil) {
            [_data2 addObject:userAccount];
        }
    }
    
}
- (void)laodDataFinish
{

    if (equFinish && memberFinish) {
        [self.indicatorView stopAnimating];
      
    
    }else{
        
        return ;
    }
    
    
}


- (void)showAlert:(NSString *)tips
{
    UIAlertController * alertCon = [UIAlertController alertControllerWithTitle:tips message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:Localized(@"searchConfirm") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.menu removeFromSuperview];
        [self.equmenu removeFromSuperview];
        [self initData];
        
    }];
    [alertCon addAction:action];
    [self presentViewController:alertCon animated:YES completion:nil];
}



- (void)viewDidDisappear:(BOOL)animated
{
    equFinish =NO;
    memberFinish = NO;
    
}


@end
