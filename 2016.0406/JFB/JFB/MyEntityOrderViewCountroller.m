//
//  MyEntityOrderViewCountroller.m
//  JFB
//
//  Created by 积分宝 on 15/12/24.
//  Copyright © 2015年 李俊阳. All rights reserved.
//

#import "MyEntityOrderViewCountroller.h"
#import "MyOrderTableViewCell.h"
#import "PayOrderViewController.h"
#import "SubmitOrderViewController.h"
//#import "OrderDetailViewController.h"
#import "OrderRefundViewController.h"
#import "OrederEntityViewController.h"
#import "AJSegmentedControl.h"
#import "ReplyViewController.h"
#import "VoucherEitiysCell.h"
#import "WuLiuViewController.h"
#import "PayOrderViewController.h"
#define WITH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT  [[UIScreen mainScreen] bounds].size.height
@interface MyEntityOrderViewCountroller ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    MBProgressHUD *_hud;
    MBProgressHUD *_networkConditionHUD;
    NSMutableArray *_orderArray;
    NSArray *_typesArray;   //类型数组
    NSString *statusStr; //订单状态类型
    NSString *is_appraisal; //是否评论
    
    NSDictionary *myprams;
    
    
    NSDictionary *shouHuoDic;
    NSDictionary *removewDic;
    
    NSString *statles;//新接口订单状态
}

@end

@implementation MyEntityOrderViewCountroller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的订单";
    
    //    UILabel *labBeijing = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, WITH, 6)];
    //    _myTableView.backgroundColor = [UIColor colorWithRed:235/255. green:235/255. blue:241/255. alpha:1];
    //    [self.view addSubview:labBeijing];
    self.view.backgroundColor = [UIColor redColor];
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 108, WITH, HEIGHT-108) style:UITableViewStylePlain];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    self.myTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    
    statles = @"";
    NSDictionary *dic1 = @{@"type_name":@"全部"};
    NSDictionary *dic2 = @{@"type_name":@"未付款"};
    NSDictionary *dic3 = @{@"type_name":@"待发货"};
    NSDictionary *dic4 = @{@"type_name":@"待收货"};
    NSDictionary *dic5 = @{@"type_name":@"交易成功"};
    _typesArray = @[dic1, dic2, dic3, dic4, dic5];
    [self createSegmentControlWithTitles:_typesArray];
    
    _orderArray = [[NSMutableArray alloc] init];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editTableCell)];
    
    self.myTableView.tableFooterView = [UIView new];
    [self.myTableView registerNib:[UINib nibWithNibName:@"MyOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyOrderCell"];
    
    statusStr = @"-1";  //全部
    is_appraisal = @"-1";
}

-(void)viewWillAppear:(BOOL)animated{
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    
    
    
    self.extendedLayoutIncludesOpaqueBars=YES; // 解决隐藏导航栏问题
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
    
    [self requestGetOrderList];
    [self.myTableView reloadData];
}

#pragma mark - 自定义segmented
- (void)createSegmentControlWithTitles:(NSArray *)titls
{
    AJSegmentedControl *mySegmentedControl = [[AJSegmentedControl alloc] initWithOriginY:0 Titles:titls delegate:self];
    mySegmentedControl.frame = CGRectMake(0, 64, WITH, 44);
    
    [self.view addSubview:mySegmentedControl];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
}
- (void)ajSegmentedControlSelectAtIndex:(NSInteger)index
{
    NSLog(@"%ld",(long)index);
    switch (index) {
        case 0:
            //全部
            
            statles = @"";
            break;
            
        case 1:
            //未付款
            
            statles = @"created";
            break;
            
        case 2:
            //待发货
            statles = @"payed";
            break;
            
        case 3:
            //待收货
            statles = @"deliveryed";
            break;
            
        case 4:
            //交易成功
            statles = @"finished";
            break;
            
        default:
            break;
    }
    
    [self requestGetOrderList];
}


-(void)editTableCell {
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑"]) {
        
        _networkConditionHUD.labelText = @"未消费订单和已退款订单不能删除！";
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:2];
        
        self.myTableView.editing = YES;
        [self.navigationItem.rightBarButtonItem setTitle:@"完成"];
        return;
    }
    
    self.myTableView.editing = NO;
    [self.navigationItem.rightBarButtonItem setTitle:@"编辑"];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_orderArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  HEIGHT*.3+6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = _orderArray [indexPath.row];
    static  NSString *ss=@"hello wordssss";
    VoucherEitiysCell *cell=[tableView dequeueReusableCellWithIdentifier:ss];
    cell=[[VoucherEitiysCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ss];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    [cell setHeight:HEIGHT*.3+6];
    
    //----------------暂时--------------
    NSArray *arr = dic[@"orderDetails"];
    NSDictionary *xiangQDic;
    if (arr.count>0||arr.count==1) {
        xiangQDic = arr[0];
    }
    //---------------------------------
    
    
    cell.goodsNameL.text = xiangQDic[@"goodsName"];
    cell.priceL.text = [NSString stringWithFormat:@"总价:%@元",dic [@"orderAmount"]];
    cell.numberL.text = [NSString stringWithFormat:@"数量:%@",xiangQDic [@"buyNumber"]];
    [cell.bigIM sd_setImageWithURL:[NSURL URLWithString:xiangQDic[@"goodsImages"]] placeholderImage:IMG(@"bg_merchant_photo_placeholder")];
    cell.nameL.text = dic[@"merchantName"];
    
    self.fraction =dic [@"fraction"];
    
    
    int shuliang = [xiangQDic[@"buyNumber"] intValue];
    float yanglaojin = [dic[@"merchantPension"] floatValue];
    
    
    cell.yanglaoL.text = [NSString stringWithFormat:@"获赠养老金:%.2f元",(yanglaojin * shuliang)];
    
    
    
    
    int status;
    NSString *mystatle = [NSString stringWithFormat:@"%@",dic[@"state"]];
    int  comment = [dic[@"comment"] intValue];
    if ([mystatle isEqualToString:@"created"]) {
        status = 1;//未付款
    }else if ([mystatle isEqualToString:@"payed"]) {
        status = 2;//待发货
    }else if ([mystatle isEqualToString:@"deliveryed"]) {
        status = 3;//待收货
    }else if ([mystatle isEqualToString:@"finished"]) {
        status = 4;//收获成功
    }else if ([mystatle isEqualToString:@"closed"]) {
        status = 5;//已关闭
    }
    NSLog(@"---%d-------",status);
    NSString *statusString;
    
    cell.payBtn.tag = indexPath.row + 100000000;
    cell.logisticsBtn.tag = indexPath.row +999999998;
    
    
    switch (status) {
        case 1: {
            
            [cell.payBtn setTitle:@"去付款" forState:UIControlStateNormal];
            [cell.logisticsBtn setTitle:@"放弃订单" forState:UIControlStateNormal];
            statusString = @"未付款";
            [cell.logisticsBtn addTarget:self action:@selector(removeOrder:) forControlEvents:UIControlEventTouchUpInside];
            [cell.payBtn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
            break;
            
        case 3: {
            
            
            statusString = @"待收货";
            [cell.payBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [cell.logisticsBtn setTitle:@"查看物流" forState:UIControlStateNormal];
            
            [cell.logisticsBtn addTarget:self action:@selector(looKWuLiu:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.payBtn addTarget:self action:@selector(confirmationOfGoodsReceipt:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 2: {
            
            statusString = @"待发货";
            [cell.payBtn setTitle:@"查看详情" forState:UIControlStateNormal];
            [cell.logisticsBtn setTitle:@"联系卖家" forState:UIControlStateNormal];
            cell.logisticsBtn.hidden = YES;
            [cell.logisticsBtn addTarget:self action:@selector(contactSeller:) forControlEvents:UIControlEventTouchUpInside];
            [cell.payBtn addTarget:self action:@selector(lookXiangQing:) forControlEvents:UIControlEventTouchUpInside];
        }
            
            break;
            
        case 4:{
            
            statusString = @"交易成功";
            [cell.payBtn setTitle:@"订单详情" forState:UIControlStateNormal];
            
            
            [cell.logisticsBtn setTitle:@"去评价" forState:UIControlStateNormal];
            if (comment == 1) {
                [cell.logisticsBtn setTitle:@"已评价" forState:UIControlStateNormal];
            }
            [cell.logisticsBtn addTarget:self action:@selector(toReplyViewController:) forControlEvents:UIControlEventTouchUpInside];
            [cell.payBtn addTarget:self action:@selector(lookXiangQing:) forControlEvents:UIControlEventTouchUpInside];
            
            
        }
            break;
            
        case 5: {
            
            statusString = @"已关闭";
            
        }
            break;
            
        case 6: {
            statusString = @"已删除";
        }
            break;
            
        default:
            break;
    }
    cell.tradingParL.text = statusString;
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([statusStr isEqualToString:@"2"] || [statusStr isEqualToString:@"4"]) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = _orderArray [indexPath.row];
    
    NSString *mystatle = [NSString stringWithFormat:@"%@",dic[@"state"]];
    if ([mystatle isEqualToString:@"payed"]||[mystatle isEqualToString:@"deliveryed"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"待发货和待收货订单不能删除" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else  {
        
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            [self DeleteOrderWithOrderNo:dic [@"id"]];
            [_orderArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
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
    NSDictionary *dic = _orderArray [indexPath.row];
    
    //   NSLog(@"%@",dic);
    
    OrederEntityViewController *detailVC = [[OrederEntityViewController alloc] init];
    detailVC.statle =[NSString stringWithFormat:@"%@",dic [@"state"]];
    detailVC.order_no = dic [@"id"];
    detailVC.comment = dic[@"comment"];
    [self.navigationController pushViewController:detailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - 发送请求获取订单列表
-(void)requestGetOrderList { //获取订单列表
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:GetOrderList object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:GetOrderList, @"op", nil];
    NSString *token = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] pension]];
    NSString *url = [NSString stringWithFormat:@"pri/order/list.json?&state=%@&token=%@",statles,token];
    
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL2(url) delegate:nil params:nil info:infoDic];
    
}


#pragma mark - 确认收货请求
-(void)requestGetConfirmReceiptOid:(NSString *)orderId{
    [_hud show:YES];
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:@"ConfirmReceipt" object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"ConfirmReceipt", @"op", nil];
    NSString *token = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] pension]];
    NSString *url = [NSString stringWithFormat:@"pri/order/confirm_receipt.htm?token=%@&orderId=%@",token,orderId];
    
    [[DataRequest sharedDataRequest] postDataWithUrl:NewRequestURL2(url) delegate:nil params:nil info:infoDic];
    
}


#pragma mark - 删除订单请求
-(void)DeleteOrderWithOrderNo:(NSString *)orderNo { //删除订单
    
    
    [_hud show:YES];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedRequestData:) name:DeleteOrder object:nil];
    
    NSDictionary *infoDic = [[NSDictionary alloc] initWithObjectsAndKeys:DeleteOrder, @"op", nil];
    
    NSString *token = [NSString stringWithFormat:@"%@",[[GlobalSetting shareGlobalSettingInstance] pension]];
    
    NSString *url = [NSString stringWithFormat:@"pri/order/delete.htm?token=%@&orderId=%@",token,orderNo];
    ;
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
    if ([notification.name isEqualToString:GetOrderList]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:GetOrderList object:nil];
        
        NSLog(@"GetMerchantList_responseObject: %@",responseObject);
        [_orderArray removeAllObjects];
        if ([responseObject[@"code"] intValue] == 0) {
            
            [_orderArray addObjectsFromArray:responseObject [DATA][@"rows"]];
            
        }
        else {
            _networkConditionHUD.labelText = [responseObject objectForKey:MSG];
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        }
        [self.myTableView reloadData];
    }
    else  if ([notification.name isEqualToString:@"ConfirmReceipt"]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ConfirmReceipt" object:nil];
        if ([responseObject[@"code"] intValue] == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
            [self requestGetOrderList];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    
    if ([notification.name isEqualToString:DeleteOrder]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:DeleteOrder object:nil];
        
        NSLog(@"GetMerchantList_responseObject: %@",responseObject);
        if ([responseObject[@"code"] intValue] == 0) {
            _networkConditionHUD.labelText = [responseObject objectForKey:MSG];
            [_networkConditionHUD show:YES];
            [_networkConditionHUD hide:YES afterDelay:HUDDelay];
            [self requestGetOrderList];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:MSG] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
}


#pragma mark - 确认收货
-(void)confirmationOfGoodsReceipt:(UIButton *)btn{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确认收货吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1000;
    [alert show];
    long int a = btn.tag- 100000000;
    shouHuoDic = _orderArray[a];
    
    NSLog(@"确认收货%ld－－%@",a,shouHuoDic);
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            
            [self requestGetConfirmReceiptOid:shouHuoDic[@"id"]];
            
            NSLog(@"确认收货－－----－");
        }
    }else if (alertView.tag==1001) {
        if (buttonIndex == 1) {
            NSLog(@"删除订单－－----－");
            NSLog(@"---%@",removewDic);
            [self DeleteOrderWithOrderNo:removewDic [@"id"]];
            
            [_myTableView reloadData];
        }
    }
    
    
}
#pragma mark - 联系卖家
-(void)contactSeller:(UIButton *)btn{
    int rowInt = (int)btn.tag - 999999998;
    NSDictionary *dic = _orderArray [rowInt];
    NSString *phoneString = [NSString stringWithFormat:@"%@",dic[@"merchant_mobile"]];
    if (phoneString.length<7) {
        phoneString = @"400-6999-226";
    }
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneString];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
    NSLog(@"联系卖家%d",rowInt);
}
#pragma mark - 查看物流
-(void)looKWuLiu:(UIButton *)btn{
    int rowInt = (int)btn.tag - 999999998;
    NSDictionary *dic = _orderArray [rowInt];
    WuLiuViewController *view = [[WuLiuViewController alloc]init];
    view.express_pycode = dic[@"expressPyName"];
    view.express_no = dic[@"expressOrderNum"];
    [self.navigationController pushViewController:view animated:YES];
    NSLog(@"看物流%d",rowInt);
}
#pragma mark - 放弃订单
-(void)removeOrder:(UIButton *)indexPath{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确删除订单吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1001;
    [alert show];
    long int a = indexPath.tag-999999998;
    
    removewDic = _orderArray [a];
}
#pragma mark - 付款
-(void)payAction:(UIButton *)btn {
    
    int rowInt = (int)btn.tag -  100000000;
    
    NSDictionary *dic = _orderArray [rowInt];
    
    NSArray *arr = dic[@"orderDetails"];
    NSDictionary *oneDic = arr[0];
    NSLog(@"%@",dic);
    
    
    PayOrderViewController *payVC = [[PayOrderViewController alloc] init];
    payVC.orderInfoDic = dic;
    payVC.goods_name = oneDic[@"goodsName"];
    payVC.goods_detail = oneDic [@"goodsTitle"];  //商品描述body
    payVC.amount =[NSString stringWithFormat:@"%@",dic [@"orderAmount"]];;
    payVC.their_type = dic [@"their_type"];
    payVC.merchant_id = dic[@"merchantId"];
    payVC.qtyStr = oneDic[@"buyNumber"];
    [self.navigationController pushViewController:payVC animated:YES];
    //  }
    
    NSLog(@"去付款%d",rowInt);
}
#pragma mark - 查看详情
-(void)lookXiangQing:(UIButton *)btn{
    int rowInt = (int)btn.tag -  100000000;
    NSDictionary *dic = _orderArray [rowInt];
    OrederEntityViewController *detailVC = [[OrederEntityViewController alloc] init];
    
    detailVC.statle =[NSString stringWithFormat:@"%@",dic [@"state"]];
    detailVC.order_no = dic [@"id"];
    detailVC.comment = dic[@"comment"];
  
    [self.navigationController pushViewController:detailVC animated:YES];
    
    NSLog(@"查看详情%d",rowInt);
}
#pragma mark - 评价
-(void)toReplyViewController:(UIButton *)btn{
    
    // NSLog(@"-%@-",orderEntDic);
    int rowInt = (int)btn.tag - 999999998;
    NSDictionary *dic = _orderArray [rowInt];
    
    //－－－－－－临时－－－－－－－－－－－
    NSArray *arr = dic[@"orderDetails"];
    NSDictionary *onedic = arr[0];
    
    
    int comment = [dic[@"comment"] intValue];
    if(comment==0){
        ReplyViewController *replyViewVC = [[ReplyViewController alloc]init];
        
        replyViewVC.goods_id = onedic[@"goodsId"];
        replyViewVC.order_no =  dic[@"orderNum"];
        [self.navigationController pushViewController:replyViewVC animated:YES];
    }else{
        _networkConditionHUD.labelText = @"已经评价过啦！";
        _networkConditionHUD.mode = MBProgressHUDModeText;
        _networkConditionHUD.yOffset = APP_HEIGHT/2 - HUDBottomH-200;
        _networkConditionHUD.margin = HUDMargin;
        [_networkConditionHUD show:YES];
        [_networkConditionHUD hide:YES afterDelay:HUDDelay];
        
    }
}

@end
