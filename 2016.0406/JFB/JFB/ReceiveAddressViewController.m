//
//  ReceiveAddressViewController.m
//  JFB
//
//  Created by LYD on 15/8/21.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import "ReceiveAddressViewController.h"
#import "ReceiveAddressCell.h"
#import "AddReceiveAddressViewController.h"
#import "MJRefresh.h"

@interface ReceiveAddressViewController ()<ADDRESSDELEGATE>
{
    MBProgressHUD *_hud;
    MBProgressHUD *_networkConditionHUD;
    NSMutableArray *addressArray;
}

@end

@implementation ReceiveAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"收货地址";
//    －－－－隐藏系统返回按钮
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(getbakeView)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editTableCell)];
    
    addressArray = [[NSMutableArray alloc] init];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"ReceiveAddressCell" bundle:nil] forCellReuseIdentifier:@"ReceiveddrCell"];
    
    [self.myTableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    if ([self.panduan isEqual:@"cao"]) {
          self.extendedLayoutIncludesOpaqueBars=YES;
    }
    
    if ((self.nimabi=@"666")) {
         self.extendedLayoutIncludesOpaqueBars=YES;
    }
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    [self.myTableView headerBeginRefreshing];
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

#pragma mark - 下拉刷新
-(void)headerRefreshing {
    NSLog(@"下拉刷新");
    
    [self requestGetDeliveryAddressList];
}

-(void)editTableCell {
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑"]) {
        self.myTableView.editing = YES;
        [self.navigationItem.rightBarButtonItem setTitle:@"完成"];
        return;
    }
    
    self.myTableView.editing = NO;
    [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [addressArray count];
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 85;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSDictionary *dic = addressArray [indexPath.row];
        ReceiveAddressCell *cell = (ReceiveAddressCell *)[tableView dequeueReusableCellWithIdentifier:@"ReceiveddrCell"];
       int isDefault = [dic [@"markaddress"] intValue];
        NSLog(@"caonima ======%d",isDefault);
        if (isDefault==1) {
            cell.defaultL.hidden = NO;
        }else {
            cell.defaultL.hidden = YES;
        }
        cell.nameL.text = dic [@"consigneeName"];
        cell.phoneL.text = dic [@"mobile"];
        cell.provL.text = dic [@"fullName"];
        cell.detailAddrL.text = dic [@"address"];
        cell.postcodeL.text = dic [@"postcode"];
//字符串拼接出地址
        NSString *my = [NSString stringWithFormat:@"%@ %@",dic [@"fullName"],dic [@"address"]];
        cell.lqAddressMSG.text = my;
        
        return cell;
    }
    else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.imageView.image = [UIImage imageNamed:@"ic_new_address"];
        cell.textLabel.text = @"添加";
        
        return cell;
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
            NSDictionary *dic = addressArray [indexPath.row];
            [self requestDeleteDeliveryAddressInfoWithID:dic[@"id"]];
            [addressArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
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


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {   //进详情修改
        NSDictionary *dic = addressArray [indexPath.row];
        AddReceiveAddressViewController *addVC = [[AddReceiveAddressViewController alloc] init];
        addVC.addressDic = dic;
        addVC.titleStr = @"修改收货地址";
        [self.navigationController pushViewController:addVC animated:YES];
    }
    
    else {  //新增
        AddReceiveAddressViewController *addVC = [[AddReceiveAddressViewController alloc] init];
        addVC.titleStr = @"创建收货地址";
        [self.navigationController pushViewController:addVC animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 发送请求
-(void)requestGetDeliveryAddressList { //获取收货地址列表
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:GetDeliveryAddressList object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:GetDeliveryAddressList, @"op", nil];
    
    NSString *token = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] pension]];
    NSString *url = [NSString stringWithFormat:@"pri/deliveryaddress/list.json?token=%@&page=1&rows=10",token];
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL2(url) delegate:nil params:nil info:infoDic];
}


-(void)requestDeleteDeliveryAddressInfoWithID:(NSString *)addressId { //删除收货地址列表
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:DeleteDeliveryAddressInfo object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:DeleteDeliveryAddressInfo, @"op", nil];
    
    NSString *token = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] pension]];
    
    NSString *url = [NSString stringWithFormat:@"pri/deliveryaddress/delete.json?token=%@&id=%@",token,addressId];
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL2(url) delegate:nil params:nil info:infoDic];

}


#pragma mark - 网络请求结果数据
-(void) didFinishedRequestData:(NSNotification *)notification{
    [_hud hide:YES];
    [self.myTableView headerEndRefreshing];
    
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
    NSDictionary *responseObject = [[NSDictionary alloc] initWithDictionary:[notification.userInfo objectForKey:@"RespData"]];
    if ([notification.name isEqualToString:GetDeliveryAddressList]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:GetDeliveryAddressList object:nil];
        
        NSLog(@"GetMerchantList_responseObject: %@",responseObject);
        if ([responseObject[@"code"] intValue] == 0) {
            _networkConditionHUD.labelText = [responseObject objectForKey:MSG];
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
            
            [addressArray removeAllObjects];
            [addressArray addObjectsFromArray:responseObject[DATA][@"rows"]];
            
            [self.myTableView reloadData];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
  
}

#pragma mark - 返回
-(void)getbakeView{
    [self returnAddress:addressArray];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)returnAddress:(NSMutableArray *)addressArr{
    [_address returnAddress:addressArr];
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
