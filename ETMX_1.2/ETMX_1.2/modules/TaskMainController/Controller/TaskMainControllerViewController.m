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
    GetTasksByUserCode,
    QueryFilterTasks,
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

//获得所有任务，未整理未排序,一维数组
@property (nonatomic,strong) NSMutableArray *allTasks;

//按照要求排序好的所有任务，二维数组
@property (nonatomic,strong) NSMutableArray *sortTasks;

//记录返回的状态，即未开始数、进行中数、已暂停数、已完成数
@property (nonatomic,strong)NSMutableDictionary *allTaskState;

//任务展示tableview
@property (strong, nonatomic) IBOutlet TaskContentTableView *tableView;


//任务类型
@property(nonatomic,strong) NSString *taskType;

//任务状态
@property(nonatomic,strong) NSString *taskState;

//网络请求方法名
@property (nonatomic,assign) NetRequestName netRequesetName;

//解析字段
@property (nonatomic,strong) NSString *parseName;

@end

@implementation TaskMainControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    self.taskType = WTaskTypeMold;
    self.taskState =WTaskStateReleased;
    [self.typeSegment addTarget:self action:@selector(selecteType:) forControlEvents:UIControlEventValueChanged];
    [self.stateSegment addTarget:self action:@selector(selecteState:) forControlEvents:UIControlEventValueChanged];
    [self LoginTest];
}

-(void)initNav{
#warning todo:
//    self.curAccount = [[UserManager instance] getCurAccount];
//    self.title = self.curAccount.fullName;
    self.title = @"何燦洪(生產主管)";
    UIButton *freshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [freshBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [freshBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [freshBtn setTitle:@"刷新" forState:UIControlStateHighlighted];
    [freshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [freshBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [freshBtn addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *refreshBarItem = [[UIBarButtonItem alloc] initWithCustomView:freshBtn];
    self.navigationItem.leftBarButtonItem =refreshBarItem;
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [searchBtn setTitle:@"搜索" forState:UIControlStateHighlighted];
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
    [self refresh:nil];
}

//按照segment的选择排列任务，即设置sortTasks
-(void)sortAllTaskWithType:(NSString *)type andState:(NSString *)state{
#warning  todo:setSortAllTasks
    self.sortTasks = self.allTasks;
}

#pragma mark -- INIT
-(NSMutableArray *)allTasks{
    if (_allTasks ==nil) {
        _allTasks = [[NSMutableArray alloc] init];
    }
    return _allTasks;
}

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
//搜索事件
-(void)search:(id)sender{
#warning todo:
}

//刷新tableview
-(void)refresh:(id)sender{

    [self sortAllTaskWithType:self.taskType andState:self.taskState];
    
    [self.tableView reloadDataWithSortTasks:self.sortTasks];
}

//网络数据测试
-(void)LoginTest{
//    获取所有任务接口测试（getTasksByUserCode(String userCode)）
        NSArray *paramters = @[@"SGS000359"];
    NSString *urlStr = @"http://192.168.1.161:8085/ETMX/services/TaskScanExecution";
    NSString *methodName = @"getTasksByUserCode";
    [NetWorkManager sendRequestWithParameters:paramters url:urlStr method:methodName success:^(id data) {
#warning todo:解析数据
        NSError *error = nil;
        NSDictionary *dict = [XMLReader dictionaryForXMLData:data error:&error];
        NSDictionary *dict1 = [dict valueForKey:@"soap:Envelope"];
        NSDictionary *dict2 = [dict1 valueForKey:@"soap:Body"];
        NSDictionary *dict3 = [dict2 valueForKey:@"ns1:getTasksByUserCodeResponse"];
        NSDictionary *dict4 = [dict3 valueForKey:@"ns1:out"];
        NSString *str = [dict4 valueForKey:@"text"];//该字段根据实践情况获得
        NSData *newData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSXMLParser *p = [[NSXMLParser alloc] initWithData:newData];
        [p setDelegate:self];
        [p parse];
        
    } failure:^(NSError *error) {
        NSLog( @"%@",error);
    }];
}


#pragma mark -- NSXMLParserDelegate数据解析
-(void)parserDidStartDocument:(NSXMLParser *)parser{
    [self.allTaskState removeAllObjects];
    [self.allTaskState removeAllObjects];
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    if ([elementName isEqualToString:@"Etmx"]) {
        self.allTaskState = [NSMutableDictionary dictionaryWithDictionary:attributeDict];
    }
    if ([elementName isEqualToString:@"Task"]) {
        ETMXTask *task = [[ETMXTask alloc] initWithDic:attributeDict];
        [self.allTasks addObject:task];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{

}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    [self refresh:nil];
}

@end
