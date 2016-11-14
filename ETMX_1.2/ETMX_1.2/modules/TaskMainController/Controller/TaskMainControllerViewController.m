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
    getFilterTasks2,
} NetRequestName;



@interface TaskMainControllerViewController ()<NSXMLParserDelegate>
//xib中的控件
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

@end

@implementation TaskMainControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    //网络判断
    if ([[CheckNetWorkerTool sharedManager] isNetWorking]) {
        [self sortAllTaskWithType:self.taskType andState:self.taskState];
    }else{
#warning todo:tip no connet to service
    }
    [self refresh:nil];
}

#pragma mark -- commen
-(void)setup{
    [self initNav];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
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
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    LoginResponse *response = [[NSUserDefaults standardUserDefaults] objectForKey:LOGINUSER];
    self.title = response.fullName;
    UIButton *freshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [freshBtn setTitle:Localized(@"refresh") forState:UIControlStateNormal];
    [freshBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [freshBtn setTitle:Localized(@"refresh") forState:UIControlStateHighlighted];
    [freshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [freshBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [freshBtn addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *refreshBarItem = [[UIBarButtonItem alloc] initWithCustomView:freshBtn];
    self.navigationItem.leftBarButtonItem =refreshBarItem;
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:Localized(@"search") forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [searchBtn setTitle:Localized(@"search") forState:UIControlStateHighlighted];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [searchBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [searchBtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = searchBarItem;
}

-(void)selecteType:(UISegmentedControl *)sender{
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.taskType = WTaskTypeMold;
            break;
            
        case 1:
            self.taskType = WTaskTypeChangeMold;
            break;
            
        case 2:
            self.taskType = WTaskTypeElectrode;
            break;
            
        default:
            break;
    }
    [self sortAllTaskWithType:self.taskType andState:self.taskState];
    [self refresh:nil];
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
    [self sortAllTaskWithType:self.taskType andState:self.taskState];
    [self refresh:nil];
}

//刷新按钮文字
-(void)refreshBtns{
    [self.stateSegment setTitle:[NSString stringWithFormat:@"%@(%@)",Localized(@"released"),[self.allTaskState valueForKey:@"notstart"]] forSegmentAtIndex:0];
    [self.stateSegment setTitle:[NSString stringWithFormat:@"%@(%@)",Localized(@"inwork"),[self.allTaskState valueForKey:@"start"]] forSegmentAtIndex:1];
    [self.stateSegment setTitle:[NSString stringWithFormat:@"%@(%@)",Localized(@"stopped"),[self.allTaskState valueForKey:@"stopped"]] forSegmentAtIndex:2];
    [self.stateSegment setTitle:[NSString stringWithFormat:@"%@(%@)",Localized(@"completed"),[self.allTaskState valueForKey:@"completed"]] forSegmentAtIndex:3];
}
//按照segment的选择排列任务，即设置sortTasks
-(void)sortAllTaskWithType:(NSString *)type andState:(NSString *)state{
    self.netRequesetName = getFilterTasks2;
    if ([[CheckNetWorkerTool sharedManager] isNetWorking]) {
        LoginResponse *response = [[NSUserDefaults standardUserDefaults] objectForKey:LOGINUSER];
        NSString *userCode = response.name;
        NSArray *parameters = @[self.taskState,userCode,@"",@"",self.taskType];
        NSString *methodName = @"queryFilterTasks";
        [NetWorkManager sendRequestWithParameters:parameters method:methodName success:^(id data) {
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
            [parser setDelegate:self];
            [parser parse];
        } failure:^(NSError *error) {
#warning todo:tip
        }];
    }
}



#pragma mark -- functions
//刷新
-(void)refresh:(id)sender{
    [self refreshBtns];
    [self.tableView reloadDataWithSortTasks:self.sortTasks];
}

//搜索事件
-(void)search:(id)sender{

    SearchViewController * sea = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    sea.preferredContentSize = CGSizeMake(800, 600);
    sea.modalPresentationStyle = UIModalPresentationPopover;
    // _chooseImagePopoverController = [[UIPopoverPresentationController alloc] initWithPresentedViewController:sea presentingViewController:self];
    _chooseImagePopoverController = sea.popoverPresentationController;
    _chooseImagePopoverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    //_chooseImagePopoverController.delegate = self;
    _chooseImagePopoverController.sourceRect = CGRectMake((self.view.frame.size.width/2), 150, 0, 0);
    _chooseImagePopoverController.sourceView = sea.view;
    _chooseImagePopoverController.barButtonItem = self.navigationItem.rightBarButtonItem;//导航栏右侧的小按钮
    [self presentViewController:sea animated:YES completion:nil];

}

//添帮手事件入口
- (IBAction)addHelper:(UIButton *)sender {
}

//启动
- (IBAction)startTask:(id)sender {
    LoginResponse *loginResponse = [[NSUserDefaults standardUserDefaults] objectForKey:LOGINUSER];
    NSArray *tasks = self.tableView.selectedTasks;
    NSString *tasksStr = [[NSString alloc] init];
    for (NSInteger i=0; i<tasks.count; i++) {
        ETMXTask *task = tasks[i];
        if (i!=tasks.count-1) {// 判断是否为最后一个
            [tasksStr stringByAppendingString:[NSString stringWithFormat:@"%@,",task.code]];
        }else{
            [tasksStr stringByAppendingString:task.code];
        }
    }
    NSArray *parameters = @[@"TS",loginResponse.name,tasksStr];
    NSString *methodName = @"taskExecute";
    [NetWorkManager sendRequestWithParameters:parameters method:methodName success:^(id data) {
        
    } failure:^(NSError *error) {
        
    }];
}
//暂停
- (IBAction)stopTask:(id)sender {
    LoginResponse *loginResponse = [[NSUserDefaults standardUserDefaults] objectForKey:LOGINUSER];
    NSArray *tasks = self.tableView.selectedTasks;
    NSString *tasksStr = [[NSString alloc] init];
    for (NSInteger i=0; i<tasks.count; i++) {
        ETMXTask *task = tasks[i];
        if (i!=tasks.count-1) {// 判断是否为最后一个
            [tasksStr stringByAppendingString:[NSString stringWithFormat:@"%@,",task.code]];
        }else{
            [tasksStr stringByAppendingString:task.code];
        }
    }
    NSArray *parameters = @[@"TP",loginResponse.name,tasksStr];
    NSString *methodName = @"taskExecute";
    [NetWorkManager sendRequestWithParameters:parameters method:methodName success:^(id data) {
        
    } failure:^(NSError *error) {
        
    }];
}
//完成
- (IBAction)finishTask:(id)sender {
    LoginResponse *loginResponse = [[NSUserDefaults standardUserDefaults] objectForKey:LOGINUSER];
    NSArray *tasks = self.tableView.selectedTasks;
    NSString *tasksStr = [[NSString alloc] init];
    for (NSInteger i=0; i<tasks.count; i++) {
        ETMXTask *task = tasks[i];
        if (i!=tasks.count-1) {// 判断是否为最后一个
            [tasksStr stringByAppendingString:[NSString stringWithFormat:@"%@,",task.code]];
        }else{
            [tasksStr stringByAppendingString:task.code];
        }
    }
    NSArray *parameters = @[@"TF",loginResponse.name,tasksStr];
    NSString *methodName = @"taskExecute";
    [NetWorkManager sendRequestWithParameters:parameters method:methodName success:^(id data) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)scanTask:(id)sender {
}

- (IBAction)goWork:(id)sender {
}

- (IBAction)workOff:(id)sender {
}

- (IBAction)exchange:(id)sender {
}

- (IBAction)selecteAll:(id)sender {
}

- (IBAction)cancelSelected:(id)sender {
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
            
        default:
            break;
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{

}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
}

@end
