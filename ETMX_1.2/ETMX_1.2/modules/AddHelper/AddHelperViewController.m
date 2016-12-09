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
#import "TaskMainControllerViewController.h"
#import "CurrentTask.h"
#define TASKINFO @"TaskTableViewCell"
#define MEMBER   @"MemberTableViewCell"


typedef NS_ENUM(NSInteger,RequestName) {
    
    TaskOpertots =100 ,
    MembersInTeam,
    
    ///任务参与者
    SelectedPartner_Delete = 300,
    SelectedPartner_Finish ,
    SelectedPartner_Pause,
    
    
    ///确定应用
    AddMemberConfirm = 600,
    AddMemberUseIt,
    
};

@interface AddHelperViewController ()<UITableViewDelegate,UITableViewDataSource,JSDropDownMenuDataSource,JSDropDownMenuDelegate,NSXMLParserDelegate>
{
    NSInteger _currentData1Index;
    NSMutableArray *_memberData;//组员
    UserAccount * _tempUser;
    
}
@property (strong, nonatomic) IBOutlet UITableView *taskInfoTable;
@property (strong, nonatomic) IBOutlet UITableView *memberInfoTable;
@property (strong, nonatomic) IBOutlet UILabel *viewTitle;
@property (strong, nonatomic) IBOutlet UILabel *chooseMemberLabel;
@property (strong, nonatomic) IBOutlet UILabel *taskInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *partInMemberLabel;
@property (strong, nonatomic) IBOutlet UIView *flagView;
@property (strong, nonatomic)    JSDropDownMenu *menu;
@property (strong, nonatomic) NSMutableArray * currentOperUser;
@property (strong, nonatomic)UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong)TaskMainControllerViewController * taskCon;

@property (nonatomic,assign) RequestName  requestName;
@property (nonatomic,assign)NSInteger  selectedMember;
@property (nonatomic,assign)NSIndexPath * selectedIndexPath;
@property (nonatomic,strong) MemberTableViewCell * memberCell ;


@end

@implementation AddHelperViewController
static NSInteger taskStartMan;//任务启动者
static BOOL memberFinish = NO;
static BOOL operatorsFinish = NO;
static BOOL clickFinish = NO;
static BOOL lastThree = NO;



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.currentOperUser = [NSMutableArray array];
//    for (int i=0; i<20; i++) {
//        UserAccount * user = [[UserAccount alloc] init];
//        user.id = [NSString stringWithFormat:@"id_%d",i];
//        user.name = [NSString stringWithFormat:@"name_%d",i];
//        user.fullName =  [NSString stringWithFormat:@"fullName_%d",i];
//        user.userType = [NSString stringWithFormat:@"usertype_%d",i];
//        [self.currentOperUser addObject:SAFE_FORMAT_STRING(user)];
//    }
    
    //獲取當前任務
    self.currentTask =  [[ETMXTask alloc] init];
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.center = CGPointMake(self.view.center.x, self.view.center.y);
    _indicatorView.backgroundColor = [UIColor lightGrayColor];
    _indicatorView.frame = CGRectMake(0, 0, 600, 800);
    //_indicatorView.frame = self.view.frame;
    self.indicatorView.alpha = 0.5;
    [self.taskInfoTable registerNib:[UINib nibWithNibName:@"TaskTableViewCell" bundle:nil] forCellReuseIdentifier:TASKINFO];
    [self.memberInfoTable registerNib:[UINib nibWithNibName:@"MemberTableViewCell" bundle:nil] forCellReuseIdentifier:MEMBER];
    
    //添加菜單
    // _memberData = [NSMutableArray arrayWithObjects:@"智能排序", @"离我最近", @"评价最高", @"最新发布", @"人气最高", @"价格最低", @"价格最高", nil];
    _memberData = [NSMutableArray array];
    CGPoint memint= self.flagView.frame.origin;
    self.menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(memint.x , memint.y) andHeight:45];
    self.menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    self.menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    self.menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    self.menu.dataSource = self;
    self.menu.delegate = self;
    self.currentTask  =   [CurrentTask sharedManager].currentTask;
    [self loadAllData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    //    [self loadAllData];
    self.taskInfoTable.delegate = self;
    self.taskInfoTable.dataSource = self;
    self.memberInfoTable.dataSource = self;
    self.memberInfoTable.delegate = self;
    [super viewWillAppear:animated];
    
}
- (void)loadAllData
{
    
    NSString * opearatorMethod = @"getCurrentOperators";
    NSMutableArray * paramArr = [NSMutableArray array];
    NSString * taskId =  [CurrentTask sharedManager].taskId;
    [paramArr addObject:SAFE_FORMAT_STRING(taskId)];
    [paramArr addObject:@"zh-CN|zh-TW|en"];
    
    //    NSArray * paramArr = [NSArray arrayWithObjects:self.currentTask.id,@"zh-CN|zh-TW|en", nil];
    __weak typeof(self) weakSelf = self;
    [NetWorkManager sendRequestWithParameters:paramArr method:opearatorMethod success:^(id data) {
        NSString *datastr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSXMLParser *p = [[NSXMLParser alloc] initWithData:data];
        [p setDelegate:weakSelf];
        [p parse];
        operatorsFinish = YES;
        [weakSelf laodDataFinish];
        
    } failure:^(NSError *error) {
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:Localized(@"please check the net") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alertView show];
        [self showAlert:Localized(@"please check the net")];
    }];
    
    NSString * userMberMethod = @"getGroupMembersByUserCode";
    NSString * userNumber = [[UserManager instance].dic objectForKey:@"number"];
    NSArray * paramUserArr = [NSArray arrayWithObjects:SAFE_FORMAT_STRING(userNumber), nil];
    [NetWorkManager sendRequestWithParameters:paramUserArr method:userMberMethod success:^(id data) {
        NSString *datastr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSXMLParser *p = [[NSXMLParser alloc] initWithData:data];
        [p setDelegate:weakSelf];
        [p parse];
        memberFinish = YES;
        [weakSelf laodDataFinish];
        
        
    } failure:^(NSError *error) {
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:Localized(@"please check the net") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alertView show];
        [self showAlert:Localized(@"please check the net")];
        
    }];
    [self.view addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
}

//添加组员
- (IBAction)addMember:(id)sender {
    //只用于页面
    
//    self.memberCell.deleteBtn.hidden = NO;
//    self.memberCell.pauseBtn.hidden = YES;
//    self.memberCell.finishBtn.hidden = YES;
    NSDictionary * dic = [UserManager instance].dic;
    UserAccount * user =_memberData[_currentData1Index];
    if ([self.currentOperUser containsObject:user]) {
       [self showAlert:@"不能重复添加"];
        return;
    }
    
    user.userType = @"任務參與者";
    if (user.id.length >0 ) {
        if ([user.id isEqualToString:[dic objectForKey:@"id"]]) {
            [self showAlert:@"不能添加自己"];
            
            //[self dismissViewControllerAnimated:YES completion:nil];
            return;
        }else{
            
            [self.currentOperUser addObject:user];
        }
        
        
    }else{
        [self showAlert:@"请选择组员"];
       // [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }

    [self.memberInfoTable reloadData];
}




#pragma UITableViewDelegate,UITableViewDataSource
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
        }else if (section == 1){
            return   self.currentOperUser.count;
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
        if (indexPath.row == 1) {
            
            taskCell.taskObject.text = self.currentTask.object;
            taskCell.taskNameLabel.text = self.currentTask.name;
            taskCell.startLabel.text = self.currentTask.planStartDate;
        }
        if (indexPath.row == 2) {
            
            taskCell.taskObject.text = Localized(@"TaskPlaneFinish");
            taskCell.taskObject.backgroundColor = [UIColor lightGrayColor];
            taskCell.taskNameLabel.text = Localized(@"TaskRealStart");
            taskCell.taskNameLabel.backgroundColor = [UIColor lightGrayColor];
            taskCell.startLabel.text = Localized(@"TaskRealFinish");
            taskCell.startLabel.backgroundColor = [UIColor lightGrayColor];
        }
        if (indexPath.row == 3) {
            taskCell.taskObject.text = self.currentTask.planEndDate;
            taskCell.taskNameLabel.text = self.currentTask.actualStartDate;
            taskCell.startLabel.text = self.currentTask.actualEndDate;
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
        
        NSLog(@"indexpath:%ld,%ld",(long)indexPath.section,(long)indexPath.row);
       MemberTableViewCell * memberCell = [tableView dequeueReusableCellWithIdentifier:MEMBER forIndexPath:indexPath];
     //   MemberTableViewCell * memberCell = [[NSBundle mainBundle] loadNibNamed:@"MemberTableViewCell" owner:self options:nil];
        self.memberCell = memberCell;
        memberCell.deleteBtn.hidden = NO;
        memberCell.pauseBtn.hidden = NO;
        memberCell.finishBtn.hidden = NO;
     
        _tempUser = [[UserAccount alloc] init];
        for (_tempUser in self.currentOperUser) {
            if ([_tempUser.userType isEqualToString:@"任務啟動者"]) {
                taskStartMan  =  [self.currentOperUser indexOfObject:_tempUser];
                break;
            }
        }
        if (_tempUser.id != nil) {
            [self.currentOperUser removeObjectAtIndex:taskStartMan];
            [self.currentOperUser insertObject:_tempUser atIndex:0];
            
        }
        NSArray *subviews = [[NSArray alloc] initWithArray:memberCell.contentView.subviews];
        for (UILabel *subview in subviews) {
            if ([subview isKindOfClass:[UILabel class]]) {
                subview.text = @"";
                subview.backgroundColor = [UIColor clearColor];
            }
        }
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
        
        if (indexPath.row == 0 && indexPath.section == 0) {
            
            for (UILabel *subview in subviews) {
                if ([subview isKindOfClass:[UILabel class]]) {
                    subview.text = @"";
                    subview.backgroundColor = [UIColor clearColor];
                }
                if ([subview isKindOfClass:[UIButton class]]) {
                    [subview removeFromSuperview];
                }
            }
            memberCell.nameLabel.text = Localized(@"PartIn_Name");
            memberCell.nameLabel.backgroundColor = [UIColor lightGrayColor];
            memberCell.propertyLabel.text = Localized(@"PartInProperty");
            memberCell.propertyLabel.backgroundColor = [UIColor lightGrayColor];
            memberCell.userTimeLabel.text = Localized(@"PartInUsingTime");
            memberCell.userTimeLabel.backgroundColor = [UIColor lightGrayColor];
            memberCell.deleteBtn.hidden = YES;
            memberCell.pauseBtn.hidden = YES;
            memberCell.finishBtn.hidden = YES;
            return memberCell;
            
        }
        
        if (indexPath.row == 0 && indexPath.section == 1) {
            
            memberCell.deleteBtn.hidden = YES;
            memberCell.pauseBtn.hidden = YES;
            memberCell.finishBtn.hidden = YES;
            
            // [tempArray removeObject:userTemp];
            // return memberCell;
        }
        
        /////////////参与者
        // [self.currentOperUser removeObject:self.tempUser];
        NSInteger  tag;
        UserAccount * user = [self.currentOperUser objectAtIndex:indexPath.row];
        tag = indexPath.row;
        
        memberCell.nameLabel.text = user.name;
        memberCell.propertyLabel.text = user.userType;
        
        NSLog(@"Userr_:%@,%@",user.name,user.userType);
        [memberCell.deleteBtn setTitle:Localized(@"delete") forState:UIControlStateNormal];
        [memberCell.deleteBtn setTitle:Localized(@"delete") forState:UIControlStateHighlighted];
        [memberCell.pauseBtn setTitle:Localized(@"pause") forState:UIControlStateNormal];
        [memberCell.pauseBtn setTitle:Localized(@"pause") forState:UIControlStateHighlighted];
        [memberCell.finishBtn setTitle:Localized(@"finish") forState:UIControlStateNormal];
        [memberCell.finishBtn setTitle:Localized(@"finish") forState:UIControlStateHighlighted];
        
        memberCell.deleteBtn.tag = tag;
        memberCell.pauseBtn.tag = tag;
        memberCell.finishBtn.tag = tag;
        [memberCell.deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
        [memberCell.pauseBtn addTarget:self action:@selector(pauseClick:) forControlEvents:UIControlEventTouchUpInside];
        [memberCell.finishBtn addTarget:self action:@selector(finishClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return memberCell;
    }
    return nil;
    
}


- (void)deleteClick:(id)sender
{
    self.requestName = SelectedPartner_Delete;
    UserAccount *userAccount = [self.currentOperUser objectAtIndex:((UIButton *)sender).tag];
    [self operClick:@"TD" withSelectUser:SAFE_FORMAT_STRING(userAccount.id)];
    self.selectedMember = ((UIButton *)sender).tag;
    if (self.requestName == SelectedPartner_Delete) {
        [self.currentOperUser removeObjectAtIndex:self.selectedMember];
    }
    [self.memberInfoTable reloadData];
    
    
}
- (void)pauseClick:(id)sender
{
    self.requestName = SelectedPartner_Pause;
    UserAccount *userAccount = [self.currentOperUser objectAtIndex:((UIButton *)sender).tag];
    
    [self operClick:@"TP" withSelectUser:SAFE_FORMAT_STRING(userAccount.id)];
    self.selectedMember = ((UIButton *)sender).tag;
    
}
- (void)finishClick:(id)sender
{
    self.requestName = SelectedPartner_Finish;
    UserAccount *userAccount = [self.currentOperUser objectAtIndex:((UIButton *)sender).tag];
    
    [self operClick:@"TF" withSelectUser:SAFE_FORMAT_STRING(userAccount.id)];
    self.selectedMember = ((UIButton *)sender).tag;
    
}

- (void)operClick:(NSString *)operType withSelectUser:(NSString *)userId;
{
    NSString * opearatorMethod = @"handleChildTaskOperation";
    NSMutableArray * paramArr = [NSMutableArray array];
    NSString * taskId =  [CurrentTask sharedManager].taskId;
    [paramArr addObject:SAFE_FORMAT_STRING(taskId)];
    //操作者ID
    [paramArr addObject:SAFE_FORMAT_STRING(userId)];
    [paramArr addObject:SAFE_FORMAT_STRING(operType)];
    NSDictionary * dic = [UserManager instance].dic;
    [paramArr addObject: [dic objectForKey:@"id"]];
    [paramArr addObject:@"zh-CN|zh-TW|en"];
    
    __weak typeof(self) weakSelf = self;
    [NetWorkManager sendRequestWithParameters:paramArr method:opearatorMethod success:^(id data) {
        NSString *datastr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSXMLParser *p = [[NSXMLParser alloc] initWithData:data];
        [p setDelegate:weakSelf];
        [p parse];
        
        operatorsFinish = YES;
        [weakSelf laodDataFinish];
        
        clickFinish = YES;
        //  [weakSelf laodDataFinish];
        
        
    } failure:^(NSError *error) {
        //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:Localized(@"please check the net") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        [alertView show];
        [self showAlert:Localized(@"please check the net")];
    }];
    
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
    
    
    return _memberData.count;
    
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    
    return @"請選擇";
    
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    
    
    UserAccount * user =  _memberData[indexPath.row];
    if (user.fullName != nil) {
        return user.fullName;
    }
    return nil;
    
    
    
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    _currentData1Index = indexPath.row;
    
}


#pragma bottomBtnClick
- (IBAction)confirm:(id)sender {
    
    self.requestName = AddMemberConfirm;
    [self clickOper:@"TF"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
    
    
}
- (IBAction)useIt:(id)sender {
    
    self.requestName = AddMemberUseIt;
    [self clickOper:@"TU"];
    
}
- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)clickOper:(NSString*)type
{
    
    NSDictionary * dic = [UserManager instance].dic;
    NSString * opearatorMethod = @"joinInTask";
    NSMutableArray * paramArr = [NSMutableArray array];
    NSString * taskId =  [CurrentTask sharedManager].taskId;
    [paramArr addObject:SAFE_FORMAT_STRING(taskId)];
    
    UserAccount * user =_memberData[_currentData1Index];
    if (user.id.length >0) {
        [paramArr addObject:SAFE_FORMAT_STRING(user.id)];
    }else{
        [self showAlert:@"请选择组员"];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    if ([user.id isEqualToString:[dic objectForKey:@"id"]]) {
        [self showAlert:@"不能添加自己"];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    //[paramArr addObject:@"zh-CN|zh-TW|en"];
    [paramArr addObject:@"ZH"];
    [paramArr addObject:SAFE_FORMAT_STRING([dic objectForKey:@"id"])];
    __weak typeof(self) weakSelf = self;
    [NetWorkManager sendRequestWithParameters:paramArr method:opearatorMethod success:^(id data) {
        NSString *datastr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSXMLParser *p = [[NSXMLParser alloc] initWithData:data];
        [p setDelegate:weakSelf];
        [p parse];
        lastThree = YES;
    } failure:^(NSError *error) {
        [self showAlert:error.localizedDescription];
    }];
}


#pragma mark -- NSXMLParserDelegate数据解析

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    
    if(attributeDict.count > 4){//任务参与人员
        UserAccount *userAccount = [[UserAccount alloc] init];
        userAccount.id = [attributeDict objectForKey:@"id"];
        userAccount.name = [attributeDict objectForKey:@"name"];
        userAccount.fullName = [attributeDict objectForKey:@"fullName"];
        userAccount.number = [attributeDict objectForKey:@"code"];
        userAccount.userType =  [attributeDict objectForKey:@"userType"];
        if (userAccount != nil) {
            [self.currentOperUser addObject:userAccount];
        }
        
    }else if(attributeDict.count == 4){//组员
        UserAccount *user = [[UserAccount alloc] init];
        user.id = [attributeDict objectForKey:@"id"];
        user.name = [attributeDict objectForKey:@"name"];
        user.fullName = [attributeDict objectForKey:@"fullName"];
        user.number = [attributeDict objectForKey:@"code"];
        user.userType =  [attributeDict objectForKey:@"userType"];
        if (user.fullName != nil) {
            [_memberData addObject:user];
        }
    }else if (self.requestName == AddMemberConfirm || self.requestName == AddMemberUseIt ){
        
        if ([[attributeDict objectForKey:@"flag"] isEqualToString:@"1"]) {
            
            [self showAlert:@"操作成功"];
            //数据源添加数据
        }else{
            
            //  [self showAlert:@"操作失败"];
            
        }
        
    }else if (self.requestName == SelectedPartner_Delete){
        if ([[attributeDict objectForKey:@"flag"] isEqualToString:@"1"]) {
            
            if (self.selectedMember < self.currentOperUser.count && self.selectedMember >=  0) {
                [self.currentOperUser removeObjectAtIndex:self.selectedMember];
                //  [self showAlert:@"操作成功"];
            }
        }
        
    }else if (self.requestName == SelectedPartner_Pause){
        if ([[attributeDict objectForKey:@"flag"] isEqualToString:@"1"]) {
            
            [self showAlert:@"操作成功"];
        }else{
            
            //  [self showAlert:@"操作失败"];
            
        }
        
        
    }else if (self.requestName == SelectedPartner_Finish){
        if ([[attributeDict objectForKey:@"flag"] isEqualToString:@"1"]) {
            
            [self showAlert:@"操作成功"];
        }else{
            
            //  [self showAlert:@"操作失败"];
            
        }
        
        
    }
    
}
////解析结束
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    switch (self.requestName) {
        case SelectedPartner_Delete:
            
            [self.memberInfoTable reloadData];
            break;
            
            
        case SelectedPartner_Finish:
            
            [self.memberInfoTable reloadData];
            break;
            
            
        case SelectedPartner_Pause:
            
            [self.memberInfoTable reloadData];
            break;
            
        case AddMemberUseIt:
            //   [self.currentOperUser addObject:_memberData[_currentData1Index]];
            self.memberCell.pauseBtn.hidden = NO;
            self.memberCell.finishBtn.hidden = NO;
            [self.memberInfoTable reloadData];
            break;
        case AddMemberConfirm:
            //   [self.currentOperUser addObject:_memberData[_currentData1Index]];
            self.memberCell.pauseBtn.hidden = NO;
            self.memberCell.finishBtn.hidden = NO;
            [self.memberInfoTable reloadData];
            break;
            
        default:
            break;
    }
}

- (void) laodDataFinish
{
    if (memberFinish && operatorsFinish) {
        [self.indicatorView stopAnimating];
        [self.view addSubview:self.menu];
        
        
        [self.memberInfoTable reloadData];
    }else{
        return ;
    }
}


- (void)showAlert:(NSString *)tips
{
    UIAlertController * alertCon = [UIAlertController alertControllerWithTitle:tips message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:Localized(@"searchConfirm") style:UIAlertActionStyleDestructive handler:nil];
    [alertCon addAction:action];
    [self presentViewController:alertCon animated:YES completion:nil];
    
}


@end
