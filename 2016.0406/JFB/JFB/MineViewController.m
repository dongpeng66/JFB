//
//  MineViewController.m
//  JFB
//
//  Created by jy on 15/8/19.
//  Copyright (c) 2015年 jy. All rights reserved.
//
#import "OneYuanBuyingViewController.h"
#import "MineViewController.h"
#import "MyInfoViewController.h"
#import "MyOrderViewController.h"
#import "MyPensionsViewController.h"
#import "MyEvaluateViewController.h"
#import "MyCollectionViewController.h"
#import "LoginViewController.h"
#import "ShopApplyViewController.h"
#import "RegisterViewController.h"
#import "WebViewController.h"
#import "XIBView.h"
#import "TSFmeCell.h"
#import "QRcodeViewController.h"
#import "MyEntityOrderViewCountroller.h"
#import "RedPacket.h"
#define h self.view.frame.size.height
#define w self.view.frame.size.width
@interface MineViewController ()
{
    MBProgressHUD *_hud;
    MBProgressHUD *_networkConditionHUD;
    XIBView *myHeadview;
   float qian;
     MYAlertView *myalertView ;
}

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.translucent = YES;

    self.title = @"我的";
    //卡号，卡背景父视图
    self.headView = [[UIView alloc] init];
    self.headView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.headView];
    
    //下部tableView
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    [self.view addSubview:self.myTableView];
    
}

#pragma mark - 二维码
-(void)rightBarButnClick {
    QRcodeViewController *qrVC = [[QRcodeViewController alloc] init];
    NSString *phone = [NSString stringWithFormat:@"jfb-userid:%@",[[GlobalSetting shareGlobalSettingInstance] mMobile]];
    qrVC.qrString = phone;
    qrVC.titleStr = @"二维码名片";
    qrVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:qrVC animated:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    
    if (!myalertView) {
        myalertView = [[MYAlertView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:myalertView];
    }

}

-(void)viewWillAppear:(BOOL)animated {
     [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
    
    
   
    BOOL isLogined = [[GlobalSetting shareGlobalSettingInstance] isLogined];
    
    if (isLogined) {
        self.navigationItem.rightBarButtonItem = nil;
        
        [self requesPersion];
    
//------------------------TSF修改-----------------------------------------------------------
        myHeadview=[[XIBView alloc]initWithFrame:CGRectMake(0, 0, w, h*.26+90)];
        [myHeadview.twoDimensionBtn addTarget:self action:@selector(rightBarButnClick) forControlEvents:UIControlEventTouchUpInside];

        myHeadview.backgroundColor=[UIColor whiteColor];
        NSString *cidStr = [NSString stringWithFormat:@"卡号:%@",[[GlobalSetting shareGlobalSettingInstance] cId]];
        myHeadview.numberL.text =cidStr;
        myHeadview.zhang=0;
       
        myHeadview.yuan=qian;
        NSString *LoginName= [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] mName]];

        if(LoginName.length==0){
            myHeadview.nameL.text=@"未认证会员";
        }else{
        myHeadview.nameL.text=LoginName;
        }
        myHeadview.personalImageView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(personalInformation:)];
        [myHeadview.personalImageView addGestureRecognizer:tap1];
        
        [myHeadview.leftBtn addTarget:self action:@selector(privilege) forControlEvents:UIControlEventTouchUpInside];
        
        [myHeadview.rightBtn addTarget:self action:@selector(annuity) forControlEvents:UIControlEventTouchUpInside];
        
        self.headView.frame=myHeadview.frame;
        [self.headView addSubview:myHeadview];
        
//－－－－－－－－－－－－－－－－-----------------------------------------
    
        NSLog(@"self.headIM.frame: %@",NSStringFromCGRect(self.headIM.frame));
        
        for (id subView in self.headView.subviews) {
            if ([subView isKindOfClass:[UIButton class]] || [subView isKindOfClass:[UILabel class]]) {
                [subView removeFromSuperview];
            }
        }        
    }
    else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(toRegister)];
        
        XIBView *view=[[XIBView alloc]initWithFrame:CGRectMake(0, 0, w, h*.26+90)];
        view.backgroundColor=[UIColor whiteColor];
        view.twoDimensionBtn.hidden=YES;
        view.numberL.hidden=YES;
        view.yuan=0;
        view.zhang=0;
        view.nameL.hidden=YES;
        [view.leftBtn addTarget:self action:@selector(hintLogin) forControlEvents:UIControlEventTouchUpInside];
        [view.rightBtn addTarget:self action:@selector(hintLogin) forControlEvents:UIControlEventTouchUpInside];
        self.headView.frame=view.frame;
        [self.headView addSubview:view];

        
        UIImage *unLoginImage = [UIImage imageNamed:@"personal.png"];
        NSLog(@"unLoginImage.size: %@",NSStringFromCGSize(unLoginImage.size));
        self.headIM.frame = CGRectMake(0, 0, SCREEN_WIDTH, unLoginImage.size.height / unLoginImage.size.width * SCREEN_WIDTH);
        self.headIM.image = unLoginImage;
        
        for (id subView in self.headView.subviews) {
            if ([subView isKindOfClass:[UIButton class]] || [subView isKindOfClass:[UILabel class]]) {
                [subView removeFromSuperview];
            }
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((self.headView.frame.size.width - 100) / 2, (self.headView.frame.size.height - 70) , 100, 20)];
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        UIButton *button = [UIButton buttonWithType:0];
        button.frame = CGRectMake((self.headView.frame.size.width - 80) / 2, (self.headView.frame.size.height*.3) , 85, 35);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setImage:[UIImage imageNamed:@"dengru"] forState:UIControlStateNormal];
        button.layer.cornerRadius = 2;
        [button addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        [self.headView addSubview:button];
        
        UIButton *zhuceBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        zhuceBtn.frame = CGRectMake(SCREEN_WIDTH*.8, self.headView.frame.size.height*.13, SCREEN_WIDTH*.2,self.headView.frame.size.height*.1 );
        [zhuceBtn addTarget:self action:@selector(toRegister) forControlEvents:UIControlEventTouchUpInside];
        [zhuceBtn setTitle:@"注册" forState:UIControlStateNormal];
        [zhuceBtn setTintColor:[UIColor whiteColor]];
        [self.headView addSubview:zhuceBtn];
        
    }
    NSLog(@"self.headView.frame: %@",NSStringFromCGRect(self.headView.frame));
    
    self.myTableView.frame =CGRectMake(0, VIEW_H(self.headView), SCREEN_WIDTH, SCREEN_HEIGHT - VIEW_H(self.headView) - 44 );
   
    
}

#pragma mark - 提示登入
-(void)hintLogin{
    if (!_networkConditionHUD) {
        _networkConditionHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_networkConditionHUD];
    }
    _networkConditionHUD.labelText = @"请先登录";
    _networkConditionHUD.mode = MBProgressHUDModeText;
    _networkConditionHUD.yOffset = APP_HEIGHT/2 - HUDBottomH;
    _networkConditionHUD.margin = HUDMargin;
    [_networkConditionHUD show:YES];
    [_networkConditionHUD hide:YES afterDelay:HUDDelay];
}

#pragma mark - 注册
-(void)toRegister {
    
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    
    registerVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:registerVC animated:YES];
    
}
-(void)loginAction {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}



//设置Separator顶头
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 3;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section==1) {
        return 1;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TSFmeCell *cell =[tableView dequeueReusableCellWithIdentifier:@"JFB"];
    if(!cell){
        cell=[[TSFmeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JFB"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if(indexPath.section==0&indexPath.row==0){
            cell.leftimageView.image=[UIImage imageNamed:@"dingdan"];
            cell.lab.text=@"我的订单";
        }else if(indexPath.section==0&indexPath.row==1){
            cell.leftimageView.image=[UIImage imageNamed:@"dingdan"];
            cell.lab.text=@"抵用卷";
        }else if (indexPath.section==0&indexPath.row==2){
            cell.leftimageView.image=[UIImage imageNamed:@"pingjia"];
            cell.lab.text=@"评价";
        }else if(indexPath.section==1&indexPath.row==0){
            cell.leftimageView.image=[UIImage imageNamed:@"shoucangjia"];
            cell.lab.text=@"收藏夹";
        }else if(indexPath.section==1&indexPath.row==1){
            cell.leftimageView.image=[UIImage imageNamed:@"jiangping"];
            cell.lab.text=@"奖品";
        }
}
    return cell;
}

//设置Separator顶头
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - 个人信息按钮点击事件
-(void)personalInformation:(id)per{
    MyInfoViewController *infoVC = [[MyInfoViewController alloc] init];
    infoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:infoVC animated:YES];
}
#pragma mark - 优惠卷按钮点击事件
-(void)privilege{


    myalertView.y = 80;
    [myalertView show:@"暂无红包"];
    
//    RedPacket *view = [[RedPacket alloc]init];
//    view.className =@"MineViewController";
//    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark - 养老金按钮点击事件
-(void)annuity{
    
    MyPensionsViewController *pensionsVC = [[MyPensionsViewController alloc] init];
    pensionsVC.hidesBottomBarWhenPushed = YES;
 
    [self.navigationController pushViewController:pensionsVC animated:YES];
  
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
     if (indexPath.section==1&indexPath.row == 1) {
        //            WebViewController *web = [[WebViewController alloc] init];
        //            NSString *preString = ActivityUrl(MyPrize);
        //            NSString *urlStr = [NSString stringWithFormat:@"%@?m=%@",preString,[[GlobalSetting shareGlobalSettingInstance] userID]];
        //            web.webUrlStr = urlStr;
        //            web.titleStr = @"我的奖品";
        //            web.hidesBottomBarWhenPushed = YES;
        //            [self.navigationController pushViewController:web animated:YES];
        
         [self toOneYuanVC];
     }

    BOOL isLogined = [[GlobalSetting shareGlobalSettingInstance] isLogined];
    
    if (isLogined) {    //已登录
        
        
       if (indexPath.section==0&indexPath.row == 0){
           MyEntityOrderViewCountroller *view = [[MyEntityOrderViewCountroller alloc]init];
           view.hidesBottomBarWhenPushed = YES;
           [self.navigationController pushViewController:view animated:YES];
           
        }
       else if (indexPath.section==0&indexPath.row == 1) {

            myalertView.y = 80;
           [myalertView show:@"暂无抵用卷"];
          
           
           
        }else if (indexPath.section==0&indexPath.row == 2) {

            MyEvaluateViewController *evaluateVC = [[MyEvaluateViewController alloc] init];
            evaluateVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:evaluateVC animated:YES];
            
        }
        else if (indexPath.section==1&indexPath.row == 0) {

       
            MyCollectionViewController *collectionVC = [[MyCollectionViewController alloc] init];
            collectionVC.hidesBottomBarWhenPushed = YES;
            collectionVC.frameBool =1;
            [self.navigationController pushViewController:collectionVC animated:YES];
            
        }
        else if (indexPath.section==1&indexPath.row == 1) {
//            WebViewController *web = [[WebViewController alloc] init];
//            NSString *preString = ActivityUrl(MyPrize);
//            NSString *urlStr = [NSString stringWithFormat:@"%@?m=%@",preString,[[GlobalSetting shareGlobalSettingInstance] userID]];
//            web.webUrlStr = urlStr;
//            web.titleStr = @"我的奖品";
//            web.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:web animated:YES];
            
          
        }

    }
    else {  //未登录
        if (!_networkConditionHUD) {
            _networkConditionHUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:_networkConditionHUD];
        }
        _networkConditionHUD.labelText = @"请先登录";
        _networkConditionHUD.mode = MBProgressHUDModeText;
        _networkConditionHUD.yOffset = APP_HEIGHT/2 - HUDBottomH;
        _networkConditionHUD.margin = HUDMargin;
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 养老金值
-(void)requesPersion{
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:@"MyPersion" object:nil];
     NSString *token = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] pension]];
    NSLog(@"w0----%@",token);
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"MyPersion", @"op", nil];

    NSString *str2 = [NSString stringWithFormat:@"pri/member/old_age_persion.json?token=%@",token];
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL2(str2) delegate:nil params:nil info:infoDic];
}
#pragma mark - 网络请求结果数据
-(void) didFinishedRequestData:(NSNotification *)notification{
    [_hud hide:YES];
    if ([[notification.userInfo valueForKey:@"RespResult"] isEqualToString:ERROR]) {
        if (!_networkConditionHUD) {
            _networkConditionHUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:_networkConditionHUD];
        }
       // _networkConditionHUD.labelText = [notification.userInfo valueForKey:@"ContentResult"];
        _networkConditionHUD.yOffset = APP_HEIGHT/2 - HUDBottomH;
        _networkConditionHUD.margin = HUDMargin;
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        return;
    }
    NSDictionary *responseObject = [[NSDictionary alloc] initWithDictionary:[notification.userInfo objectForKey:@"RespData"]];
    NSLog(@"GetMerchantList_responseObject: %@",responseObject);
    
    if ([notification.name isEqualToString:@"MyPersion"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MyPersion" object:nil];
        if ([responseObject[@"code"] intValue] == 0) {
        
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
            
            NSString *persion = responseObject[@"data"];
           
           
            qian = [persion floatValue];
            
            myHeadview.yuan=qian;
        }else {
            [myalertView show:@"请重新登录以获得准确的养老金！"];

        }
    }
    
}

#pragma mark - 一元抢购
-(void)toOneYuanVC{
    OneYuanBuyingViewController *view = [[OneYuanBuyingViewController alloc]init];
    [self.navigationController pushViewController:view animated:YES];
}

@end
