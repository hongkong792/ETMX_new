//
//  ViewController.m
//  ETMX
//
//  Created by 杨香港 on 2016/10/30.
//  Copyright © 2016年 杨香港. All rights reserved.
//

#import "ViewController.h"
#import "QRScanViewController.h"
#import "LogiinViewController.h"
#import "TaskMainControllerViewController.h"
#import "CheckNetWorkerTool.h"
#import "SearchViewController.h"
#import "AddHelperViewController.h"




@interface ViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,QRCodeScanDelegate,loginSucessDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *LanguagePicker;
@property (strong, nonatomic) IBOutlet UIView *rootView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *passWordLabel;
@property (strong, nonatomic) IBOutlet UITextField *userNameText;
@property (strong, nonatomic) IBOutlet UITextField *passwordTest;
@property (strong, nonatomic) IBOutlet UILabel *languageLabel;
@property (strong, nonatomic) IBOutlet UIButton *loginLabel;
@property (strong, nonatomic) IBOutlet UIButton *changeIPLabel;
@property (strong, nonatomic) IBOutlet UIButton *QRCodeLabel;
@property (strong, nonatomic) IBOutlet UIView *separatorThree;
@property (strong, nonatomic) IBOutlet UIView *swparatorFour;
@property (strong, nonatomic) IBOutlet UIView *separatorTwo;
@property (copy,nonatomic)NSString * adressIp;
@property (nonatomic,strong) QRScanViewController * qrViewCon;


@property (nonatomic, strong)UILabel * titleLabel;
@property (strong,nonatomic) UIPopoverPresentationController *chooseImagePopoverController;
@property (strong, nonatomic)UIActivityIndicatorView *indicatorView;

@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.center = CGPointMake(self.view.center.x, self.view.center.y);
    _indicatorView.backgroundColor = [UIColor lightGrayColor];
    _indicatorView.frame = CGRectMake(0, 0,self.view.frame.size.width , self.view.frame.size.height);
    //_indicatorView.frame = self.view.frame;
    self.indicatorView.alpha = 0.5;
    
    self.qrViewCon = nil;
    NSString * lan = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
    [self changeLanguageWithlan:lan];
    // Do any additional setup after loading the view, typically from a nib.
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setText:@"歡迎使用 ETMX"];
    [self.titleLabel setFont:[UIFont systemFontOfSize:60]];
    [self.titleLabel setFrame:CGRectMake(0, 0, 100, 30)];
    
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.titleLabel];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:100]];

    self.LanguagePicker.delegate = self;
    self.LanguagePicker.dataSource = self;

    self.passwordTest.placeholder = @"you password";
    self.passwordTest.secureTextEntry = YES;
    self.userNameText.placeholder = @"you username";
    self.passwordTest.textColor = [UIColor blackColor];
    self.userNameText.textColor = [UIColor blackColor];
    self.userNameText.font = [UIFont systemFontOfSize:25];
    self.passwordTest.font = [UIFont systemFontOfSize:25];
    
    
    if(kScreenHeight == 768)//小尺寸
    {
        //字号约束设置为小尺寸
        self.titleLabel.font = [UIFont systemFontOfSize:35];
        self.userNameLabel.font = [UIFont systemFontOfSize:30];
        self.passWordLabel.font = [UIFont systemFontOfSize:30];
        self.languageLabel.font = [UIFont systemFontOfSize:30];        
        self.loginLabel.titleLabel.font= [UIFont systemFontOfSize:30];
        self.changeIPLabel.titleLabel.font= [UIFont systemFontOfSize:30];
        self.QRCodeLabel.titleLabel.font= [UIFont systemFontOfSize:30];
        [self.passwordTest setSecureTextEntry:YES];
  
        self.userNameText.font = [UIFont systemFontOfSize:25];
        self.passWordLabel.font = [UIFont systemFontOfSize:25];
   
        
        NSLayoutConstraint * con_1 = [NSLayoutConstraint constraintWithItem:self.loginLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.separatorTwo attribute:NSLayoutAttributeBottom multiplier:1 constant:170];
        NSLayoutConstraint * con_2 = [NSLayoutConstraint constraintWithItem:self.separatorThree attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.loginLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
        NSLayoutConstraint * con_3 =[NSLayoutConstraint constraintWithItem:self.changeIPLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.separatorThree attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
        NSLayoutConstraint * con_4 =[NSLayoutConstraint constraintWithItem:self.swparatorFour attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.changeIPLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
        NSLayoutConstraint * con_5 =[NSLayoutConstraint constraintWithItem:self.QRCodeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.swparatorFour attribute:NSLayoutAttributeBottom multiplier:1 constant:10];
        
        [self.view addConstraint:con_1];
        [self.view addConstraint:con_2];
        [self.view addConstraint:con_3];
        [self.view addConstraint:con_4];
        [self.view addConstraint:con_5];
        
        
        
    }
    
    
    
}



#pragma UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{    
    return 3;
}
#pragma UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 400;
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 1) {
        return @"中文简体";
    }else if (row == 0){
        return @"中文繁体";
    }else if (row == 2){
        return @"English";
    }
    return nil;
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    if (row == 1) {

        [self changeLanguageWithlan:@"zh-Hans"];
    }else if (row == 0){

        [self changeLanguageWithlan:@"zh-Hant"];
    }else if (row == 2){
        
        [self changeLanguageWithlan:@"en"];
    }
    
    
}


////////语言切换

- (void)changeLanguageWithlan:(NSString*)lan
{
    
//    NSString *language = [[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"];
//    if ([language isEqualToString: @"en"]) {
//        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
//    }else {
//        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
//    }
//

  [[NSUserDefaults standardUserDefaults] setObject:lan forKey:@"appLanguage"];

    self.userNameLabel.text = Localized(@"username");
    self.passWordLabel.text = Localized(@"password");
    self.languageLabel.text = Localized(@"language");
   // self.loginLabel.titleLabel.text = Localized(@"login");
 //   self.changeIPLabel.titleLabel.text = Localized(@"changeIP");
 //   self.QRCodeLabel.titleLabel.text = Localized(@"ScanQRCode");
    self.titleLabel.text = Localized(@"title");

    [self.loginLabel setTitle:Localized(@"login") forState:UIControlStateNormal];
    [self.loginLabel setTitle:Localized(@"login") forState:UIControlStateHighlighted];
    
    [self.changeIPLabel setTitle:Localized(@"changeIP") forState:UIControlStateNormal];
    [self.changeIPLabel setTitle:Localized(@"changeIP") forState:UIControlStateHighlighted];
    
    [self.QRCodeLabel setTitle:Localized(@"ScanQRCode") forState:UIControlStateNormal];
    [self.QRCodeLabel setTitle:Localized(@"ScanQRCode") forState:UIControlStateHighlighted];
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (IBAction)loginClick:(id)sender {
    
//    AddHelperViewController * sea = [[AddHelperViewController alloc] initWithNibName:@"AddHelperViewController" bundle:nil];
//
//    sea.preferredContentSize = CGSizeMake(500, 800);
//    sea.modalPresentationStyle = UIModalPresentationPopover;
//    _chooseImagePopoverController = sea.popoverPresentationController;
//    _chooseImagePopoverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
//    
//    _chooseImagePopoverController.sourceRect = CGRectMake((self.view.frame.size.width/2), 150, 0, 0);
//    _chooseImagePopoverController.sourceView = sea.view;
//    _chooseImagePopoverController.barButtonItem = self.navigationItem.rightBarButtonItem;//导航栏右侧的小按钮
//    [self.navigationController pushViewController:sea animated:YES];
    [self.view addSubview:self.indicatorView];
    [self.indicatorView startAnimating];

    LogiinViewController * loginCon = [[LogiinViewController alloc] init];
    loginCon.delegate = self;
    UserAccount * user = [[UserAccount alloc] init];
    if (self.userNameText.text.length >0 &&self.passwordTest.text.length>0) {
        
        user.name = self.userNameText.text;
        user.password = self.passwordTest.text;
        NSString * loginUrl = @"http://192.168.1.161:8085/ETMX/services/Login";
        NSString * method = @"checkUserInfo";
        [loginCon loginWithReq:user withUrl:loginUrl method:method success:^(id data) {
            
        } failure:^(NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:Localized(@"please check the net") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
            
        }];

    }else{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"用户名或密码不能为空" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            return ;
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
 

}

- (IBAction)changeIpClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改IP" message:@"你的操作时合法的，您要继续吗" preferredStyle:UIAlertControllerStyleAlert];
    
    // 添加按钮
    __weak typeof(alert) weakAlert = alert;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
       NSLog(@"点击了确定按钮--%@-%@", [weakAlert.textFields.firstObject text], [weakAlert.textFields.lastObject text]);
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击了取消按钮");
        
        
    }]];
    
    // 添加文本框
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        //textField.textColor = [UIColor redColor];
        textField.text = @"";
        [textField addTarget:self action:@selector(ipChanged:) forControlEvents:UIControlEventEditingDidEnd];
       //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(usernameDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];


    [self presentViewController:alert animated:YES completion:nil];


    
    
}

- (IBAction)QRCodeClick:(id)sender {
    
    self.qrViewCon = [[QRScanViewController alloc] init];
    self.qrViewCon.delegate = self;
    [self.navigationController pushViewController:self.qrViewCon animated:YES];

}

# pragma dealScanning
- (void)scanController:(QRScanViewController *)scanController
         didScanResult:(NSString *)result
            isTwoDCode:(BOOL)isTwoDCode
{
    
   // [self.navigationController popViewControllerAnimated:YES];
    if (result.length > 0) {
        LogiinViewController * loginCon = [[LogiinViewController alloc] init];
        loginCon.delegate = self;
        UserAccount * user = [[UserAccount alloc] init];
            user.number = result;
            NSString * loginUrl = @"http://192.168.1.161:8085/ETMX/services/TaskScanExecution";
            NSString * method = @"checkCode";
             [loginCon loginWithReq:user withUrl:loginUrl method:method success:^(id data) {
                 
                
                 
             } failure:^(NSError *error) {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:Localized(@"please check the net") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                 [alertView show];
                 
             }];
        
        }else{
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"用户名或密码不能为空" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                return ;
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    
}



- (void)ipChanged:(id)sender
{
    UITextField * field = [[UITextField alloc] init];
    field =  (UITextField *)sender;
    //切换地址
    [[NSUserDefaults standardUserDefaults] setObject:field.text forKey:ADRESSIP];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //重新启动网络
    [CheckNetWorkerTool sharedManager];

}


-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationOverCurrentContext;//不适配
}

#pragma loginSucessDelegate
- (void)loginSuccess
{
//    TaskMainControllerViewController *taskMainVC = [[TaskMainControllerViewController alloc] init];
    
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)] animated:YES];
     //  [self.navigationController popViewControllerAnimated:YES];
    [self.indicatorView stopAnimating];
    dispatch_async(dispatch_get_main_queue(), ^{
       
        TaskMainControllerViewController *taskMainVC = [[TaskMainControllerViewController alloc] initWithNibName:@"TaskMainControllerViewController" bundle:nil];
        [self.navigationController pushViewController:taskMainVC animated:YES];
    });
    
}
- (void)loginFail
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"登录失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        return ;
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
    self.passwordTest.text = @"";
    
}

- (void)neeNotWorking
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"网络连接失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        return ;
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
