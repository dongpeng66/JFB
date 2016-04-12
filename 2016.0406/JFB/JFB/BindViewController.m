//
//  BindViewController.m
//  JFB
//
//  Created by JY on 15/8/23.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import "BindViewController.h"

#define LEFTTIME    120   //120秒限制

@interface BindViewController () <UIAlertViewDelegate>
{
    MBProgressHUD *_hud;
    MBProgressHUD *_networkConditionHUD;
  //  NSString *certCode;
    
    NSInteger leftTime;
    NSTimer *_timer;
    NSString *mobile;
}

@end

@implementation BindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"绑定手机";
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
#pragma mark - 验证密码按钮事件
- (IBAction)checkAction:(id)sender {
    [self.passwordTF resignFirstResponder];
    NSString *loginPWD = [[GlobalSetting shareGlobalSettingInstance] loginPWD];
    if ([self.passwordTF.text isEqualToString:loginPWD]) {
        self.firstL.textColor = [UIColor blackColor];
        self.secondL.textColor = Red_BtnColor;
        
        self.firstView.hidden = YES;
        self.secondView.hidden = NO;
    }
    else {
        _networkConditionHUD.labelText = @"输入的密码错误！";
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
    }
}

#pragma mark - 发送短信按钮事件
- (IBAction)sendCodeAction:(id)sender { //获取验证码，成功后显示下级操作界面
    [self.phoneTF resignFirstResponder];
    if ([[GlobalSetting shareGlobalSettingInstance] validatePhone:self.phoneTF.text]) {  //手机号码格式正确
        [self requestbindMobile];
    }

}

#pragma mark - 重新发送验证码按钮事件
- (IBAction)reSendAction:(id)sender {
    [self.phoneTF resignFirstResponder];
    [self requestSendSMSVerifyCode];
}

#pragma mark - 绑定按钮事件
- (IBAction)bindAction:(id)sender {

        [self requestBoundPhoneNumber];

}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.passwordTF resignFirstResponder];
    [self.phoneTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1000) {
        [self.navigationController popViewControllerAnimated:YES]; //返回上级页面
    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"text: %@",text);
    
    if (textField == self.passwordTF) {
        if ([text length] >= 6) {
            self.checkBtn.enabled = YES;
            [self.checkBtn setBackgroundColor:Red_BtnColor];
        }
        else {
            self.checkBtn.enabled = NO;
            [self.checkBtn setBackgroundColor:Gray_BtnColor];
        }
    }
    
    else if (textField == self.phoneTF) {
        if ([text length] == 11) {
            self.sendCodeBtn.enabled = YES;
            [self.sendCodeBtn setBackgroundColor:Red_BtnColor];
        }
        else {
            self.sendCodeBtn.enabled = NO;
            [self.sendCodeBtn setBackgroundColor:Gray_BtnColor];
        }
    }
    
    else if (textField == self.codeTF) {
        if ([text length] >= 4) {
            self.bindBtn.enabled = YES;
            [self.bindBtn setBackgroundColor:Red_BtnColor];
        }
        else {
            self.bindBtn.enabled = NO;
            [self.bindBtn setBackgroundColor:Gray_BtnColor];
        }
    }
    
    
    return YES;
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


#pragma mark - 发送请求短信验证码
-(void)requestSendSMSVerifyCode {
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:SendSMSVerifyCode object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:SendSMSVerifyCode, @"op", nil];
    NSString *url = [NSString stringWithFormat:@"common/get_vcode.json?type=bindMobile&mobile=%@&smsType=0",_phoneTF.text];
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL(url) delegate:nil params:nil info:infoDic];
    
}
#pragma mark - 验证手机号是否已经绑定
-(void)requestbindMobile{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:@"Mobile" object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"Mobile", @"op", nil];

    NSString *loginPWD = [[GlobalSetting shareGlobalSettingInstance] loginPWD];
    NSString *token = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] pension]];

    NSString *url = [NSString stringWithFormat:@"pri/member/bind_mobile2.json?token=%@&password=%@&mobile=%@",token,loginPWD,self.phoneTF.text];
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL2(url) delegate:nil params:nil info:infoDic];
    
    
}
#pragma mark - 绑定手机号
-(void)requestBoundPhoneNumber { //绑定手机号码
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:BoundPhoneNumber object:nil];
  
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:BoundPhoneNumber, @"op", nil];
   
    
    NSString *token = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] pension]];
    
      NSString *loginPWD = [[GlobalSetting shareGlobalSettingInstance] loginPWD];
     NSString *url = [NSString stringWithFormat:@"pri/member/bind_mobile3.json?password=%@&mobile=%@&vcode=%@&token=%@",loginPWD,_phoneTF.text,_codeTF.text,token];
    
    NSLog(@"111--%@",NewRequestURL2(url));
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL2(url) delegate:nil params:nil info:infoDic];
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
            
            _networkConditionHUD.labelText = @"发送成功";
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
            
           // certCode = responseObject[DATA][@"certCode"];
            
            //发送成功
            self.sendToPhoneL.text = self.phoneTF.text;
            self.secondL.textColor = [UIColor blackColor];
            self.thirdL.textColor = Red_BtnColor;
            
            self.secondView.hidden = YES;
            self.thirdView.hidden = NO;
            
            self.reSendBtn.enabled = NO;
            leftTime = LEFTTIME;
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeLeftTime:) userInfo:nil repeats:YES];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发送短信" message:[responseObject objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    //--------------
    if ([notification.name isEqualToString:@"Mobile"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Mobile" object:nil];
        if ([responseObject[@"code"] intValue] == 0) {
            
            [self requestSendSMSVerifyCode];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
//---------------------
    
    if ([notification.name isEqualToString:BoundPhoneNumber]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:BoundPhoneNumber object:nil];
        if ([responseObject[@"code"] intValue] == 0) {
            
            [[GlobalSetting shareGlobalSettingInstance] setmBinding:@"1"];
            [[GlobalSetting shareGlobalSettingInstance] setmMobile:self.phoneTF.text];
            
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
