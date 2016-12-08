//
//  ExchangeOperatorViewController.m
//  ETMX_1.2
//
//  Created by wenpq on 16/11/20.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "ExchangeOperatorViewController.h"
#import "UserManager.h"
#import "NetWorkManager.h"
#import "ETMXTask.h"
#import "MembersTableViewController.h"
typedef enum : NSUInteger {
    ExchangeTaskTypeReplaceOperator,
    ExchangeTaskTypeGetGroupMembersByUserCode,
} ExchangeTaskType;


@interface ExchangeOperatorViewController ()<NSXMLParserDelegate,MembersTableViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) UserAccount *selectedMember;//被选的组员
@property (strong, nonatomic) IBOutlet UIButton *showMembersBtn;

@property (nonatomic,strong) NSMutableArray *members;   //查詢到的組員
@property (nonatomic,assign) ExchangeTaskType netType;
@property (nonatomic,strong) UIPopoverController *pop;
@end

@implementation ExchangeOperatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSubViews];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.block) {
        self.block();
    }
}

-(void)initSubViews{
    [self.submitBtn setTitle:Localized(@"submit") forState:UIControlStateNormal];
    [self.submitBtn setTitle:Localized(@"submit") forState:UIControlStateHighlighted];
    [self.submitBtn sizeToFit];
    self.titleLabel.text = Localized(@"groupMembers");
}

- (IBAction)submit:(id)sender {
    self.netType = ExchangeTaskTypeReplaceOperator;
    NSString *methodName = @"replaceOperator";
    NSString *taskStr = [self appendTaskStrWithTasks:self.selecedTasks];
    NSString *memberCode = nil;
    if (!self.selectedMember) {
        memberCode = @"";
    }else{
        memberCode = self.selectedMember.number;
    }
    NSArray *paramters = @[memberCode,taskStr];
    if (!taskStr || [taskStr isEqualToString:@""]||taskStr.length == 0) {
        NSString *message = Localized(@"please selecte task");
        if (message && message.length>0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        return;
    }
    [NetWorkManager sendRequestWithParameters:paramters method:methodName success:^(id data) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        [parser setDelegate:self];
        [parser parse];
    } failure:^(NSError *error) {
        [self showNetTip];
    }];
    
}
- (IBAction)showMembers:(id)sender {
    self.netType = ExchangeTaskTypeGetGroupMembersByUserCode;
    //獲取組員
    NSString *methodName = @"getGroupMembersByUserCode";
    NSString *userCode= [[UserManager instance].dic objectForKey:@"number"];
    NSArray *paramters = @[userCode];
    [NetWorkManager sendRequestWithParameters:paramters method:methodName success:^(id data) {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        [parser setDelegate:self];
        [parser parse];
    } failure:^(NSError *error) {
        [self showNetTip];
    }];
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

-(NSArray *)selecedTasks{
    if (_selecedTasks == nil) {
        _selecedTasks = [[NSArray alloc] init];
    }
    return _selecedTasks;
}

-(NSMutableArray *)members{
    if (_members == nil) {
        _members = [[NSMutableArray alloc] init];
    }
    return _members;
}

#pragma mark -- NSXMLParserDelegate数据解析
-(void)parserDidStartDocument:(NSXMLParser *)parser{
    if (self.netType == ExchangeTaskTypeGetGroupMembersByUserCode) {
        [self.members removeAllObjects];
    }
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    switch (self.netType) {
        case ExchangeTaskTypeGetGroupMembersByUserCode:
        {
            if ([elementName isEqualToString:@"User"]) {
                UserAccount *userAccount = [[UserAccount alloc] init];
                userAccount.id = [attributeDict valueForKey:@"id"];
                userAccount.number = [attributeDict valueForKey:@"code"];
                userAccount.name = [attributeDict valueForKey:@"name"];
                userAccount.fullName = [attributeDict valueForKey:@"fullName"];
                [self.members addObject:userAccount];
            }
        }
            break;
        case ExchangeTaskTypeReplaceOperator:
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
            
        default:
            break;
    }
   
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    switch (self.netType) {
        case ExchangeTaskTypeGetGroupMembersByUserCode:
            [self showTableViewWithMembers:self.members];
            break;
            
        default:
            break;
    }
   
}

-(void)showTableViewWithMembers:(NSArray *)members{
    MembersTableViewController *tableView = [[MembersTableViewController alloc] init];
    tableView.memberDelegate = self;
    tableView.menbersDataSource = self.members;
    UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:tableView];
    self.pop = pop;
    pop.popoverContentSize = CGSizeMake(300, 300);
    CGRect tempRect = CGRectMake(self.titleLabel.frame.size.width, 0, 0, 0);
    [pop presentPopoverFromRect:tempRect inView:self.titleLabel permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)showNetTip{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:Localized(@"please check the net") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}
#pragma mark -- MembersTableViewDelegate
-(void)onSelctedMemeberWithIndex:(NSInteger)index{
    if ([self.members[index] isKindOfClass:[UserAccount class]]) {
        self.selectedMember = self.members[index];
        NSString *str =  self.selectedMember.fullName;
        [self.showMembersBtn setTitle:str forState:UIControlStateNormal];
        [self.showMembersBtn setTitle:str forState:UIControlStateHighlighted];
        
    }
 
}

@end
