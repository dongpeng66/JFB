//
//  AuthenticationViewController.m
//  JFB
//
//  Created by LYD on 15/8/20.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "HZAreaPickerView.h"
#import "NSString+Check.h"
#import "WebViewController.h"
#import "AboutUsViewController.h"
#define WITH  [[UIScreen mainScreen] bounds].size.width    //全屏宽度
#define HEIGHT  [[UIScreen mainScreen] bounds].size.height //全屏高度
@interface AuthenticationViewController () <HZAreaPickerDelegate,UIAlertViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *_hud;
    MBProgressHUD *_networkConditionHUD;
//    NSString *_provinceStr;
//    NSString *_cityStr;
//    NSString *_disStr;
//    BOOL isModifyMemberInfo; //是否调用修改会员邮箱信息接口
    NSString *_locationStr;
     UITableView *tabView;
    NSMutableArray *newDataArr;
     NSArray *dataArr;
    NSString *data;
    
    NSString *areaCode;//地区编码
}

@property (nonatomic, strong) MBProgressHUD *networkConditionHUD;
@property (strong, nonatomic) HZAreaPickerView *locatePicker;

@end

@implementation AuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.title = self.titleStr;
    
//    isModifyMemberInfo = NO;
    _locationStr = @"";     //默认是空字符串
    NSString *mIdentityId = [[GlobalSetting shareGlobalSettingInstance] mIdentityId];
    mIdentityId = [mIdentityId substringToIndex:2];
    if (![mIdentityId isEqualToString:@"99"] ) {
 //已认证，该页作为编辑页，只能更改email
        self.nameTF.text = [[GlobalSetting shareGlobalSettingInstance] mName];
        self.nameTF.enabled = NO;
        self.identityCardTF.text = [[GlobalSetting shareGlobalSettingInstance] mIdentityId];
        self.identityCardTF.enabled = NO;
        
        NSString *locationStr = [[GlobalSetting shareGlobalSettingInstance] mlocation];
//        if ([locationStr isEqualToString:@""]) {
            self.provCityTF.enabled = YES;
//            isModifyMemberInfo = YES;
//        }
//        else {
//            self.provCityTF.enabled = NO;
//            isModifyMemberInfo = YES;
//        }
        self.provCityTF.text = locationStr;

        self.emailTF.text = [[GlobalSetting shareGlobalSettingInstance] mEmail];
        self.emailTF.enabled = YES;
        [self.submitBtn setTitle:@"提交修改" forState:UIControlStateNormal];
    }
    else {
        self.nameTF.enabled = YES;
        self.identityCardTF.enabled = YES;
        self.provCityTF.enabled = YES;
        self.emailTF.enabled = YES;
        [self.submitBtn setTitle:@"申请认证" forState:UIControlStateNormal];
    }
    
    
    [_emailTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    
    tabView = [[UITableView alloc]initWithFrame:CGRectMake((WITH-(WITH*.8))/2, 140, WITH*.8, HEIGHT*.24) style:UITableViewStyleGrouped];
    tabView.dataSource = self;
    tabView.delegate = self;
    tabView.hidden = YES;
     _emailTF.delegate = self;
    newDataArr = [NSMutableArray array];
    dataArr = [NSArray arrayWithObjects:
               @"@qq.com",
               @"@163.com",
               @"@163.net",
               @"@126.com",
               @"@sohu.com",
               @"@sina.com",
               @"@21cn.com",
               @"@sogou.com",
               @"@yeah.net",
               @"@eyou.com",
               @"@56.com",
               @"@hotmail.com",
               @"@foxmail.com",
               nil];
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


#pragma mark - TextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.provCityTF]) {
        [self.nameTF resignFirstResponder];
        [self.identityCardTF resignFirstResponder];
        [self.emailTF resignFirstResponder];
        
        [self cancelLocatePicker];
        self.locatePicker = [[HZAreaPickerView alloc] initWithDelegate:self];
        [self.locatePicker.completeBarBtn setTarget:self];
        [self.locatePicker.completeBarBtn setAction:@selector(resignKeyboard)];
        self.locatePicker.frame = CGRectMake(0, 0, SCREEN_WIDTH, 238);
        [self.locatePicker showInView:self.view];
        
        return NO;
    }
    
    if ([textField isEqual:self.emailTF]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.emailTF]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self cancelLocatePicker];
    [self.nameTF resignFirstResponder];
    [self.identityCardTF resignFirstResponder];
    [self.emailTF resignFirstResponder];
}

-(void)resignKeyboard{ //回收键盘
    [self cancelLocatePicker];
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    self.provCityTF.text = [NSString stringWithFormat:@"%@ %@ %@", picker.state, picker.city, picker.district];
    areaCode = picker.districtID;
//    _provinceStr = picker.state;
//    _cityStr = picker.city;
//    _disStr = picker.district;
    
    if (picker.districtID && ! [picker.districtID isEqualToString:@""]) {
        _locationStr = picker.districtID;
    }
    else if (picker.cityID && ! [picker.cityID isEqualToString:@""]) {
        _locationStr = picker.cityID;
    }
    else if (picker.stateID && ! [picker.stateID isEqualToString:@""]) {
        _locationStr = picker.stateID;
    }
}

-(void)cancelLocatePicker
{
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}

#pragma mark - 申请认证按钮事件
- (IBAction)submitAction:(id)sender
{
    [self cancelLocatePicker];
    [self.nameTF resignFirstResponder];
    [self.identityCardTF resignFirstResponder];
    [self.emailTF resignFirstResponder];
    
    if (! self.radioBtn.selected) {
        _networkConditionHUD.labelText = @"您同意《投保协议》后才能认证！";
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        return;
    }
    
    if (self.nameTF.text == nil || self.nameTF.text.length == 0) {
        _networkConditionHUD.labelText = @"请填写姓名！";
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        return;
    }
    if (self.identityCardTF.text == nil || self.identityCardTF.text.length == 0) {
        _networkConditionHUD.labelText = @"请填写身份证号！";
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        return;
    }
    BOOL isIdentityCard = [NSString validateIdentityCard:self.identityCardTF.text];
    if (! isIdentityCard) {
        _networkConditionHUD.labelText = @"请填写正确的身份证号！";
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        return;
    }
    if (self.provCityTF.text == nil || self.provCityTF.text.length == 0) {
        _networkConditionHUD.labelText = @"请选择地区！";
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        return;
    }
    
    if (self.emailTF.text.length>0) {
        NSString *emailRegex = @"^([a-zA-Z0-9]+[_|-|.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|-|.]?)*[a-zA-Z0-9]+(.(com|cn|net|co))+$";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        if (![emailTest evaluateWithObject:self.emailTF.text]){
            _networkConditionHUD.labelText = @"请正确输入邮箱号！";
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
            return;
        }
    }
    NSString *mIdentityId = [[GlobalSetting shareGlobalSettingInstance] mIdentityId];
    mIdentityId = [mIdentityId substringToIndex:2];
    if (![mIdentityId isEqualToString:@"99"] ) {
        [self toModifyMemberInfo];
    }
    else {
        [self toMemberActivate];
    }
}
- (IBAction)radioAction:(id)sender {
    self.radioBtn.selected = ! self.radioBtn.selected;
}
- (IBAction)agreementAction:(id)sender {
    WebViewController *web = [[WebViewController alloc] init];
    web.webUrlStr = NewRequestURL(@"apphelp/load.htm?type=5");
    web.titleStr = @"积分宝协议";
     web.isFrame = @"1";
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
    
//    AboutUsViewController *view = [[AboutUsViewController alloc]init];
//    view.type = @"5";
//  [self.navigationController pushViewController:view animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1000) {
    [self performSelector:@selector(fanhui) withObject:nil afterDelay:0.3];
    }
}
-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES]; //返回上级页面

}
#pragma mark - 发送实名认证请求
//会员实名认证
-(void)toMemberActivate
{
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:MemberActivate object:nil];

    NSString *emailStr = self.emailTF.text;
    if (emailStr == nil || [emailStr isEqualToString:@""]) {
        emailStr = @"";
    }
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:MemberActivate, @"op", nil];
    
     NSString *token = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] pension]];
    NSString *url =[NSString stringWithFormat:@"pri/member/name_auth.json?token=%@&name=%@&idCard=%@&areaCode=%@&email=%@",token,self.nameTF.text,self.identityCardTF.text,areaCode,emailStr];
    
    NSLog(@"%@",NewRequestURL2(url));
     [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL2(url) delegate:nil params:nil info:infoDic];
    
}

#pragma mark - 会员信息修改请求
-(void)toModifyMemberInfo
{
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:ModifyMemberInfo object:nil];
    NSString *userID = [[GlobalSetting shareGlobalSettingInstance] userID];
    if (userID == nil) {
        userID = @"";
    }
    NSString *emailStr = self.emailTF.text;
    if (emailStr == nil || [emailStr isEqualToString:@""]) {
        emailStr = @"";
    }
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:ModifyMemberInfo, @"op", nil];
    NSDictionary *pram = [[NSDictionary alloc] initWithObjectsAndKeys:emailStr,@"email",userID,@"mId",_locationStr,@"location", nil];
    NSLog(@"toModifyMemberInfo_pram:%@",pram);
    
    NSString *token = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] pension]];
    NSString *url = [NSString stringWithFormat:@"pri/member/modify_msg.htm?token=%@&areaCode=%@&email=%@",token,areaCode,self.emailTF.text];
   [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL2(url) delegate:nil params:pram info:infoDic];
}

#pragma mark - 发送登入请求
-(void)requestMemberReLogin { //登录
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:MemberLogin object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:MemberLogin, @"op", nil];
    NSString *mobilStr = [[GlobalSetting shareGlobalSettingInstance] mMobile];
    NSString *pwdStr = [[GlobalSetting shareGlobalSettingInstance] loginPWD];
    
    
    
    NSString *url = [NSString stringWithFormat:@"member/login.json?userType=member&loginId=%@&password=%@",mobilStr,pwdStr];
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL(url) delegate:nil params:nil info:infoDic];
}

#pragma mark - 网络请求结果数据
-(void) didFinishedRequestData:(NSNotification *)notification
{
    [_hud hide:YES];
    
    if ([[notification.userInfo valueForKey:@"RespResult"] isEqualToString:ERROR]) {
        _networkConditionHUD.labelText = [notification.userInfo valueForKey:@"ContentResult"];
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        return;
    }
    NSDictionary *responseObject = [[NSDictionary alloc] initWithDictionary:[notification.userInfo objectForKey:@"RespData"]];
    
    if ([notification.name isEqualToString:MemberActivate]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MemberActivate object:nil];
        
        NSLog(@"MemberActivate_responseObject: %@",responseObject);
        
        if ([responseObject[@"code"] intValue] == 0) {
            _networkConditionHUD.labelText = responseObject [MSG];
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
            
            //延迟0.2秒调用重新登录操作，刷新个人信息
      [self performSelector:@selector(requestMemberReLogin) withObject:nil afterDelay:0.2];
            
           [self.navigationController popViewControllerAnimated:YES]; //返回上级页面
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    if ([notification.name isEqualToString:ModifyMemberInfo]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ModifyMemberInfo object:nil];
        
        NSLog(@"MemberActivate_responseObject: %@",responseObject);
        
        if ([responseObject[@"code"] intValue] == 0) {
            _networkConditionHUD.labelText = responseObject [MSG];
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
            
            //延迟0.2秒调用重新登录操作，刷新个人信息
            [self performSelector:@selector(requestMemberReLogin) withObject:nil afterDelay:0.2];
            
//            [self.navigationController popViewControllerAnimated:YES]; //返回上级页面
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    if ([notification.name isEqualToString:MemberLogin]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MemberLogin object:nil];
        if ([responseObject[@"code"] intValue] == 0) {
            
            NSDictionary *dic = responseObject[DATA];
            [[GlobalSetting shareGlobalSettingInstance] setIsLogined:YES];  //已登录标示
            [[GlobalSetting shareGlobalSettingInstance] setUserID:dic [@"mId"]];
            [[GlobalSetting shareGlobalSettingInstance] setAuthenticate:dic [@"authenticate"]];    //是否认证
            [[GlobalSetting shareGlobalSettingInstance] setIsChangeCard:dic [@"isChangeCard"]];   //是否可更换会员卡
            [[GlobalSetting shareGlobalSettingInstance] setmBinding:dic [@"mBinding"]];
            [[GlobalSetting shareGlobalSettingInstance] setmMobile:dic [@"mMobile"]];
            [[GlobalSetting shareGlobalSettingInstance] setPension:dic [@"token"]];
            
            [[GlobalSetting shareGlobalSettingInstance] setcId:dic [@"cId"]];
            [[GlobalSetting shareGlobalSettingInstance] setOrganizationID:dic [@"oId"]];
            [[GlobalSetting shareGlobalSettingInstance] setmName:dic [@"mName"]];
            [[GlobalSetting shareGlobalSettingInstance] setmIdentityId:dic [@"mIdentityId"]];
            [[GlobalSetting shareGlobalSettingInstance] setmEmail:dic [@"mEmail"]];
            [[GlobalSetting shareGlobalSettingInstance] setmlocation:dic [@"location"]];
            
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
#pragma mark - 返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark - 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArr.count;
}
#pragma mark - 返回cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 44;
    
    
}
#pragma mark - 设置tableViewCell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *ss=@"hello word";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ss];
    
    if(cell==nil){
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
        //显示右边箭头
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",_emailTF.text,dataArr[indexPath.row]];
    
    cell.backgroundColor = [UIColor grayColor];
    
    return cell;
    
}
#pragma mark - 监听tableViewCell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击cell背景恢复正常状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _emailTF.text = newDataArr[indexPath.row];
    tabView.hidden = YES;
    newDataArr = nil;
}


- (void) textFieldDidChange:(id) sender {
    [self.view addSubview:tabView];
    
    tabView.hidden = NO;
    UITextField *_field = (UITextField *)sender;
    if (_field.text.length<=0) {
        
        tabView.hidden = YES;
    }
    data = _field.text;
    NSLog(@"%@",data);
    [tabView reloadData];
    
    [self nimabi:data];
    
}
-(void)nimabi:(NSString *)cao{
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i<dataArr.count; i++) {
        [arr addObject:[NSString stringWithFormat:@"%@%@",cao,dataArr[i]]];
    }
    newDataArr = arr;
    
}



#pragma mark - 表头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

#pragma mark - 表尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WITH, 44)];
    //view.backgroundColor = [UIColor orangeColor];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WITH, 44)];
    lab.text = @"    下滑可提示更多";
    lab.textColor = [UIColor redColor];
    [view addSubview:lab];
    return view;
}
@end
