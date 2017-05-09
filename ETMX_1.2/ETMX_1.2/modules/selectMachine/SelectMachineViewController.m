//
//  SelectMachineViewController.m
//  ETMX_1.2
//
//  Created by yangxianggang on 17/5/4.
//  Copyright © 2017年 杨香港. All rights reserved.
//

#import "SelectMachineViewController.h"
#import "SearchViewController.h"
#import "JSDropDownMenu.h"
#import "NetWorkManager.h"
#import "UserManager.h"
#import "TaskMainControllerViewController.h"
#import "ETMXMachine.h"

@interface SelectMachineViewController ()<JSDropDownMenuDataSource,JSDropDownMenuDelegate,NSXMLParserDelegate>
{
    NSInteger _currentData2Index;
    NSMutableArray *_data2;
}
@property (strong, nonatomic)    JSDropDownMenu *menu;
@property (strong, nonatomic)UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) IBOutlet UIView *machineView;
@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@end
static BOOL memberFinish = NO;
@implementation SelectMachineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.center = CGPointMake(self.view.center.x, self.view.center.y);
    _indicatorView.backgroundColor = [UIColor lightGrayColor];
    _indicatorView.frame = CGRectMake(0, 0, 600, 600);
    //_indicatorView.frame = self.view.frame;
    self.indicatorView.alpha = 0.5;
    
    _data2 = [NSMutableArray array];
    CGPoint point= self.machineView.frame.origin;
    self.menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(point.x , point.y) andHeight:45];
    self.menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    self.menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    self.menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    self.menu.dataSource = self;
    self.menu.delegate = self;
    
    __weak typeof(self)weakSelf = self;
    NSString * equMethod = @"getEquipmentsByUserCode";
    NSString * userCode = [[UserManager instance].dic objectForKey:@"number"];
    NSArray * paramArr = [NSArray arrayWithObjects:userCode, nil];
    
    [NetWorkManager sendRequestWithParameters:paramArr method:equMethod success:^(id data) {
        NSString *datastr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSXMLParser *p = [[NSXMLParser alloc] initWithData:data];
        [p setDelegate:weakSelf];
        [p parse];
        
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
//    [self.confirmBtn setTitle:Localized(@"searchConfirm") forState:UIControlStateNormal];
//    [self.confirmBtn setTitle:Localized(@"searchConfirm") forState:UIControlStateHighlighted];
//    
//    [self.cancelBtn setTitle:Localized(@"cancel selected") forState:UIControlStateNormal];
//    [self.cancelBtn setTitle:Localized(@"cancel selected") forState:UIControlStateHighlighted];
    
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
    
    
    
    
    return  Localized(@"please select equipment");
    
    
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    
    
    if (_data2.count > indexPath.row) {
        ETMXMachine * machine = _data2[indexPath.row];
        return machine.machineName;
    }
    return nil;
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    
    
    if (indexPath.row+1 < _data2.count) {
        _currentData2Index =  indexPath.row;
        
    }
    
    
    
}
- (IBAction)confirmClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        ETMXMachine* machine = _data2[_currentData2Index];
        
        [self.delegate machineOnselected:machine.machineID];
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
            [_data2 addObject:machine];
        }
        
        
    }
    
}

- (void)laodDataFinish
{
    
    [self.indicatorView stopAnimating];
    [self.view addSubview:self.menu];
    
}


@end
