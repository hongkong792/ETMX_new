//
//  AddHelperViewController.m
//  ETMX_1.2
//
//  Created by 杨香港 on 2016/11/14.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "AddHelperViewController.h"
#import "TaskTableViewCell.h"
#import "MemberTableViewCell.h"
#import "JSDropDownMenu.h"
#import "UserAccount.h"
#import "UserManager.h"
#define TASKINFO @"TaskTableViewCell"
#define MEMBER   @"MemberTableViewCell"




@interface AddHelperViewController ()<UITableViewDelegate,UITableViewDataSource,JSDropDownMenuDataSource,JSDropDownMenuDelegate,NSXMLParserDelegate>
{
    NSInteger _currentData1Index;
    NSMutableArray *_data1;
}

@property (strong, nonatomic) IBOutlet UITableView *taskInfoTable;
@property (strong, nonatomic) IBOutlet UITableView *memberInfoTable;
@property (strong, nonatomic) IBOutlet UILabel *viewTitle;
@property (strong, nonatomic) IBOutlet UILabel *chooseMemberLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *partInMemberLabel;
@property (strong, nonatomic) IBOutlet UIView *flagView;
@property (strong, nonatomic)    JSDropDownMenu *menu;
@property (strong, nonatomic) NSMutableArray * currentUser;


@end

@implementation AddHelperViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    self.currentUser = [NSMutableArray array];
    self.taskInfoTable.delegate = self;
    self.taskInfoTable.dataSource = self;
    self.memberInfoTable.dataSource = self;
    self.memberInfoTable.delegate = self;
    
    
    [self.taskInfoTable registerNib:[UINib nibWithNibName:@"TaskTableViewCell" bundle:nil] forCellReuseIdentifier:TASKINFO];
    [self.memberInfoTable registerNib:[UINib nibWithNibName:@"MemberTableViewCell" bundle:nil] forCellReuseIdentifier:MEMBER];
    
    //添加菜單
    _data1 = [NSMutableArray arrayWithObjects:@"智能排序", @"离我最近", @"评价最高", @"最新发布", @"人气最高", @"价格最低", @"价格最高", nil];
    CGPoint equoint= self.flagView.frame.origin;
    self.menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(equoint.x , equoint.y) andHeight:45];
    self.menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    self.menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    self.menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    self.menu.dataSource = self;
    self.menu.delegate = self;
    
    NSString * userMethod = @"getCurrentOperators";
    NSString * userCode = [[UserManager instance].dic objectForKey:@"number"];
    NSArray * paramArr = [NSArray arrayWithObjects:@"001",@"zh-CN|zh-TW|en", nil];
    __weak typeof(self) weakSelf = self;
    [NetWorkManager sendRequestWithParameters:paramArr method:userMethod success:^(id data) {
        NSString *datastr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSXMLParser *p = [[NSXMLParser alloc] initWithData:data];
        [p setDelegate:weakSelf];
        [p parse];
        
    } failure:^(NSError *error) {
        
    }];
    
    
    [self.view addSubview:self.menu];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.memberInfoTable) {
        return 2;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.taskInfoTable) {
        return 4;
    }else if (tableView == self.memberInfoTable){
        if (section == 0) {
            return 1;
        }else if (section == 1)
        {
            return 5;
        }
        
        
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (tableView == self.taskInfoTable) {
        
        TaskTableViewCell * taskCell = [tableView dequeueReusableCellWithIdentifier:TASKINFO forIndexPath:indexPath];
        if (indexPath.row == 0) {
            taskCell.taskObject.text = Localized(@"TaskObject");
            taskCell.taskObject.backgroundColor = [UIColor lightGrayColor];
            taskCell.taskNameLabel.text = Localized(@"TaskName");
            taskCell.taskNameLabel.backgroundColor = [UIColor lightGrayColor];
            taskCell.startLabel.text = Localized(@"TaskStart");
            taskCell.startLabel.backgroundColor = [UIColor lightGrayColor];
        }
        [taskCell.taskObject.layer setBorderWidth:2]; //边框宽度
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){0, 0, 0, 0.05});
        [taskCell.taskObject.layer setBorderColor:colorref];
        
        [taskCell.taskNameLabel.layer setBorderWidth:2]; //边框宽度
        [taskCell.taskNameLabel.layer setBorderColor:colorref];
        
        [taskCell.startLabel.layer setBorderWidth:2]; //边框宽度
        [taskCell.startLabel.layer setBorderColor:colorref];
        
        //數據設置
        
        
        
        return taskCell;
        
    }else if (tableView == self.memberInfoTable){
        
        MemberTableViewCell * memberCell = [tableView dequeueReusableCellWithIdentifier:MEMBER forIndexPath:indexPath];
        if (indexPath.row == 0 && indexPath.section == 0) {
            
            memberCell.nameLabel.text = Localized(@"PartIn_Name");
            memberCell.nameLabel.backgroundColor = [UIColor lightGrayColor];
            memberCell.propertyLabel.text = Localized(@"PartInProperty");
            memberCell.propertyLabel.backgroundColor = [UIColor lightGrayColor];
            memberCell.userTimeLabel.text = Localized(@"PartInUsingTime");
            memberCell.userTimeLabel.backgroundColor = [UIColor lightGrayColor];
            memberCell.deleteBtn.hidden = YES;
            memberCell.pauseBtn.hidden = YES;
            memberCell.finishBtn.hidden = YES;
            
        }
        [memberCell.deleteBtn setTitle:Localized(@"delete") forState:UIControlStateNormal];
        [memberCell.deleteBtn setTitle:Localized(@"delete") forState:UIControlStateHighlighted];
        [memberCell.pauseBtn setTitle:Localized(@"pause") forState:UIControlStateNormal];
        [memberCell.pauseBtn setTitle:Localized(@"pause") forState:UIControlStateHighlighted];
        [memberCell.finishBtn setTitle:Localized(@"finish") forState:UIControlStateNormal];
        [memberCell.finishBtn setTitle:Localized(@"finish") forState:UIControlStateHighlighted];
        [memberCell.layer setBorderWidth:2]; //边框宽度
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){0, 0, 0, 0.05});
        [memberCell.layer setBorderColor:colorref];
        [memberCell.nameLabel.layer setBorderWidth:2]; //边框宽度
        [memberCell.nameLabel.layer setBorderColor:colorref];
        [memberCell.propertyLabel.layer setBorderWidth:2]; //边框宽度
        [memberCell.propertyLabel.layer setBorderColor:colorref];
        [memberCell.userTimeLabel.layer setBorderWidth:2]; //边框宽度
        [memberCell.userTimeLabel.layer setBorderColor:colorref];
        
        //數據設置
        [memberCell.deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        [memberCell.pauseBtn addTarget:self action:@selector(pauseClick:) forControlEvents:UIControlEventTouchUpInside];
        [memberCell.finishBtn addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return memberCell;
    }
    return nil;
}




- (void)deleteClick:(id)sender
{
    NSLog(@"deleteClick");
    
}
- (void)pauseClick:(id)sender
{
    
    
}
- (void)finishClick:(id)sender
{
    
    
}

#pragma JSDropDownMenu

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
    
    return _currentData1Index;
    
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    

        return _data1.count;

}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    

        return _data1[0];

    return nil;
    
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    

        return _data1[indexPath.row];

    
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {

        _currentData1Index = indexPath.row;

    
    
}
- (IBAction)confirmClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        NSLog(@"_currentData1Index:%@",_data1[_currentData1Index]);

                
    }];
    
    
    
}

#pragma bottomBtnClick
- (IBAction)confirm:(id)sender {
}
- (IBAction)useIt:(id)sender {
}
- (IBAction)cancel:(id)sender {
}


#pragma mark -- NSXMLParserDelegate数据解析

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    if([elementName isEqualToString:@"User"]){
        UserAccount *userAccount = [[UserAccount alloc] init];
        userAccount.id = [attributeDict objectForKey:@"id"];
        userAccount.name = [attributeDict objectForKey:@"name"];
        userAccount.fullName = [attributeDict objectForKey:@"fullName"];
        userAccount.number = [attributeDict objectForKey:@"code"];
        userAccount.userType =  [attributeDict objectForKey:@"userType"];
        [self.currentUser addObject:userAccount];
    }
}


@end
