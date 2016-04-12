//
//  FindPWDViewController.m
//  JFB
//
//  Created by LYD on 15/8/25.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import "FindPWDViewController.h"

#define LEFTTIME    120   //120秒限制

@interface FindPWDViewController () <UIAlertViewDelegate>
{
    MBProgressHUD *_hud;
    MBProgressHUD *_networkConditionHUD;
   // NSString *certCode;
    
    NSInteger leftTime;
    NSTimer *_timer;
}

@end

@implementation FindPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"找回密码";
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (! _hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
    }
    
    if (!_networkConditionHUD) {
        _networkConditionHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_networkConditionHUD];
    }
    _networkConditionHUD.mode = MBProgressHUDModeText;
    _networkConditionHUD.yOffset = APP_HEIGHT/2 - HUDBottomH;
    _networkConditionHUD.margin = HUDMargin;
}

#pragma mark - 验证手机号是否存在按钮事件
- (IBAction)sendCodeAction:(id)sender { //获取验证码，成功后显示下级操作界面
    if ([[GlobalSetting shareGlobalSettingInstance] validatePhone:self.phoneTF.text]) {  //手机号码格式正确
        [self requestVerifyMobile];
       
    }
    
}
#pragma mark - 验证码重新发送按钮事件
- (IBAction)reSendAction:(id)sender {
    [self requestSendSMSVerifyCode];
}

#pragma mark - 发送验证码验证按钮事件
- (IBAction)checkAction:(id)sender {
    [self requestMemberFind];
}


- (IBAction)confirmAction:(id)sender {
    [self requestForgotPwd];
}

/**
 *  改变剩余时间
 *
 *  @param timer
 */
-(void) changeLeftTime:(NSTimer *)timer{
    if (leftTime == 0) {
        self.reSendBtn.enabled = YES;
        [_timer invalidate];
        NSString *string = [NSString stringWithFormat:@"重新发送"];
        [self.reSendBtn setTitle:string forState:UIControlStateNormal];
        return;
    }
    leftTime --;
    NSString *string = [NSString stringWithFormat:@"(%ldS)重新发送",(long)leftTime];
    [self.reSendBtn setTitle:string forState:UIControlStateNormal];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1000) {
        [self.navigationController popViewControllerAnimated:YES]; //返回登录页面
    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"text: %@",text);
    if (textField == self.phoneTF) {
        if ([text length] >= 11) {
            self.sendCodeBtn.enabled = YES;
            [self.sendCodeBtn setBackgroundColor:Red_BtnColor];
        }
        else {
            self.sendCodeBtn.enabled = NO;
            [self.sendCodeBtn setBackgroundColor:Gray_BtnColor];
        }
    }
    
    else if (textField == self.codeNumTF) {
        if ([text length] >= 4) {
            self.checkBtn.enabled = YES;
            [self.checkBtn setBackgroundColor:Red_BtnColor];
        }
        else {
            self.checkBtn.enabled = NO;
            [self.checkBtn setBackgroundColor:Gray_BtnColor];
        }
    }
    
    else if (textField == self.rePasswordTF) {
        if ([text length] >= 6) {
            self.confirmBtn.enabled = YES;
            [self.confirmBtn setBackgroundColor:Red_BtnColor];
        }
        else {
            self.confirmBtn.enabled = NO;
            [self.confirmBtn setBackgroundColor:Gray_BtnColor];
        }
    }
    
    
    
    
    return YES;
}


#pragma mark - 发送验证手机号是否已注册请求
-(void)requestVerifyMobile { //验证是否已注册
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:VerifyMobile object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:VerifyMobile, @"op", nil];
    
    NSString *url = [NSString stringWithFormat:@"member/find_pwd1.json?mobile=%@",self.phoneTF.text];
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL(url) delegate:nil params:nil info:infoDic];

    
}
#pragma mark - 发送短信或语音验证码
-(void)requestSendSMSVerifyCode { //发送短信验证码
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:SendSMSVerifyCode object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:SendSMSVerifyCode, @"op", nil];
    
    NSString *url = [NSString stringWithFormat:@"common/get_vcode.json?type=findPwd&mobile=%@&smsType=0",self.phoneTF.text];
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL(url) delegate:nil params:nil info:infoDic];
}
#pragma mark - 发送请求验证验证码是否正确
-(void)requestMemberFind{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:@"MemberFind" object:nil];
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"MemberFind", @"op", nil];
    
    NSString *url = [NSString stringWithFormat:@"member/find_pwd2.json?mobile=%@&vcode=%@",_phoneTF.text,_codeNumTF.text];
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL(url) delegate:nil params:nil info:infoDic];
}
#pragma mark - 重置密码请求
-(void)requestForgotPwd { //重置密码
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:ForgotPwd object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:ForgotPwd, @"op", nil];
    
    NSString *url = [NSString stringWithFormat:@"member/find_pwd3.json?mobile=%@&password=%@&vcode=%@",_phoneTF.text,_passwordTF.text,_codeNumTF.text];
   
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL(url) delegate:nil params:nil info:infoDic];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.phoneTF resignFirstResponder];
    [self.codeNumTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    [self.rePasswordTF resignFirstResponder];
}


#pragma mark - 网络请求结果数据
-(void) didFinishedRequestData:(NSNotification *)notification{
    [_hud hide:YES];
    
    if ([[notification.userInfo valueForKey:@"RespResult"] isEqualToString:ERROR]) {
        
        _networkConditionHUD.labelText = [notification.userInfo valueForKey:@"ContentResult"];
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        return;
    }
    NSDictionary *responseObject = [[NSDictionary alloc] initWithDictionary:[notification.userInfo objectForKey:@"RespData"]];
    NSLog(@"GetMerchantList_responseObject: %@",responseObject);
    
    if ([notification.name isEqualToString:SendSMSVerifyCode]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:SendSMSVerifyCode object:nil];
        if ([responseObject[@"code"] intValue] == 0) {
            _networkConditionHUD.labelText = [responseObject objectForKey:MSG];
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
            //发送成功
            self.sendToPhoneL.text = self.phoneTF.text;
            self.firstL.textColor = [UIColor blackColor];
            self.secondL.textColor = Red_BtnColor;
            
            self.firstView.hidden = YES;
            self.secondView.hidden = NO;
            
            self.reSendBtn.enabled = NO;
            leftTime = LEFTTIME;
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeLeftTime:) userInfo:nil repeats:YES];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    if ([notification.name isEqualToString:VerifyMobile]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:VerifyMobile object:nil];
        if ([responseObject[@"code"] intValue] == 0) {  //已注册
            [self requestSendSMSVerifyCode];  //重置密码，已注册手机号发送短信验证码
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
   //-------------------
    if ([notification.name isEqualToString:@"MemberFind"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MemberFind" object:nil];
        if ([responseObject[@"code"] intValue] == 0) {  //已注册
            self.secondL.textColor = [UIColor blackColor];
            self.thirdL.textColor = Red_BtnColor;
            self.thirdL.hidden = NO;
            self.secondView.hidden = YES;

        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
//-------------------
    
    
    
    
    
    if ([notification.name isEqualToString:ForgotPwd]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ForgotPwd object:nil];
        if ([responseObject[@"code"] intValue] == 0) {
//            _networkConditionHUD.labelText = [responseObject objectForKey:MSG];
//            [_networkConditionHUD show:YES];
//            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:MSG] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 1000;
            [alert show];
    
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
