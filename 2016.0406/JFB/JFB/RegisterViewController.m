//
//  RegisterViewController.m
//  JFB
//
//  Created by JY on 15/8/21.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import "RegisterViewController.h"
#import "ScanCodeViewController.h"
#import "WebViewController.h"
#import "AboutUsViewController.h"
#define WITH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT  [[UIScreen mainScreen] bounds].size.height
#define LEFTTIME    120   //120秒限制

@interface RegisterViewController () <ScanCodeDelegate,UIAlertViewDelegate>
{
    MBProgressHUD *_hud;
    MBProgressHUD *_networkConditionHUD;
   // NSString *certCode;
    NSString *smstypeStr;   //验证码类型
    
    NSInteger leftTime;
    NSTimer *_timer;
    UIImageView *imageView;
    UIView *view;
    UIImageView *imgview;
    UIView *beiView;
    UILabel *tiShiView;
    UIButton *guanbi;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"快速注册";
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

-(void)viewWillAppear:(BOOL)animated {
     [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)scanAction:(id)sender {
    ScanCodeViewController *scanCodeVC = [[ScanCodeViewController alloc] init];
    scanCodeVC.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:scanCodeVC];
    nav.hidesBottomBarWhenPushed = YES;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (IBAction)radioAction:(id)sender {
    self.radioBtn.selected = ! self.radioBtn.selected;
}

- (IBAction)protocolAction:(id)sender {
    WebViewController *web = [[WebViewController alloc] init];
    web.webUrlStr = NewRequestURL(@"apphelp/load.htm?type=3");
    web.titleStr = @"积分宝协议";
     web.isFrame = @"1";
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}

- (IBAction)reSendAction:(id)sender {
       smstypeStr = @"0";  //短信验证码
   // [self verifyAndSend];
    [self.view endEditing:YES];
    if (self.phoneTF.text.length<11) {
        _networkConditionHUD.labelText = @"请输入正确的手机号码！";
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
    }else{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidden:)];
    beiView  = [[UIView alloc]initWithFrame:self.view.bounds];
    beiView.backgroundColor = [UIColor grayColor];
    beiView.alpha=.9;
    [beiView addGestureRecognizer:tap];
    [self.view addSubview:beiView];
    
    //整体背景
    UIImage *image = [UIImage imageNamed:@"scroll_check.jpg"];
    //小图块
    UIImage *srcimg = [UIImage imageNamed:@"scroll_check.jpg"];//／／test.png宽172 高192
    
    if (WITH<375) {
        image = [UIImage imageNamed:@"scroll_check2.jpg"];
        srcimg = [UIImage imageNamed:@"scroll_check2.jpg"];
    }
    
    CGPoint point ;
    
    point.x = WITH/2;
    point.y = HEIGHT/2+30;
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,image.size.width,image.size.height)];
    imageView.image=image;
    imageView.center = point;
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    tiShiView = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y-30, imageView.frame.size.width, 30)];
    tiShiView.backgroundColor = [UIColor blueColor];
    tiShiView.textColor = [UIColor whiteColor];
    tiShiView.textAlignment = NSTextAlignmentCenter;
    tiShiView.text = @"拖动滑块完成验证";
    [self.view addSubview:tiShiView];
    
    float with = imageView.frame.size.width;
    float height = imageView.frame.size.height;
    
    float myX =arc4random()%100;
    float myY =arc4random()%200;
    //扣去部分背景色
    view = [[UIView alloc]initWithFrame:CGRectMake(myX, myY, 60, 100)];
    view.backgroundColor = [UIColor grayColor];
    [imageView addSubview:view];
    NSLog(@"%f---%f",imageView.frame.origin.x,imageView.frame.origin.y);
    
    
    
    NSLog(@"image width = %f,height = %f",with,height);
    
    
    imgview = [[UIImageView alloc] init];
    imgview.backgroundColor = [UIColor redColor];
    imgview.frame = CGRectMake(with*.1, height*.5, 60, 100);
    CGRect rect =  CGRectMake(myX, myY, 60, 100);//要裁剪的图片区域，按照原图的像素大小来，超过原图大小的边自动适配
    CGImageRef cgimg = CGImageCreateWithImageInRect([srcimg CGImage], rect);
    imgview.image = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);//用完一定要释放，否则内存泄露
    
    imgview.layer.borderColor  = [[UIColor redColor] CGColor]; //要设置的颜色
    imgview.layer.borderWidth = 1; //要设置的描边宽
    [imageView addSubview:imgview];
    imgview.userInteractionEnabled = YES;
    
    //拖拽
    UIGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestures:)];
    
        [imgview addGestureRecognizer:panGestureRecognizer];
    }
    guanbi = [UIButton buttonWithType:UIButtonTypeCustom];
    guanbi.frame = CGRectMake(imageView.frame.origin.x+imageView.frame.size.width, imageView.frame.origin.y-60,30, 30) ;
    [guanbi setImage:[UIImage imageNamed:@"guanbiganniu"] forState:UIControlStateNormal];
     //btn.backgroundColor = [UIColor redColor];
    [guanbi addTarget:self action:@selector(hidden:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:guanbi];
}

- (IBAction)yuyinAction:(id)sender {
    smstypeStr = @"1";  //语音验证码
    [self verifyAndSend];
}

-(void)verifyAndSend {
    if ([[GlobalSetting shareGlobalSettingInstance] validatePhone:self.phoneTF.text]) {  //手机号码格式正确

            [self requestVerifyMobile];
   
    }
    else {
        _networkConditionHUD.labelText = @"请输入正确的手机号码！";
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
    }
}
#pragma mark - 完成按钮事件
- (IBAction)confirmAction:(id)sender {
    [self.phoneTF resignFirstResponder];
    [self.carAddressTF resignFirstResponder];
    [self.codeNumTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    [self.rePasswordTF resignFirstResponder];
    
    if (! self.radioBtn.selected) {
        _networkConditionHUD.labelText = @"您同意《积分宝用户协议》后才能注册！";
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        return;
    }
//    if (! [self.codeNumTF.text isEqualToString:certCode]) {
//        _networkConditionHUD.labelText = @"验证码输入不正确";
//        [_networkConditionHUD show:YES];
//        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
//        return;
//    }
    
    [self requestMemberRegister];
}


#pragma mark - ScanCodeDelegate
- (void)ScanCodeComplete:(NSString *)codeString {
    //商户ID二维码，需去除http://wx.jfb315.cn/UserCenter/Reg.aspx?uid=
    
    NSString *merchantidStr = [codeString stringByReplacingOccurrencesOfString:@"http://wx.jfb315.cn/UserCenter/Reg.aspx?uid=" withString:@""];
    self.carAddressTF.text = merchantidStr;
}

- (void)ScanCodeError:(NSError *)error {
    
}


/**
 *  改变剩余时间
 *
 *  @param timer
 */
-(void) changeLeftTime:(NSTimer *)timer{
    if ([smstypeStr intValue] == 0) { //短信验证码
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
    else if ([smstypeStr intValue] == 1) {  //语音验证码
        if (leftTime == 0) {
            self.yuyinBtn.enabled = YES;
            [_timer invalidate];
            NSString *string = [NSString stringWithFormat:@"重新获取语音验证码"];
            [self.yuyinBtn setTitle:string forState:UIControlStateNormal];
            return;
        }
        leftTime --;
        NSString *string = [NSString stringWithFormat:@"(%ldS)重新获取语音验证码",(long)leftTime];
        [self.yuyinBtn setTitle:string forState:UIControlStateNormal];
    }
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.codeNumTF]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    
    if ([textField isEqual:self.passwordTF]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    if ([textField isEqual:self.rePasswordTF]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    if ([textField isEqual:self.carAddressTF]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, -55, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.phoneTF resignFirstResponder];
    [self.carAddressTF resignFirstResponder];
    [self.codeNumTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    [self.rePasswordTF resignFirstResponder];
    
    return YES;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.phoneTF resignFirstResponder];
    [self.carAddressTF resignFirstResponder];
    [self.codeNumTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    [self.rePasswordTF resignFirstResponder];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.phoneTF resignFirstResponder];
    [self.carAddressTF resignFirstResponder];
    [self.codeNumTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    [self.rePasswordTF resignFirstResponder];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1000) {
        [self.navigationController popViewControllerAnimated:YES]; //返回登录页面
    }
}

#pragma mark - 发送请求验证手机号是否已注册
-(void)requestVerifyMobile { //验证是否已注册
    [_hud show:YES];
    
    [self.phoneTF resignFirstResponder];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:VerifyMobile object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:VerifyMobile, @"op", nil];
    
    
    NSString *url = [NSString stringWithFormat:@"member/find_pwd1.json?mobile=%@",self.phoneTF.text];
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL(url) delegate:nil params:nil info:infoDic];

}

#pragma mark - 发送注册验证码请求
-(void)requestSendSMSVerifyCode { //发送验证码
    [_hud show:YES];
    
    [self.phoneTF resignFirstResponder];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:SendSMSVerifyCodeNew object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:SendSMSVerifyCodeNew, @"op", nil];

     NSString *url = [NSString stringWithFormat:@"common/get_vcode.json?type=register&mobile=%@&smsType=%@",self.phoneTF.text,smstypeStr];
     [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL(url) delegate:nil params:nil info:infoDic];
}
#pragma mark - 发送注册请求
-(void)requestMemberRegister { //注册
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:MemberRegister object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:MemberRegister, @"op", nil];
    NSString *uIdStr = self.carAddressTF.text;
    if (self.carAddressTF.text == nil || [self.carAddressTF.text isEqualToString:@""]) {
        uIdStr = @"";
    }
    
   
    
    NSString *url = [NSString stringWithFormat:@"member/register.json?mobile=%@&password=%@&vcode=%@&uId=%@",self.phoneTF.text,self.passwordTF.text,self.codeNumTF.text,uIdStr];
     [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL(url) delegate:nil params:nil info:infoDic];
    
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
    
    if ([notification.name isEqualToString:SendSMSVerifyCodeNew]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:SendSMSVerifyCodeNew object:nil];
        if ([responseObject[@"code"] intValue] == 0) {
            _networkConditionHUD.labelText = [responseObject objectForKey:MSG];
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
            self.reSendBtn.enabled = NO;
            self.yuyinBtn.enabled = NO;
            leftTime = LEFTTIME;
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeLeftTime:) userInfo:nil repeats:YES];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发送短信" message:[responseObject objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    if ([notification.name isEqualToString:VerifyMobile]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:VerifyMobile object:nil];
        if ([responseObject[@"code"] intValue] == 0) {  //已注册
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号已注册" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
        else {
            [self requestSendSMSVerifyCode];
        }
    }
    
    if ([notification.name isEqualToString:MemberRegister]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MemberRegister object:nil];
        if ([responseObject[@"code"] intValue] == 0) {

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:MSG] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 1000;
            [alert show];

        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:MSG] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
#pragma mark - 图片验证
- (void) handlePanGestures:(UIPanGestureRecognizer*)paramSender{
    if (paramSender.state != UIGestureRecognizerStateEnded && paramSender.state != UIGestureRecognizerStateFailed){
        //通过使用 locationInView 这个方法,来获取到手势的坐标
        CGPoint location = [paramSender locationInView:imageView];
        paramSender.view.center = location;
        
        
        int a = location.x - view.center.x;
        int b = location.y - view.center.y;
        
        // NSLog(@"%d---%d",abs(a),abs(b));
        
        if ((abs(a)-1<=5)&&(abs(b)-1<=5)) {
            paramSender.view.center = view.center;
            imgview.layer.borderWidth = 0; //要设置的描边宽
            imageView.hidden = YES;
            beiView.hidden=YES;
            tiShiView.hidden = YES;
            guanbi.hidden = YES;
            [self verifyAndSend];
          
        }else {
            
        }
        if (location.x<30) {
            location.x=30;
            paramSender.view.center = location;
            
            
        }
        
        if (location.x>imageView.frame.size.width-30) {
            location.x=imageView.frame.size.width-30;
            paramSender.view.center = location;
        }
        
        if (location.y<50) {
            location.y=50;
            paramSender.view.center = location;
        }
        if (location.y>imageView.frame.size.height-50) {
            location.y=imageView.frame.size.height-50;
            paramSender.view.center = location;
        }
    }
}
-(void)hidden:(UITapGestureRecognizer *)tap{
    imageView.hidden = YES;
    beiView.hidden=YES;
    tiShiView.hidden = YES;
    guanbi.hidden = YES;
   }
@end
