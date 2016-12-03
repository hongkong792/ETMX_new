//
//  TaskMainControllerViewController.m
//  ETMX
//
//  Created by wenpq on 16/11/2.
//  Copyright © 2016年 杨香港. All rights reserved.
//


#import "TaskMainControllerViewController.h"
#import "NetWorkManager.h"
#import "TaskContentTableView.h"
#import "CustomSegmentController.h"
#import "CustomBtn.h"
#import "LogiinViewController.h"
#import "SearchViewController.h"
#import "UserManager.h"
#import "ExchangeOperatorViewController.h"
#import "AddHelperViewController.h"
#import "CurrentTask.h"
#import "QRScanViewController.h"



#define WTaskTypeMold                    @"mold"                         //新模
#define WTaskTypeChangeMold     @"changeMold"         //改模
#define WTaskTypeElectrode           @"electrode"                //铜公


#define WTaskStateReleased            @"released"               //未开始
#define WTaskStateInwork                  @"inwork"                   //正在进行
#define WTaskStateStopped                 @"stopped"            //暂停中
#define WTaskStateCompleted            @"completed"      //已完成
#define WTaskStateOverdue                 @"overdue"            //已超期

#define WXMLParseNameGetTasksByUserCode @"ns1:getTasksByUserCodeResponse"         //根据用户号获得所有任务的解析字段

typedef enum : NSUInteger {
    getFilterTasks2,                //过滤任务
    taskExecutionTS,            //启动
    taskExecutionTP,            //暂停
    taskExecutionTF,            //完成
    taskExecutionDO,            //上班
    taskExecutionDF,            //下班
    taskExecutionSC_withTask,   //勾选任务扫描
    taskExecutionSC_noTask,     //不勾选任务扫描
} NetRequestName;




@interface TaskMainControllerViewController ()<NSXMLParserDelegate,SearchSelectedDelegate,QRCodeScanDelegate>
//xib中的控件
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

//类型segment
@property (strong, nonatomic) IBOutlet CustomSegmentController *typeSegment;

//状态segment
@property (strong, nonatomic) IBOutlet CustomSegmentController *stateSegment;

//添加帮手按钮
@property (strong, nonatomic) IBOutlet CustomBtn *addHelperBtn;

//全选按钮
@property (strong, nonatomic) IBOutlet CustomBtn *selecteAllBtn;

//取消按钮
@property (strong, nonatomic) IBOutlet CustomBtn *cancelBtn;

//启动按钮
@property (strong, nonatomic) IBOutlet CustomBtn *startBtn;

//暂停按钮
@property (strong, nonatomic) IBOutlet CustomBtn *stopBtn;

//完成按钮
@property (strong, nonatomic) IBOutlet CustomBtn *finishBtn;

//扫描按钮
@property (strong, nonatomic) IBOutlet CustomBtn *scanBtn;

//上班按钮
@property (strong, nonatomic) IBOutlet CustomBtn *workBtn;

//下班按钮
@property (strong, nonatomic) IBOutlet CustomBtn *workOffBtn;

//替换按钮
@property (strong, nonatomic) IBOutlet CustomBtn *exchangeBtn;

//任务展示tableview
@property (strong, nonatomic) IBOutlet TaskContentTableView *tableView;

//按照要求排序好的所有任务，二维数组
@property (nonatomic,strong) NSMutableArray *sortTasks;

//记录返回的状态，即未开始数、进行中数、已暂停数、已完成数
//notstart->未开始   start->进行中   overdue-> 已超时    completed->已完成     stopped->已暂停
@property (nonatomic,strong)NSMutableDictionary *allTaskState;

//任务类型
@property(nonatomic,strong) NSString *taskType;

//任务状态
@property(nonatomic,strong) NSString *taskState;

//网络请求方法名
@property (nonatomic,assign) NetRequestName netRequesetName;

//解析字段
@property (nonatomic,strong) NSString *parseName;

@property (strong,nonatomic) UIPopoverPresentationController *chooseImagePopoverController;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic,strong) QRScanViewController * qrViewCon;
@end

@implementation TaskMainControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self creatTableView];
    __block typeof(self) weakSelf = self;
    self.tableView.block = ^(){
        __strong typeof(self) strong = weakSelf;
        [strong refreshBtns];
        weakSelf.currentTask = (ETMXTask *)[weakSelf.tableView.selectedTasks lastObject];;
    };

    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self setup];
    [self sortAllTaskWithType:self.taskType andState:self.taskState];
    [[CurrentTask sharedManager] setCurrentTask:self.currentTask];
}

#pragma mark -- commen
-(void)setup{
    [self initNav];
    self.taskType = WTaskTypeMold;                                      //默认是新模
    self.taskState = WTaskStateReleased;                            //默认是未开始
    [self.typeSegment addTarget:self action:@selector(selecteType:) forControlEvents:UIControlEventValueChanged];
    [self.stateSegment addTarget:self action:@selector(selecteState:) forControlEvents:UIControlEventValueChanged];
    [self.addHelperBtn setTitle:Localized(@"add helper") forState:UIControlStateNormal];
    [self.addHelperBtn setTitle:Localized(@"add helper") forState:UIControlStateHighlighted];
    [self.typeSegment setTitle:Localized(@"new mold") forSegmentAtIndex:0];
    [self.typeSegment setTitle:Localized(@"change mold") forSegmentAtIndex:1];
    [self.typeSegment setTitle:Localized(@"electrode") forSegmentAtIndex:2];
    [self.stateSegment setTitle:Localized(@"released") forSegmentAtIndex:0];
    [self.stateSegment setTitle:Localized(@"inwork") forSegmentAtIndex:1];
    [self.stateSegment setTitle:Localized(@"stopped") forSegmentAtIndex:2];
    [self.stateSegment setTitle:Localized(@"completed") forSegmentAtIndex:3];
}

-(void)initNav{
    NSString *fullName = [[UserManager instance].dic valueForKey:@"fullName"];
    self.title =fullName;
    CustomBtn *freshBtn = (CustomBtn*)[UIButton buttonWithType:UIButtonTypeCustom];
    [freshBtn setTitle:Localized(@"refresh") forState:UIControlStateNormal];
    [freshBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [freshBtn setTitle:Localized(@"refresh") forState:UIControlStateHighlighted];
    [freshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [freshBtn sizeToFit];
    [freshBtn addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *refreshBarItem = [[UIBarButtonItem alloc] initWithCustomView:freshBtn];
    self.navigationItem.leftBarButtonItem =refreshBarItem;
    CustomBtn *searchBtn = (CustomBtn *)[UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:Localized(@"search") forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [searchBtn setTitle:Localized(@"search") forState:UIControlStateHighlighted];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [searchBtn sizeToFit];
    [searchBtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = searchBarItem;
}

-(void)creatTableView{
    TaskContentTableView *tableView = [[TaskContentTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), self.view.frame.size.width, self.view.frame.size.height - self.footerView.frame.size.height-self.headerView.frame.size.height) style:UITableViewStylePlain];
    self.tableView =tableView;
    __block typeof(self) weakSelf = self;
    self.tableView.block = ^(){
        __strong typeof(self) strong = weakSelf;
        [strong refreshBtns];
        weakSelf.currentTask = (ETMXTask *)[weakSelf.tableView.selectedTasks lastObject];;
    };
    [tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:self.tableView];
    [self.view bringSubviewToFront:self.indicatorView];
}

-(void)selecteType:(UISegmentedControl *)sender{
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.taskType = WTaskTypeMold;
            self.tableView.isElectrode = NO;
            break;
            
        case 1:
            self.taskType = WTaskTypeChangeMold;
            self.tableView.isElectrode = NO;
            break;
            
        case 2:
            self.taskType = WTaskTypeElectrode;
            self.tableView.isElectrode = YES;
            break;
            
        default:
            break;
    }
    [self.tableView.selectedSections removeAllObjects];
    [self.tableView.selectedTasks removeAllObjects];
    [self sortAllTaskWithType:self.taskType andState:self.taskState];
}

-(void)selecteState:(UISegmentedControl *)sender{
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.taskState = WTaskStateReleased;
            break;
        case 1:
            self.taskState = WTaskStateInwork;
            break;
        case 2:
            self.taskState = WTaskStateStopped;
            break;
        case 3:
            self.taskState = WTaskStateCompleted;
            break;
        default:
            break;
    }
    [self.tableView.selectedSections removeAllObjects];
    [self.tableView.selectedTasks removeAllObjects];
    [self sortAllTaskWithType:self.taskType andState:self.taskState];
}

//刷新按钮文字
-(void)refreshBtns{
    [self.stateSegment setTitle:[NSString stringWithFormat:@"%@(%@)",Localized(@"released"),[self.allTaskState valueForKey:@"notstart"]] forSegmentAtIndex:0];
    [self.stateSegment setTitle:[NSString stringWithFormat:@"%@(%@)",Localized(@"inwork"),[self.allTaskState valueForKey:@"start"]] forSegmentAtIndex:1];
    [self.stateSegment setTitle:[NSString stringWithFormat:@"%@(%@)",Localized(@"stopped"),[self.allTaskState valueForKey:@"stopped"]] forSegmentAtIndex:2];
    [self.stateSegment setTitle:[NSString stringWithFormat:@"%@(%@)",Localized(@"completed"),[self.allTaskState valueForKey:@"completed"]] forSegmentAtIndex:3];
    [self.selecteAllBtn setTitle:[NSString stringWithFormat:@"%@(%ld)",Localized(@"selecte all"),self.tableView.selectedTasks.count] forState:UIControlStateNormal];
    [self.selecteAllBtn setTitle:[NSString stringWithFormat:@"%@(%ld)",Localized(@"selecte all"),self.tableView.selectedTasks.count] forState:UIControlStateHighlighted];
}

//按照segment的选择排列任务，即设置sortTasks
-(void)sortAllTaskWithType:(NSString *)type andState:(NSString *)state{
    self.netRequesetName = getFilterTasks2;
    NSString *userCode= [[UserManager instance].dic objectForKey:@"number"];
    NSArray *parameters = @[self.taskState,userCode,@"",@"",self.taskType];
    NSString *methodName = @"queryFilterTasks";
    [self.indicatorView startAnimating];
    [NetWorkManager sendRequestWithParameters:parameters method:methodName success:^(id data) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        [parser setDelegate:self];
        [parser parse];
    } failure:^(NSError *error) {
        [self.indicatorView stopAnimating];
        [self showNetTip];
    }];
}

#pragma mark -- functions
//刷新
-(void)refresh:(id)sender{
    [self refreshBtns];
    [self.tableView.selectedTasks removeAllObjects];
    [self.tableView.selectedSections removeAllObjects];
    NSString *fullName = [[UserManager instance].dic valueForKey:@"fullName"];
    self.title =fullName;
    [self sortAllTaskWithType:self.taskType andState:self.taskState];
}

//搜索事件
-(void)search:(id)sender{
    
    
    SearchViewController * sea = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    sea.delegate = self;
    sea.preferredContentSize = CGSizeMake(600, 1000);
    sea.modalPresentationStyle = UIModalPresentationPopover;
    _chooseImagePopoverController = sea.popoverPresentationController;
    _chooseImagePopoverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    _chooseImagePopoverController.sourceRect = CGRectMake((self.view.frame.size.width/2), 150, 0, 0);
    _chooseImagePopoverController.sourceView = sea.view;
    _chooseImagePopoverController.barButtonItem = self.navigationItem.rightBarButtonItem;//导航栏右侧的小按钮
    [self presentViewController:sea animated:YES completion:nil];
    
    
    
}

//添帮手事件入口
- (IBAction)addHelper:(UIButton *)sender {
    

    if (self.currentTask == nil) {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"請選擇任務" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            return ;
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }else{
        [[CurrentTask sharedManager]  setTaskId:self.currentTask.id];
        [[CurrentTask sharedManager]  setCurrentTask:self.currentTask];
        AddHelperViewController * helpcon = [[AddHelperViewController alloc] initWithNibName:@"AddHelperViewController" bundle:nil];
        helpcon.preferredContentSize = CGSizeMake(600, 1000);
        helpcon.modalPresentationStyle = UIModalPresentationPopover;
        _chooseImagePopoverController = helpcon.popoverPresentationController;
        _chooseImagePopoverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        _chooseImagePopoverController.sourceRect = CGRectMake((self.view.frame.size.width/2), 150, 0, 0);
        _chooseImagePopoverController.sourceView = helpcon.view;
        _chooseImagePopoverController.barButtonItem = self.navigationItem.rightBarButtonItem;//导航栏右侧的小按钮
        helpcon.currentTask = self.currentTask;
        [self presentViewController:helpcon animated:YES completion:nil];
        
    }
    
    
    

}

//启动
- (IBAction)startTask:(id)sender {
    self.netRequesetName = taskExecutionTS;
    NSString *userCode = [[UserManager instance].dic valueForKey:@"number"];
    NSArray *tasks = self.tableView.selectedTasks;
    NSString *tasksStr = [[NSString alloc] init];
    tasksStr = [self appendTaskStrWithTasks:tasks];
    NSArray *parameters = @[@"TS",userCode,tasksStr];
    NSString *methodName = @"taskExecution";
    [NetWorkManager sendRequestWithParameters:parameters method:methodName success:^(id data) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        [parser setDelegate:self];
        [parser parse];
    } failure:^(NSError *error) {
        [self showNetTip];
    }];
}

//暂停
- (IBAction)stopTask:(id)sender {
    self.netRequesetName = taskExecutionTP;
    NSString *userCode = [[UserManager instance].dic valueForKey:@"number"];
    NSArray *tasks = self.tableView.selectedTasks;
    NSString *tasksStr = [[NSString alloc] init];
    tasksStr = [self appendTaskStrWithTasks:tasks];
    NSArray *parameters = @[@"TP",userCode,tasksStr];
    NSString *methodName = @"taskExecution";
    [NetWorkManager sendRequestWithParameters:parameters method:methodName success:^(id data) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        [parser setDelegate:self];
        [parser parse];
    } failure:^(NSError *error) {
        [self showNetTip];
    }];
}
//完成
- (IBAction)finishTask:(id)sender {
    self.netRequesetName = taskExecutionTP;
    NSString *userCode = [[UserManager instance].dic valueForKey:@"number"];
    NSArray *tasks = self.tableView.selectedTasks;
    NSString *tasksStr = [[NSString alloc] init];
    tasksStr = [self appendTaskStrWithTasks:tasks];
    NSArray *parameters = @[@"TF",userCode,tasksStr];
    NSString *methodName = @"taskExecution";
    [NetWorkManager sendRequestWithParameters:parameters method:methodName success:^(id data) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        [parser setDelegate:self];
        [parser parse];
    } failure:^(NSError *error) {
        [self showNetTip];
    }];
}

- (IBAction)scanTask:(id)sender {
    

    self.qrViewCon = [[QRScanViewController alloc] init];
    self.qrViewCon.delegate = self;
    [self.navigationController pushViewController:self.qrViewCon animated:YES];

    
}
//上班
- (IBAction)goWork:(id)sender {
    self.netRequesetName = taskExecutionDO;
    NSString *userCode = [[UserManager instance].dic valueForKey:@"number"];
    NSArray *tasks = self.tableView.selectedTasks;
    NSString *tasksStr = [[NSString alloc] init];
    tasksStr = [self appendTaskStrWithTasks:tasks];
    NSArray *parameters = @[@"DO",userCode,tasksStr];
    NSString *methodName = @"taskExecution";
    [NetWorkManager sendRequestWithParameters:parameters method:methodName success:^(id data) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        [parser setDelegate:self];
        [parser parse];
    } failure:^(NSError *error) {
        [self showNetTip];
    }];
    
}
//下班
- (IBAction)workOff:(id)sender {
    
    self.netRequesetName = taskExecutionDF;
    NSString *userCode = [[UserManager instance].dic valueForKey:@"number"];
    NSArray *tasks = self.tableView.selectedTasks;
    NSString *tasksStr = [[NSString alloc] init];
    tasksStr = [self appendTaskStrWithTasks:tasks];
    NSArray *parameters = @[@"DF",userCode,tasksStr];
    NSString *methodName = @"taskExecution";
    [NetWorkManager sendRequestWithParameters:parameters method:methodName success:^(id data) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        [parser setDelegate:self];
        [parser parse];
    } failure:^(NSError *error) {
        [self showNetTip];
    }];
}
//替換
- (IBAction)exchange:(id)sender {
    ExchangeOperatorViewController *exchangOpVC = [[ExchangeOperatorViewController alloc] initWithNibName:@"ExchangeOperatorViewController" bundle:nil];
    exchangOpVC.selecedTasks = self.tableView.selectedTasks;
    UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:exchangOpVC];
    CGFloat width = [UIScreen mainScreen].bounds.size.width*0.75;
    CGFloat height = [UIScreen mainScreen].bounds.size.height*0.75;
    popover.popoverContentSize =CGSizeMake(width, height);
    [popover presentPopoverFromRect:CGRectZero inView:self.exchangeBtn permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
}

- (IBAction)selecteAll:(id)sender {
    [self.tableView.selectedTasks removeAllObjects];
    for (ETMXTask *task in self.sortTasks) {
        [self.tableView.selectedTasks addObject:task];
    }
    [self refreshBtns];
    [self.tableView reloadData];
}

- (IBAction)cancelSelected:(id)sender {
    [self.tableView.selectedTasks removeAllObjects];
    [self.tableView.selectedSections removeAllObjects];
    [self refreshBtns];
    [self.tableView reloadData];
}

#pragma mark -- INIT

-(NSMutableArray *)sortTasks{
    if (_sortTasks == nil) {
        _sortTasks = [[NSMutableArray alloc] init];
    }
    return _sortTasks;
}

-(NSMutableDictionary *)allTaskState{
    if (_allTaskState == nil) {
        _allTaskState = [[NSMutableDictionary alloc] init];
    }
    return _allTaskState;
}

#pragma mark -- NSXMLParserDelegate数据解析
-(void)parserDidStartDocument:(NSXMLParser *)parser{
    switch (self.netRequesetName ) {
        case getFilterTasks2:
        {
            [self.allTaskState removeAllObjects];
            [self.sortTasks removeAllObjects];
        }
            break;
            
        default:
            break;
    }
    
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    switch (self.netRequesetName) {
        case getFilterTasks2:
        {
            if ([elementName isEqualToString:@"Etmx"]) {
                self.allTaskState = [NSMutableDictionary dictionaryWithDictionary:attributeDict];
            }
            if ([elementName isEqualToString:@"Task"]) {
                ETMXTask *task = [[ETMXTask alloc] initWithDic:attributeDict];
                [self.sortTasks addObject:task];
            }
        }
            break;
        case taskExecutionTS:{
            if ([elementName isEqualToString:@"Task"]) {
                NSString *message = [attributeDict valueForKey:@"message"];
                if (message && message.length>0) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
        }
            break;
        case taskExecutionTP:
        {
            if ([elementName isEqualToString:@"Task"]) {
                NSString *message = [attributeDict valueForKey:@"message"];
                if (message && message.length>0) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
            
        }
            break;
        case taskExecutionTF:
        {
            if ([elementName isEqualToString:@"Task"]) {
                NSString *message = [attributeDict valueForKey:@"message"];
                if (message && message.length>0) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
            
        }
        case taskExecutionDO:
        {
            if ([elementName isEqualToString:@"Task"]) {
                NSString *message = [attributeDict valueForKey:@"message"];
                if (message && message.length>0) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
        }
            break;
        case taskExecutionDF:
        {
            if ([elementName isEqualToString:@"Task"]) {
                NSString *message = [attributeDict valueForKey:@"message"];
                if (message && message.length>0) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alertView show];
                }
            }
        }
        case taskExecutionSC_noTask:
        {
            if ([elementName isEqualToString:@"Etmx"]) {
                self.allTaskState = [NSMutableDictionary dictionaryWithDictionary:attributeDict];
            }
            if ([elementName isEqualToString:@"Task"]) {
                ETMXTask *task = [[ETMXTask alloc] initWithDic:attributeDict];
                [self.sortTasks addObject:task];
            }
        }
        case taskExecutionSC_withTask:
        {
            if ([elementName isEqualToString:@"Etmx"]) {
                self.allTaskState = [NSMutableDictionary dictionaryWithDictionary:attributeDict];
            }
        }
            
        default:
            break;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    switch (self.netRequesetName) {
        case getFilterTasks2:
        {
            [self refreshBtns];
            [self.tableView reloadDataWithSortTasks:self.sortTasks];
            [self.indicatorView stopAnimating];
        }
            break;
        case taskExecutionTS:
        {
            [self.tableView.selectedTasks removeAllObjects];
            [self.tableView.selectedSections removeAllObjects];
            [self.tableView reloadData];
            [self refreshBtns];
        }
            break;
        case taskExecutionTP:
        {
            [self.tableView.selectedTasks removeAllObjects];
            [self.tableView.selectedSections removeAllObjects];
            [self.tableView reloadData];
            [self refreshBtns];
        }
            break;
        case taskExecutionTF:
        {
            [self.tableView.selectedTasks removeAllObjects];
            [self.tableView.selectedSections removeAllObjects];
            [self.tableView reloadData];
            [self refreshBtns];
        }
            break;
        case taskExecutionDO:
        {
            [self.tableView.selectedTasks removeAllObjects];
            [self.tableView.selectedSections removeAllObjects];
            [self.tableView reloadData];
            [self refreshBtns];
        }
            break;
        case taskExecutionDF:
        {
            [self.tableView.selectedTasks removeAllObjects];
            [self.tableView.selectedSections removeAllObjects];
            [self.tableView reloadData];
            [self refreshBtns];
        }
        case taskExecutionSC_noTask:
        {
            [self.tableView.selectedTasks removeAllObjects];
            [self.tableView.selectedSections removeAllObjects];
            [self.tableView reloadData];
            [self refreshBtns];
        }
        case taskExecutionSC_withTask:
        {
            [self.tableView.selectedTasks removeAllObjects];
            [self.tableView.selectedSections removeAllObjects];
            [self.tableView reloadData];
            [self refreshBtns];
        }
            break;
        default:
            break;
    }
}

-(NSString *)appendTaskStrWithTasks:(NSArray *)arr{
    NSString *tasksStr = [[NSString alloc] init];
    for (NSInteger i=0; i<arr.count; i++) {
        ETMXTask *task = arr[i];
        if (i!=arr.count-1) {// 判断是否为最后一个
            tasksStr =  [tasksStr stringByAppendingString:[NSString stringWithFormat:@"%@,",task.code]];
        }else{
            tasksStr =  [tasksStr stringByAppendingString:task.code];
        }
    }
    return tasksStr;
}

-(void)showNetTip{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:Localized(@"please check the net") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma SearchSelectedDelegate
- (NSString *)userNameOnSelected:(NSString *)userName
{
    if (userName != nil) {
        return userName;
    }
    //刷新主界面
    
    
    
    
    
    
    return nil;
}


# pragma dealScanning
- (void)scanController:(QRScanViewController *)scanController
         didScanResult:(NSString *)result
            isTwoDCode:(BOOL)isTwoDCode
{
    
    
    if (self.currentTask == nil) {//不勾选任务扫描
        self.netRequesetName = taskExecutionSC_noTask;
        NSString *userCode = [[UserManager instance].dic valueForKey:@"number"];
        NSArray *parameters = @[userCode,result];
        NSString *methodName = @"personalViewExecute";
        [NetWorkManager sendRequestWithParameters:parameters method:methodName success:^(id data) {
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
            [parser setDelegate:self];
            [parser parse];
        } failure:^(NSError *error) {
            [self showNetTip];
        }];
        
    }else{
        self.netRequesetName = taskExecutionSC_withTask;
        NSArray *tasks = self.tableView.selectedTasks;
        NSString *tasksStr = [self appendTaskStrWithTasks:tasks];
        NSArray *parameters = @[tasksStr,result];
        NSString *methodName = @"scanOperatorOrEquipment";
        [NetWorkManager sendRequestWithParameters:parameters method:methodName success:^(id data) {
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
            [parser setDelegate:self];
            [parser parse];
        } failure:^(NSError *error) {
            [self showNetTip];
        }];
        
    }

    
}


@end
