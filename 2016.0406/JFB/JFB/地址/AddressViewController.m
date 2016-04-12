//
//  AddressViewController.m
//  JFB
//
//  Created by 积分宝 on 16/1/15.
//  Copyright © 2016年 李俊阳. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressTableViewCell.h"
#import "ReceiveAddressViewController.h"
#define WITH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT  [[UIScreen mainScreen] bounds].size.height
@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate,ADDRESSDELEGATE,adderDataDelegata,FANHUI>
{
    UITableView *tabview;
    MBProgressHUD *_hud;
    MBProgressHUD *_networkConditionHUD;
 
}
@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择地址";
    self.view.backgroundColor = [UIColor whiteColor];
   tabview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WITH, HEIGHT) style:UITableViewStyleGrouped];
    tabview.dataSource = self;
    tabview.delegate = self;
    tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tabview];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 40);
    [btn setTitle:@"管理" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goToReceiveAddressViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem =rightItem;
    
    self.navigationItem.hidesBackButton = YES;
    
    UIButton *fanbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fanbtn.frame = CGRectMake(0, 0, 50, 40);
    [fanbtn setTitle:@"返回" forState:UIControlStateNormal];
    [fanbtn addTarget:self action:@selector(fanHui:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:fanbtn];
    self.navigationItem.leftBarButtonItem = leftItem;
 
}

-(void)fanHui:(UIButton *)btn{
    [self fanhuiAddress:_addressData];
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [tabview reloadData];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
 
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
        [tabview reloadData];
    
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
    
   [self requestGetDeliveryAddressList];    //发起用户信息请求
 
}

-(void)goToReceiveAddressViewController{
    ReceiveAddressViewController *view = [[ReceiveAddressViewController alloc]init];
    view.panduan = @"cao";
    view.address = self;
    [self.navigationController pushViewController:view animated:YES];
}
#pragma mark - 返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _addressData.count;
}

#pragma mark - 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
#pragma mark - 返回cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = _addressData[indexPath.section];
    
    UIFont *font = [UIFont fontWithName:@"Arial" size:17];
    NSString *s = [NSString stringWithFormat:@"%@%@",dic[@"provinceCity"],dic[@"address"]];
    
    CGSize size = CGSizeMake(320,2000);
    CGSize labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    
    
    return   HEIGHT*.11 +labelsize.height;
    
    
}
#pragma mark - 设置tableViewCell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *ss=@"hello word";
    NSDictionary *dic = _addressData[indexPath.section];

        NSString *text = [NSString stringWithFormat:@"地址:%@%@",dic[@"fullName"],dic[@"address"]];
    AddressTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ss];
    
    if(!cell){
        
        cell=[[AddressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
        [cell returnText:text];
    }
    
     cell.defaultIM.image = [UIImage imageNamed:@"default_IM"];
    cell.defaultIM.hidden=YES;
        if ([dic[@"markaddress"] intValue]==1) {
            cell.defaultIM.hidden=NO;
        }
        
   
  
    cell.nameL.text = [NSString stringWithFormat:@"姓名:%@",dic[@"consigneeName"]];
    cell.telL.text = [NSString stringWithFormat:@"电话:%@",dic[@"mobile"]];
   
    return cell;
    
}
#pragma mark - 监听tableViewCell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击cell背景恢复正常状态
      NSDictionary *dic = _addressData[indexPath.section];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self returnSumitAddress:dic];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 表头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 6;
    }
    return 1;
}
#pragma mark - 表尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(void)requestGetDeliveryAddressList { //获取收货地址列表
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:GetDeliveryAddressList object:nil];
    
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:GetDeliveryAddressList, @"op", nil];
    
    NSString *token = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] pension]];

    NSString *url = [NSString stringWithFormat:@"pri/deliveryaddress/list.json?token=%@&page=1&rows=30",token];
    
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL2(url) delegate:nil params:nil info:infoDic];
}
#pragma mark - 网络请求结果数据
-(void) didFinishedRequestData:(NSNotification *)notification{
    [_hud hide:YES];
    
    if ([[notification.userInfo valueForKey:@"RespResult"] isEqualToString:ERROR]) {
        if (!_networkConditionHUD) {
            _networkConditionHUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:_networkConditionHUD];
        }
        _networkConditionHUD.labelText = [notification.userInfo valueForKey:@"ContentResult"];
        _networkConditionHUD.mode = MBProgressHUDModeText;
        _networkConditionHUD.yOffset = APP_HEIGHT/2 - HUDBottomH;
        _networkConditionHUD.margin = HUDMargin;
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        return;
    }
      NSDictionary *responseObject1 = [[NSDictionary alloc] initWithDictionary:[notification.userInfo objectForKey:@"RespData"]];
    if ([notification.name isEqualToString:GetDeliveryAddressList]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:GetDeliveryAddressList object:nil];
        
        NSLog(@"GetMerchantList_responseObject: %@",responseObject1);
        if ([responseObject1[@"code"] intValue] == 0) {
            _networkConditionHUD.labelText = [responseObject1 objectForKey:MSG];
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
            _addressData = responseObject1[@"data"][@"rows"];
            [tabview reloadData];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject1 objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
    }

}
-(void)returnAddress:(NSMutableArray *)addressArr{
    
    _addressData = addressArr;
    [tabview reloadData];
}
-(void)returnSumitAddress:(NSDictionary *)dic{
    [self.mydelegate returnSumitAddress:dic];
}
-(void)fanhuiAddress:(NSMutableArray *)arr{
    [self.fanhuiDelegate fanhuiAddress:arr];
}
@end
